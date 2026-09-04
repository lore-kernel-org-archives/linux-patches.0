Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD9735AC03;
	Fri,  4 Sep 2026 05:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500953; cv=none; b=uMtQGW3KiMC4KSTvQYryAIla9vpjd+kKUrbDlfXOm4jg5eNAmn2MDvUZHlY3EXAs3DFYoKVOzRSuAAOCd2YyJZ5+yMWmItmlIYaxhcE9BzENl+X3nlcxEu3uBeaKyEmwQAWE7Ybm2XhlvXhZrw7sgzAX6o7gnTs7qh0vUz/2M70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500953; c=relaxed/simple;
	bh=t74MXM2QyhYnPkyYvQoGJoIIXEjMjb+czDQo9WhKgZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRUvpthp48yYioe5w74AwZsiZ1J3YFn4KpJ226R11T6eL5KFJEaGjwsXgZXV+w+enC7jAZK8nC4wWOFELdpGJKmeZcVYrxsi2+Uq0SJWM8I5IyyuDp0BdG5kLd/RuqEToAvycO1RKfyyKZy4Au2r8ePCOi1IrMPsr77Uki45Ws0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plY1jjaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plY1jjaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3F61F00A3D;
	Fri,  4 Sep 2026 05:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500952;
	bh=9351m2xPzQnyO/pdeZD1rBwkGbfrBZDRb7A8Mu8bbDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plY1jjaYl97vGIrDhFla1S5w4/KYjkmylBeafNJ1FnINLHqHSBnn6TkUagWf77yHL
	 /bnCXl0XxbyCtaPUpRkpYiOmft5V1Vu5FzWmranjKyOsJkfd3DNh1Gvr1IXeyW3rKs
	 6b0tE45KDbMbegPFM9dJm38iGx+4T3HMECZcOkJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>
Subject: [PATCH 6.18 211/552] accel/rocket: initialize job domain before cleanup paths
Date: Fri,  4 Sep 2026 06:56:08 +0200
Message-ID: <20260904045754.142157285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -556,6 +557,7 @@ static int rocket_ioctl_submit_job(struc
 	kref_init(&rjob->refcount);
 
 	rjob->rdev = rdev;
+	rjob->domain = rocket_iommu_domain_get(file_priv);
 
 	ret = drm_sched_job_init(&rjob->base,
 				 &file_priv->sched_entity,
@@ -581,8 +583,6 @@ static int rocket_ioctl_submit_job(struc
 
 	rjob->out_bo_count = job->out_bo_handle_count;
 
-	rjob->domain = rocket_iommu_domain_get(file_priv);
-
 	ret = rocket_job_push(rjob);
 	if (ret)
 		goto out_cleanup_job;


