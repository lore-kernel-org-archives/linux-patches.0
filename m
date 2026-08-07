Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC2A3A3E7A;
	Fri,  7 Aug 2026 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116335; cv=none; b=Fnw+yaf4NSXBSgHOWjr4Xqj22SRmZabCOY5mZJYQe8NoAZwvAYadAN5Mx0a4ibjcIFK4xbneWy8GlQejsb95Q228UauGXh0bwCCV+pbYIUwamHanI+jXaeBSLuQDLgGhzbiI98fCShGxpe4DOb2HvkvvcRFyG4I3bGQwFbWI0kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116335; c=relaxed/simple;
	bh=4ykZohksBRhhzcL8/8m8cGBh5663ICh8KEMNgctEz1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxCd4KbkBa1oYXoMqmjmQCCi5G5zqIkBLcbblboiTqMmyTHkKmpZGd2Hia80l8lgEwRvsocfLpGHNoUMPudOjz6qLR6W9e/I5mzVFeRA9ZLFXeRmzcpQLNCFFWtKAGNAxiZcbpbpiY48UitdY/oJO2ZM5ylIe8+/HkbMUH0BhS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJdB9ir9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJdB9ir9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0C11F000E9;
	Fri,  7 Aug 2026 15:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116334;
	bh=81hvEw9F59dwgVUGGSa7XqtBybMDeKuvnnrnu4594Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJdB9ir9s59DDX0zMTmXBzUlHc5AFjnViOyBR07KYmPPvEq8i7FzAhpDouDDqqNsk
	 gXt+AWezvWyq6AJ40jX2AqhBfnuJwBcE8FkmFusky35uxuN7TtBTRSspojizSXNr7R
	 gRWJuSJKYTfncCcg5Y+srAOuxqDRCNrzv66gbxPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Deucher, Alexander" <alexander.deucher@amd.com>,
	Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>,
	Kent Russell <kent.russell@amd.com>
Subject: [PATCH 6.6 194/261] drm/amdkfd: fix QID bit leak in pqm_create_queue()
Date: Fri,  7 Aug 2026 16:39:11 +0200
Message-ID: <20260807143419.553843534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>

commit 38b73293f38658a4685ffcea666462024f858ad9 upstream.

When MES is enabled and amdgpu_amdkfd_alloc_kernel_mem() fails during
the first queue creation for a process, pqm_create_queue() returns
early via 'return retval' without going through the err_create_queue
cleanup label.

This means clear_bit(*qid, pqm->queue_slot_bitmap) is never called,
leaving the reserved QID bit permanently set in queue_slot_bitmap.
Over time this leaks QID slots, potentially exhausting all available
queue slots.

Fix this by replacing 'return retval' with 'goto err_allocate_pqn'
so that clear_bit() is always called on the error path without
touching the uninitialized pqn pointer.

AILIKFD-813

Reported-by: Deucher, Alexander <alexander.deucher@amd.com>
Signed-off-by: Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a107f74c38edbb80d6ab64dcaeeb292c14e9779f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -344,7 +344,7 @@ int pqm_create_queue(struct process_queu
 						     false);
 		if (retval) {
 			dev_err(dev->adev->dev, "failed to allocate process context bo\n");
-			return retval;
+			goto err_allocate_pqn;
 		}
 		memset(pdd->proc_ctx_cpu_ptr, 0, AMDGPU_MES_PROC_CTX_SIZE);
 	}


