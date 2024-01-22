Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E146BB56;
	Tue, 23 Jan 2024 02:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975391; cv=none; b=GXxVlKcKFI+h1OgFzdo/+d3/WFCVjzoT6mLPc8QsLrVAPqLG2u0iOu+RTt7tFIWW+9UUFICwpXd5ossopU9gqlF3tzyV3OXX6UxDDI57VkIqbhb5Ofaffv7hsgblime5jfHKnIKUhT/v0ZJvVBCb5DqUsf0P9bYyX7Fs1uQOqmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975391; c=relaxed/simple;
	bh=3gSlDXo+f3JnD0JXd+zsJZ7Obl547L4QKXVbZxy1PSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax7u0J42hp/HehJt41haxjgmfzVrd4Z5M0YhPHXOUAenZQKG2MrD1RZMbswn+EYl3+qbaoWjTpaW9sGyC47k71PJe0y2f6VBfwUaf+87cqMT5X4AJfElYP7A353U2ntyA22bzc0tIJ14ZoAvkVMscgMYfs+onl3OZMsUp+tDlFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXnuU6NV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXnuU6NV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB461C433C7;
	Tue, 23 Jan 2024 02:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975390;
	bh=3gSlDXo+f3JnD0JXd+zsJZ7Obl547L4QKXVbZxy1PSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXnuU6NVWncVUreSdY6hOEa59IhxSP7ddszUMmhduF2u4dyp4D0URN/pzsZrw577C
	 KNU6biAlP8bQPSdLNPVyKqtlgcFuFZy9PgVKPmWTdqHgKJqxRUlT1frArFNZkkYrbj
	 vpgnQNWwc8UFhR0peWNwOyqU2YW9tua6CogSLIl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Kaibo Ma <ent3rm4n@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 351/583] Revert "drm/amdkfd: Relocate TBA/TMA to opposite side of VM hole"
Date: Mon, 22 Jan 2024 15:56:42 -0800
Message-ID: <20240122235822.760979587@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kaibo Ma <ent3rm4n@gmail.com>

commit 0f35b0a7b8fa402adbffa2565047cdcc4c480153 upstream.

That commit causes NULL pointer dereferences in dmesgs when
running applications using ROCm, including clinfo, blender,
and PyTorch, since v6.6.1. Revert it to fix blender again.

This reverts commit 96c211f1f9ef82183493f4ceed4e347b52849149.

Closes: https://github.com/ROCm/ROCm/issues/2596
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2991
Reviewed-by: Jay Cornwall <jay.cornwall@amd.com>
Signed-off-by: Kaibo Ma <ent3rm4n@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
@@ -330,12 +330,6 @@ static void kfd_init_apertures_vi(struct
 	pdd->gpuvm_limit =
 		pdd->dev->kfd->shared_resources.gpuvm_size - 1;
 
-	/* dGPUs: the reserved space for kernel
-	 * before SVM
-	 */
-	pdd->qpd.cwsr_base = SVM_CWSR_BASE;
-	pdd->qpd.ib_base = SVM_IB_BASE;
-
 	pdd->scratch_base = MAKE_SCRATCH_APP_BASE_VI();
 	pdd->scratch_limit = MAKE_SCRATCH_APP_LIMIT(pdd->scratch_base);
 }
@@ -345,18 +339,18 @@ static void kfd_init_apertures_v9(struct
 	pdd->lds_base = MAKE_LDS_APP_BASE_V9();
 	pdd->lds_limit = MAKE_LDS_APP_LIMIT(pdd->lds_base);
 
-	pdd->gpuvm_base = PAGE_SIZE;
+        /* Raven needs SVM to support graphic handle, etc. Leave the small
+         * reserved space before SVM on Raven as well, even though we don't
+         * have to.
+         * Set gpuvm_base and gpuvm_limit to CANONICAL addresses so that they
+         * are used in Thunk to reserve SVM.
+         */
+        pdd->gpuvm_base = SVM_USER_BASE;
 	pdd->gpuvm_limit =
 		pdd->dev->kfd->shared_resources.gpuvm_size - 1;
 
 	pdd->scratch_base = MAKE_SCRATCH_APP_BASE_V9();
 	pdd->scratch_limit = MAKE_SCRATCH_APP_LIMIT(pdd->scratch_base);
-
-	/*
-	 * Place TBA/TMA on opposite side of VM hole to prevent
-	 * stray faults from triggering SVM on these pages.
-	 */
-	pdd->qpd.cwsr_base = pdd->dev->kfd->shared_resources.gpuvm_size;
 }
 
 int kfd_init_apertures(struct kfd_process *process)
@@ -413,6 +407,12 @@ int kfd_init_apertures(struct kfd_proces
 					return -EINVAL;
 				}
 			}
+
+                        /* dGPUs: the reserved space for kernel
+                         * before SVM
+                         */
+                        pdd->qpd.cwsr_base = SVM_CWSR_BASE;
+                        pdd->qpd.ib_base = SVM_IB_BASE;
 		}
 
 		dev_dbg(kfd_device, "node id %u\n", id);


