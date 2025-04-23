Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85C828F924;
	Wed, 23 Apr 2025 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420910; cv=none; b=i7gnC+SbqsGZQUGUAMN4UCl6gZ2ERK1yLN9IRui8dBNFP2KZpbfCgwuQ4YuhalL416g9OVAtNGhI7neqSNnfjIKVIBPoFYVlOW1cLHbIE5Fsw8ho+hQ/YLUZ6H2R3YefkpLFepMCz1nospObK9aOPueF8jsQidVjkRwgov5NSBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420910; c=relaxed/simple;
	bh=KyhZhE5dGqhMWH08K+wcXac2IeNyZPvM9BArz5Vsvqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlrHui5W/jwMTDvKxfxlaUVDPHd/0RehBXOMMgxlB9biM9wZsiiPRJprzHkMEouIcRUZsl3fWjCcRigU917Tz5wzNbYH8k0h0kk77SG7s4Qu1W3gMN5G1N/sjW5NTUCqV7kbuwcBNEc1vjQ+/rfrf1c4Wr9pVDja4+0OGJL/OpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwkY40EI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwkY40EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4F3C4CEE2;
	Wed, 23 Apr 2025 15:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420910;
	bh=KyhZhE5dGqhMWH08K+wcXac2IeNyZPvM9BArz5Vsvqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwkY40EIzn2pcyUhLzd9MACd4k3aT6ds/Vlup9XIKI1evzqtUtQoRdDfuY9wY00lv
	 Z+OBhXxqkPg/lzWlSu7CQbI6CLrVUqO3jG+7Kn3jmp4VfoFwPEbw0Hk51UFxHELT+I
	 uyrgkeu9pUemMGlp/+dCwIM9+QJOIlDegYrhqdeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan King <brendan.king@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.12 173/223] drm/imagination: take paired job reference
Date: Wed, 23 Apr 2025 16:44:05 +0200
Message-ID: <20250423142624.208735912@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Brendan King <Brendan.King@imgtec.com>

commit 4ba2abe154ef68f9612eee9d6fbfe53a1736b064 upstream.

For paired jobs, have the fragment job take a reference on the
geometry job, so that the geometry job cannot be freed until
the fragment job has finished with it.

The geometry job structure is accessed when the fragment job is being
prepared by the GPU scheduler. Taking the reference prevents the
geometry job being freed until the fragment job no longer requires it.

Fixes a use after free bug detected by KASAN:

[  124.256386] BUG: KASAN: slab-use-after-free in pvr_queue_prepare_job+0x108/0x868 [powervr]
[  124.264893] Read of size 1 at addr ffff0000084cb960 by task kworker/u16:4/63

Cc: stable@vger.kernel.org
Fixes: eaf01ee5ba28 ("drm/imagination: Implement job submission and scheduling")
Signed-off-by: Brendan King <brendan.king@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://lore.kernel.org/r/20250318-ddkopsrc-1337-use-after-free-in-pvr_queue_prepare_job-v1-1-80fb30d044a6@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_job.c   |    7 +++++++
 drivers/gpu/drm/imagination/pvr_queue.c |    4 ++++
 2 files changed, 11 insertions(+)

--- a/drivers/gpu/drm/imagination/pvr_job.c
+++ b/drivers/gpu/drm/imagination/pvr_job.c
@@ -684,6 +684,13 @@ pvr_jobs_link_geom_frag(struct pvr_job_d
 		geom_job->paired_job = frag_job;
 		frag_job->paired_job = geom_job;
 
+		/* The geometry job pvr_job structure is used when the fragment
+		 * job is being prepared by the GPU scheduler. Have the fragment
+		 * job hold a reference on the geometry job to prevent it being
+		 * freed until the fragment job has finished with it.
+		 */
+		pvr_job_get(geom_job);
+
 		/* Skip the fragment job we just paired to the geometry job. */
 		i++;
 	}
--- a/drivers/gpu/drm/imagination/pvr_queue.c
+++ b/drivers/gpu/drm/imagination/pvr_queue.c
@@ -866,6 +866,10 @@ static void pvr_queue_free_job(struct dr
 	struct pvr_job *job = container_of(sched_job, struct pvr_job, base);
 
 	drm_sched_job_cleanup(sched_job);
+
+	if (job->type == DRM_PVR_JOB_TYPE_FRAGMENT && job->paired_job)
+		pvr_job_put(job->paired_job);
+
 	job->paired_job = NULL;
 	pvr_job_put(job);
 }


