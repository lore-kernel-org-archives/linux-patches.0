Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C23B4FD27C;
	Wed, 30 Sep 2026 17:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787713; cv=none; b=ESDXtthnLQz2xOm55+yNlE2kdOro5FfbXi6M87n0Y8ulQ+rnjihqsoeSwTLrP/+F/8k7f08UP1MN6jlLMHP6Wf/JiFdGyjWoO6CFdPKA0KX30nQK021/gju9p6/UCbnJIvxgjnmH1kwVm3IJjG49OruYAx6L32puaUVjPDrMEd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787713; c=relaxed/simple;
	bh=UjBuAiOVU4sdFpMOBODiPP/vwJmRxc2F8I2IQ3ByZOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnLt2DXvgo4HP8OQCZH5R/G8qImaHRPlldqbfh4eABX1Al++fZJdOz2t8mpj/VE6rIDV9M27VNOr9SNzTcZeWfqA525bppcdS5hPKfVokKfyjSuaTvjOQDJn9Jip6PBV/HEb+PH2lLWBfZ24FD7Rl03KvrGWyhmz3yYXLREbXYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBAXgiZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBAXgiZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94961F000FF;
	Wed, 30 Sep 2026 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787712;
	bh=53MCLgAA63eLpNFfnx7Mf9Ml6kOhAu8HzQk6qrXEXOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBAXgiZ0Nc47SrQISi4mdZM0HYjx3PkstT/63HU5bs0kC6lj09hmwT7VJT1WPgvc7
	 +yhEgPk9N4v9egGpAhwv1uy32qcIt3iJkfVVNt0b0PNBzK+czGJqfXLueXrH4tj2vZ
	 DXbM3aJ3NbEeZqku74AA4WRsQKo2mIk4Njv0D/YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.2 300/457] drm/nouveau: RCU-free the scheduler-containing nouveau_sched
Date: Wed, 30 Sep 2026 17:26:45 +0200
Message-ID: <20260930152352.506025474@linuxfoundation.org>
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

From: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>

commit f7eae6d8d768fabd6b59779ca7da79e02c74e113 upstream.

struct nouveau_sched embeds a struct drm_gpu_scheduler (base).
nouveau_sched_destroy() calls nouveau_sched_fini() (which does
drm_sched_fini(&sched->base)) and then frees the object with plain
kfree(sched).

drm_sched_fence_get_timeline_name() returns fence->sched->name, and the
scheduler fence keeps a .release callback so it is not ops-detached on
signalling.  A finished fence exported to userspace via drm_syncobj /
sync_file therefore keeps pointing at &sched->base after nouveau_sched_destroy(),
and a later get_timeline_name() -- reachable unprivileged through
SYNC_IOC_FILE_INFO -- dereferences freed memory (KASAN slab-use-after-free
read).

Per the dma-fence lifetime contract the exporter must keep the data backing a
signalled fence alive for an RCU grace period.  Free the scheduler-containing
object with kfree_rcu() instead of kfree().

Fixes: 5f03a507b29e ("drm/nouveau: implement 1:1 scheduler - entity relationship")
Cc: stable@vger.kernel.org
Signed-off-by: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260902012717.880724-1-malhyuk97@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_sched.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_sched.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_sched.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sched.c
@@ -517,7 +517,7 @@ nouveau_sched_destroy(struct nouveau_sch
 	struct nouveau_sched *sched = *psched;
 
 	nouveau_sched_fini(sched);
-	kfree(sched);
+	kfree_rcu(sched, rcu);
 
 	*psched = NULL;
 }
--- a/drivers/gpu/drm/nouveau/nouveau_sched.h
+++ b/drivers/gpu/drm/nouveau/nouveau_sched.h
@@ -98,6 +98,7 @@ void nouveau_job_free(struct nouveau_job
 
 struct nouveau_sched {
 	struct drm_gpu_scheduler base;
+	struct rcu_head rcu;
 	struct drm_sched_entity entity;
 	struct workqueue_struct *wq;
 	struct mutex mutex;


