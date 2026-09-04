Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E233A961E;
	Fri,  4 Sep 2026 05:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499093; cv=none; b=uPtK0+LaI9Cdnem+IXo2pVxFSOVs5VKYP4bqITmHAu6nRb3Md8qtMXKgo6z2hfqW/TUebSXNsiUI3mSDy16LxHteZ7EcL3VG2JNfvK8gSeV8l08ExyfG3QrvFW8fCtdVpn1LlpHO9+w76k/Wphvb2uO9/MXJCTENgFWEgUyLGjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499093; c=relaxed/simple;
	bh=jbSOHd7zyLGJe2T2EewhIMF7HHN3RUgL279pj4dl8iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vd6RlEp96QA9Yu/fMxGa35YAoyHD0KRm7n/GzEUumJE84EMS3ig/824V8/oSkNYCwekeoVAlBCiHP8Hxf/HspyM6JzWVrzgFq/buLmiq0OEDESjLlh+hGqLZNwup/+f6gwAWfS5mCJHquOmkxZ5U9XkjBVdaS4JHZNcZOFlb9VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjrj/2tJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjrj/2tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0651F00A3D;
	Fri,  4 Sep 2026 05:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499092;
	bh=y7bATqHQFVirKV5qXsSF2TQk8f5Obs3tqj3Y2b+7paU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjrj/2tJETHbMzVS6AMX70c/ofoPATowP3OoVOMoxGVRaP7EANAzvSqGcHhJA9/2y
	 kvfowu4BypFXJ+XBC62U9016P9DVF/MCqJqrRbLvAfUSctUsUx1pqyue9q5IajruEl
	 WgLK9WXwd9GcoOa6ASMcop1OW1V/JTulZjEC4aMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>
Subject: [PATCH 7.2 294/713] accel/rocket: initialize job domain before cleanup paths
Date: Fri,  4 Sep 2026 06:54:22 +0200
Message-ID: <20260904045810.430932935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Shuvam Pandey <shuvampandey1@gmail.com>

commit 70e6a33d68a9b03335c5426332666e52d07f45d6 upstream.

rocket_ioctl_submit_job() releases rjob through rocket_job_put() on
allocation error paths. rocket_job_cleanup() unconditionally calls
rocket_iommu_domain_put(job->domain), but job->domain is assigned only
after task copying and BO lookups. A failure before that assignment can
therefore clean up a job with a NULL domain pointer.

Take the per-file domain reference before the first error path can release
rjob. Also clear rjob->tasks after freeing it in rocket_copy_tasks(), so
the common cleanup path cannot free the task array again after a task-copy
error.

Fixes: 0810d5ad88a1 ("accel/rocket: Add job submission IOCTL")
Cc: stable@vger.kernel.org
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Link: https://lore.kernel.org/r/6a454b48.6a8fa39a.27019b.984b@mx.google.com
Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/rocket/rocket_job.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/accel/rocket/rocket_job.c
+++ b/drivers/accel/rocket/rocket_job.c
@@ -103,6 +103,7 @@ rocket_copy_tasks(struct drm_device *dev
 
 fail:
 	kvfree(rjob->tasks);
+	rjob->tasks = NULL;
 	return ret;
 }
 
@@ -555,6 +556,7 @@ static int rocket_ioctl_submit_job(struc
 	kref_init(&rjob->refcount);
 
 	rjob->rdev = rdev;
+	rjob->domain = rocket_iommu_domain_get(file_priv);
 
 	ret = drm_sched_job_init(&rjob->base,
 				 &file_priv->sched_entity,
@@ -580,8 +582,6 @@ static int rocket_ioctl_submit_job(struc
 
 	rjob->out_bo_count = job->out_bo_handle_count;
 
-	rjob->domain = rocket_iommu_domain_get(file_priv);
-
 	ret = rocket_job_push(rjob);
 	if (ret)
 		goto out_cleanup_job;


