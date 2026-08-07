Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCE637F334;
	Fri,  7 Aug 2026 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115589; cv=none; b=lKJ60xaktkXz61ukahqKhQTgmMo7orvTDZFcGB6MjAqaFCZlTfQITp7hLcBXkLeWnu4Nu2TfICz+Ql8FL6fQmaGH4x65Z3kEo2eNnda+B7H4BaFNj5u+m2Ib4V4tmmFgIlRLxIEuHTNbuNWfrkt0zYy/3aAclGWPSOKwKm5Y/d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115589; c=relaxed/simple;
	bh=trP5jKdVEorKELDT60eyXmNtz6M/DxsOjunV7G6V/3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFaeCHYE1HiKg1I4EuLeIaQSzfghAmMNV/BfygvC4z0iZQbEfEiJd2ODD6Lqr7mMCaFkvvdNmEKeAdD3ro4CGUOT6FXNwalQ5D94N57lOSjGsihBx2R2wWVR2lFVYkwgL8Md+nmSIO7cimxdLcDTVjMkRaZLmjairdKiU2GYAYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkNkQZb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkNkQZb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1091F000E9;
	Fri,  7 Aug 2026 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115588;
	bh=fZ1Sq06uLIPoRJgKoIRY8xVNHnutgmoQtl/6Edwess4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkNkQZb6z8HkrxCZ46wYggeTRUPIi0GE6SYjBY6A8aI5c75bp+Ci00VuwhfZtX6eu
	 8tXkQkFzCGWOkblLv3enU8WGT4NkSy5hezOZYtBmA+zJQHE7XLNC0ctPTve9vQDl9k
	 sCs/vTifTubX2uD2sWY4Uktr/k/KtQFzdhHziHtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 327/396] drm/amdkfd: fix uint32_t overflow in EOP ring buffer size alignment
Date: Fri,  7 Aug 2026 16:38:07 +0200
Message-ID: <20260807143431.346124865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Palacek <William.Palacek@amd.com>

commit 83463a96ea3c7d8ae636a4d6a0ba63c9ce410724 upstream.

eop_ring_buffer_size in struct queue_properties is a u32. In
kfd_queue_acquire_buffers() the expected EOP buffer size is computed as
ALIGN(eop_ring_buffer_size, PAGE_SIZE); ALIGN uses typeof(x), so the
addition is done in 32-bit. A user-supplied size of 0xFFFFF001 wraps to
0, causing kfd_queue_buffer_get() to skip its exact-size check (gated on
size != 0) and accept any BO mapped at the address. On GFX8/GFX9 the MQD
cp_hqd_eop_control is then programmed for an 8KB EOP ring backed by a 4KB
BO, so CP EOP writes can land past the buffer and fault the GPU.

Cast the operand to u64 so the alignment is computed in 64-bit; the size
check in kfd_queue_buffer_get() then rejects the oversized request.

Fixes: 42ea9cf2f16b ("drm/amdkfd: Relax size checking during queue buffer get")
Signed-off-by: William Palacek <William.Palacek@amd.com>
Reviewed-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ae443117b742c357bfef3a7bddabf76fcf86e9ef)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -285,7 +285,7 @@ int kfd_queue_acquire_buffers(struct kfd
 		}
 		err = kfd_queue_buffer_get(vm, (void *)properties->eop_ring_buffer_address,
 					   &properties->eop_buf_bo,
-					   ALIGN(properties->eop_ring_buffer_size, PAGE_SIZE));
+					   ALIGN((u64)properties->eop_ring_buffer_size, PAGE_SIZE));
 		if (err)
 			goto out_err_unreserve;
 	}


