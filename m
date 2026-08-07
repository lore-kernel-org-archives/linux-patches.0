Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639B368276;
	Fri,  7 Aug 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114423; cv=none; b=YMe69i/m4XcV6eNgFsSP9ao3kLRL+1bYDead0Llt/WrT3vJNiwws/E05CXNH5WGTcWEP4bHv65AJIBH7FgJx5wzA5UJc0GRVo+1RQlO2wyRKdV/27uMCzT3y8sC3s+edhuQkKNBxKAFGrvjcIsdZJY8v9Z/EnLTspKUezSPsqJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114423; c=relaxed/simple;
	bh=fEv3h0lI/jNDMQvKpa+PMmqOwxI802vWXbjRrktpX/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcffTPnEdwjEeBZWfsSnmEmXzwRT32XmZqk5c68l2rWMt4DpdirUovgvkCYe8Hr+SY0FZpGlOVqPL0305hqMDY1sNMwbmuxY57R1fVb+reN8xepIDqnJ2PywMekBACK3sblFvUlCRJDio6UJ7Qyt/5uYFMY8MuTxmRAyeB5VKiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNmla+tB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNmla+tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC2D1F000E9;
	Fri,  7 Aug 2026 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114422;
	bh=7oZsef3UouQPS/0BjQ9feCY6hK4IfFRTfVmm456DVbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNmla+tB5LPtFXcxku5FzhMch+LEdwv9MOo9hfeJLnJJKzj6/7FS+9Jj7Z4oJpCSx
	 cn0ZtX1cvFpLK2mYTC0qaR3tnPlQnMclFCseE4bWbfn/G1j4DbmAEQps9dCD7K/aIY
	 1Ov6RCJHqk+TzIkZtjsnfOA6ZHScxuIAGd1PYkGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 256/337] drm/amdkfd: fix uint32_t overflow in EOP ring buffer size alignment
Date: Fri,  7 Aug 2026 16:37:39 +0200
Message-ID: <20260807143424.095511049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


