Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF61C314A95;
	Fri,  7 Aug 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114418; cv=none; b=aKAQfZ57wiAq5LWad/ulGwS6kDpT0KyKxzauYkR8cI7lKOEPhwtS+1pPioSNxaCoNREk9oxmU7uJVdaHYrvPAK7nZ7B70jqYylaHwl1AOLmlEz9iAudj2Ub22MJyrT7I6RZ1GjituXPOrnIk0MmIn5vRSxQC+sSjTZN2iYjxZTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114418; c=relaxed/simple;
	bh=up4SeTjhrKhnuXxpS/trvkdIDUoKzT6nfI7YghGT4mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDqkzOk6tXnnciJ+IvbDoQe7QxmsKZrWdTVtB5tYNCl7K3TUPwYbqE7uQGh0JnaJse4nxlv5d92CQfttMnmp4UXVBpQdKdF5W10Vf2AKO6bsSVWifOIIimBG+5v7ylsbw2DHdPawqIA0vZaMJUC8FCebRRbxzcGsEZmF7qtTIKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zs5yKmB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zs5yKmB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2571F000E9;
	Fri,  7 Aug 2026 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114416;
	bh=6BDppqoI8nzonFEyqpr3JUcuoaQjlP4RjKtUzEeorFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zs5yKmB3wjOSBptYE9Zxf+1RXhHXnLA3JNXc7+DtTZCnH5zDaBSTVTFwEjkNj9itF
	 p1ogLMdV9d4tO+rbkbQRnlbJlZAsDvLd+AFIYGJfD2b3e0OMrdddZ3srl3674st5iH
	 cplqfHtzfZ07/OMOjdAsBorrny7Ju5AAoo21i+98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Deucher, Alexander" <alexander.deucher@amd.com>,
	Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>,
	Kent Russell <kent.russell@amd.com>
Subject: [PATCH 6.12 255/337] drm/amdkfd: fix QID bit leak in pqm_create_queue()
Date: Fri,  7 Aug 2026 16:37:38 +0200
Message-ID: <20260807143424.073678160@linuxfoundation.org>
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
@@ -376,7 +376,7 @@ int pqm_create_queue(struct process_queu
 						     false);
 		if (retval) {
 			dev_err(dev->adev->dev, "failed to allocate process context bo\n");
-			return retval;
+			goto err_allocate_pqn;
 		}
 		memset(pdd->proc_ctx_cpu_ptr, 0, AMDGPU_MES_PROC_CTX_SIZE);
 	}


