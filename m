Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A775172F8;
	Wed, 30 Sep 2026 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787620; cv=none; b=KrEUwR7ohTbarUCC5xoYd4Yd1UkjqYvv5fTCNECDXM0ADfZ3nxMTHpx/1Ic24tPsQRXkuoLEGD36w6tLVWzrDEAQ2bjvZqQfvccNxS7CVHVSV9zp1l3OZsDpanb5JPuTYQdG3B2LZX25z1kVv8DjHVwbU5JEeOW34qnmt28O4Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787620; c=relaxed/simple;
	bh=hjP7c+1McOaw0NrBzfzpJzio+3avByMkSwApPd/0dw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEulDUiF7O94Oem0gI1rkcK4MZP4C6XLlFmrFJxvdejGf3p1bVJACn00GYVR2W5h61m/TFbMXPYaC9g/Zd4cA1YzAsco9qTtNgR2YQSzJLmqLs/Od/t1993NgJ0r+LJDhm2VTbDBjUen6YnzoilJFra8XxNDj918jaucrXuulaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6w7b+in; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6w7b+in"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BD91F000FF;
	Wed, 30 Sep 2026 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787619;
	bh=PtcSF4YF4ZqAnbNsFOxQftY0dARG96UTP7X/aa5+UNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6w7b+inLBlwzgHHHP41e7cTeljS+ELiYFAI69feaoSjqTXYP+l7A8yAxXJORssRi
	 KDL9StzW564E+TNJH1EQbbD5f4m2ZQcnU/bCcEFyhFfacjSiXRfo0JwRVSiDqTNtZq
	 +MyRwTp8G1pmDJdiuStQklCbKEcW3BB5x5ZrX1AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 292/457] drm/amdgpu: move userq fence wait out of signalling section
Date: Wed, 30 Sep 2026 17:26:37 +0200
Message-ID: <20260930152352.337326393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

commit 3022bdfe3e6d776e9273d6892f7c193138ca0666 upstream.

The eviction fence suspend worker waits for every pending userq fence
from inside a dma_fence_begin_signalling() critical section. Waiting on
another DMA fence while responsible for signalling one violates the
cross-driver fence contract and is reported by lockdep as a
dma_fence_map dependency.

Move the wait before dma_fence_begin_signalling(). Keep userq_mutex held
so queue lifetime remains stable while inspecting last_fence.

Fixes: fc61df151617 ("drm/amdgpu: annotate eviction fence signaling path")
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3bd4fbc5ed89621340b5cd249869092691a9c81f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c |    3 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |    4 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h          |    1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
@@ -68,6 +68,9 @@ amdgpu_eviction_fence_suspend_worker(str
 
 	mutex_lock(&uq_mgr->userq_mutex);
 
+	/* Fence waits are not allowed in a fence signalling critical section. */
+	amdgpu_userq_wait_for_signal(uq_mgr);
+
 	/*
 	 * This is intentionally after taking the userq_mutex since we do
 	 * allocate memory while holding this lock, but only after ensuring that
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -1168,7 +1168,7 @@ amdgpu_userq_evict_all(struct amdgpu_use
 	return ret;
 }
 
-static void
+void
 amdgpu_userq_wait_for_signal(struct amdgpu_userq_mgr *uq_mgr)
 {
 	struct amdgpu_usermode_queue *queue;
@@ -1187,8 +1187,6 @@ amdgpu_userq_wait_for_signal(struct amdg
 void
 amdgpu_userq_evict(struct amdgpu_userq_mgr *uq_mgr)
 {
-	/* Wait for any pending userqueue fence work to finish */
-	amdgpu_userq_wait_for_signal(uq_mgr);
 	amdgpu_userq_evict_all(uq_mgr);
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h
@@ -156,6 +156,7 @@ void amdgpu_userq_mgr_cancel_reset_work(
 void amdgpu_userq_mgr_cancel_resume(struct amdgpu_userq_mgr *userq_mgr);
 void amdgpu_userq_mgr_fini(struct amdgpu_userq_mgr *userq_mgr);
 
+void amdgpu_userq_wait_for_signal(struct amdgpu_userq_mgr *uq_mgr);
 void amdgpu_userq_evict(struct amdgpu_userq_mgr *uq_mgr);
 
 void amdgpu_userq_ensure_ev_fence(struct amdgpu_userq_mgr *userq_mgr,


