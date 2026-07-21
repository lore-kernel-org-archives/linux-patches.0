Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A21546AA70;
	Tue, 21 Jul 2026 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648074; cv=none; b=LOCaGyyIkSIJNCB6Qvopn5sPTtjE/DUmqgTFYUxbBDkcT8dog8UEnqbyvWPGH96f7dz7B/FkuDCsda9Ua2kpu0enTWs7XfTOd3IJxflbMS2mafH60gFs+6g+3bm7BZBiwWaRoHSX4DPYemwE6cY7P10KjHoMKDD5kHhweYNEWnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648074; c=relaxed/simple;
	bh=zfZAjijI7JwSSOQPZPzB3eAvTuOxtFx3deqPSvbq7uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqfqwjG/bl3gruwbOgZ89Plp1IUaqbu9qZvAr2selZaYTmuZfY2LLo+dzsX0fBTfZFGwDljWwYoM35fzKm3/1ssviKehJ/ykKjdo/lP2LRDob/0HtbR4Y0dsL1muOlMsepss6983V4r4/SvB+Epj/Kc7R23fUfJ+RlC/s8f3PXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPBur3rB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPBur3rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC981F000E9;
	Tue, 21 Jul 2026 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648073;
	bh=ojfLgCWxv+MkMmoPeGj6a+pDweD3LjBJlmpwmX7PCiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPBur3rB4hxHWYbG2UlMihD1whcr+WWmK6D4wmhTnnfyekHxSDz8AJfhuWhmH2OzX
	 Q1mU5x1dCjxVlOXmEgxDh14TLTcFsG8KLStFNicqZ92hA9EBzXAC6XATSYh2r7bar7
	 8MM2nG4ej1AA1fimOTOENIwAd9v6CIUQWeM+wa+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Sierra <alex.sierra@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0062/2077] drm/amdkfd: fix redundant MQD iterations in GFX v12.1
Date: Tue, 21 Jul 2026 16:55:35 +0200
Message-ID: <20260721152554.156451114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Sierra <alex.sierra@amd.com>

[ Upstream commit 9315a1e2bdf1ba4aace856cabcb5f9f3a5c09202 ]

The init_mqd_v12_1 function and its sub-call update_mqd_v12_1 both independently
iterate over XCC-specific MQDs. This nested iteration is redundant and can cause
MQDs in different queues to be overwritten. This patch removes the duplicate
loop logic to prevent queue corruption.

Fixes: 01bbc4a4b947 ("drm/amdkfd: Add MQD manager for GFX 12.1.0")
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
index c90c0d99b1e3f3..475589b924e90a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
@@ -32,6 +32,10 @@
 #include "amdgpu_amdkfd.h"
 #include "kfd_device_queue_manager.h"
 
+static void update_mqd(struct mqd_manager *mm, void *mqd,
+		       struct queue_properties *q,
+		       struct mqd_update_info *minfo);
+
 static inline struct v12_1_compute_mqd *get_mqd(void *mqd)
 {
 	return (struct v12_1_compute_mqd *)mqd;
@@ -215,7 +219,7 @@ static void init_mqd(struct mqd_manager *mm, void **mqd,
 	*mqd = m;
 	if (gart_addr)
 		*gart_addr = addr;
-	mm->update_mqd(mm, m, q, NULL);
+	update_mqd(mm, m, q, NULL);
 }
 
 static int load_mqd(struct mqd_manager *mm, void *mqd,
-- 
2.53.0



