Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F2040B360;
	Thu, 30 Jul 2026 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421623; cv=none; b=oFRo3mPhnK76XXw+AK8i4eYXCOQJ9wnxg+LLgql7X/J8h+fBdKDQWscfw6KGpLsBlUnzCK2e6pLG2v44iYxfUYAyVXwMuLdMn8Spld3IWCPvcmJa9e7XDpBbNsosto71rWEKWO1GL+nptpyMW0vVK5vwRxT+sG99g8rEg2WdFAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421623; c=relaxed/simple;
	bh=scn4K3OCXbdeL72XIyFmrB+0fAV2V9jAAWlZ5vQhjzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trKvRxYmGYFuhD3oDTJE/SrNIT1m+l7ByouHa9tX6UWAhUqIAqq1t15jOTsygGXTiAUzJRZRvt0Bw8sTtDkimEylbcr4L6PDIVg0Mhb4/3pCwoJzUmx7UW/kCqbrnLo7kAv5AjhRKjXBYlHWx3DjIxWbfQGWjslDH9P5DALfKfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYROQIKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYROQIKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED7A1F000E9;
	Thu, 30 Jul 2026 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421622;
	bh=jLPoiQYUuKW9yBgWLucRJUt+Jr34YQ3iKYvg/J6KOQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYROQIKz8O9mKdlV82v6LdV22YibQRL10q6qZQrXxtUv6GD8vaWvJXhq5i0bDb6z4
	 3Mi3ey1QmD7kUnWER2UZhmbwBQ/yezU8M4DK/3hNmb7X/bQEIyYQXEbMfSTHgmB/Mm
	 ApDQFSq0WoXELQdt22LUjbh94YwIEYwszu3nAhEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 129/744] accel/amdxdna: Fix use-after-free of mm_struct in job scheduler
Date: Thu, 30 Jul 2026 16:06:42 +0200
Message-ID: <20260730141447.022671616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit faebb7ba1ac65fa5810b640df02ce04e509fdc11 ]

amdxdna_cmd_submit() stores current->mm in job->mm without holding any
reference. aie2_sched_job_run() later access job->mm from the DRM
scheduler worker thread. With only a raw pointer and no structural
reference, the mm_struct can be freed before the scheduler runs the job.

Fix this by calling mmgrab() to hold a structural mm_count reference for
the lifetime of the job, paired with mmdrop() in every cleanup path.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260716151305.1595780-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index 5315466f137b55..f6fece060dfedf 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -483,6 +483,7 @@ void amdxdna_sched_job_cleanup(struct amdxdna_sched_job *job)
 	amdxdna_arg_bos_put(job);
 	amdxdna_gem_put_obj(job->cmd_bo);
 	dma_fence_put(job->fence);
+	mmdrop(job->mm);
 }
 
 int amdxdna_cmd_submit(struct amdxdna_client *client,
@@ -549,6 +550,7 @@ int amdxdna_cmd_submit(struct amdxdna_client *client,
 
 	job->hwctx = hwctx;
 	job->mm = current->mm;
+	mmgrab(job->mm);
 
 	job->fence = amdxdna_fence_create(hwctx);
 	if (!job->fence) {
@@ -583,6 +585,8 @@ int amdxdna_cmd_submit(struct amdxdna_client *client,
 cmd_put:
 	amdxdna_gem_put_obj(job->cmd_bo);
 free_job:
+	if (job->mm)
+		mmdrop(job->mm);
 	kfree(job);
 	return ret;
 }
-- 
2.53.0



