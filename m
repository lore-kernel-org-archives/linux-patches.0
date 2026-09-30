Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4874EF13C;
	Wed, 30 Sep 2026 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789489; cv=none; b=XW8QmBm5XivuAfbD65Ihps0WsFHZ0fZIAUZvFqT8+lDUNiYhNb9MrvtovckFDiTApJ9qUWgm3rASrF5RF/QlxgRT405+2brXn8yRIHNyT8vwED/GWuN/hjfW9rKbU9e6FwCxsHawK4rXSMFNuWWl2Rsj49gHGMcehpky/z1Ljus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789489; c=relaxed/simple;
	bh=seH0pj2tK5yBZgUX3cOVdjLWUEH+Wqkb6DfuT6MWDzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbqaLweO35W/Q65Fk0kDNKHxVtbp0CRZwCgG3EJymR2vOkm5+iZiE26pQ5fqTbubUjglvYSRX4Zx+Zxqd1x+YhGQaiv3fERhB0DRlWpYAI2XmeRvZoqBou76iCxeT3rT6gZodE4A0EXsUOZJPeiHUSOXPmqNSxqiUpEnvOUC2SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGzhld6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGzhld6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452E81F000FF;
	Wed, 30 Sep 2026 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789487;
	bh=L4cfywGSUTfFUHgAOMMKdPMH1L3boyJfag2+Mbh9i3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGzhld6DWPeq3vzpxVU/GQSKQaZ2UOHp3ogkGz8S3EfbULUOEkmvqk0MU/chbsnm/
	 KXwz75pNf9M3T7/LSH/8EMx8uRWPZrTsYUZyXBJy6nbaTG2dCdFTzGZy7PP8xTvktI
	 gZN6WDtQof9ROZZwbdCUnz+rv4ZEKkqMM0JWuuD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.12 493/877] drm/nouveau: RCU-free the scheduler-containing nouveau_sched
Date: Wed, 30 Sep 2026 17:23:24 +0200
Message-ID: <20260930152425.302204866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -512,7 +512,7 @@ nouveau_sched_destroy(struct nouveau_sch
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


