Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86143213E6B;
	Thu, 12 Dec 2024 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021223; cv=none; b=taimKP5FMK5thlFJtdU44M0/H9iuZmZ/h74I/KS9Yj7dg4phuPpJphDs+pRozdbqFLrOoPvwFuQKZCNgn/27zC+UrdnuvGatdcxA7zyV3FXvfR8Qd6J311Cbg/dpSnvQqmcOJps8bN75UM9IV4os4WT68lxFAwIo8iXCRbUqL5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021223; c=relaxed/simple;
	bh=Y4PDgWnkIWr/+ARIc0mbLWMgTM7UOUMhBN//Kyl3M5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oehopo9AVQ2iGR7o9nsfV0cwoDXESq57hiEN/ojlIpam81hlgleiuDXPPPH3hRLaXCsfBWmvl+B3oiSc/+C951fTLG6lAz+ti0IjrbbZ8QsvfZpMzCJN58Mc1d7DPQLQMmDh+pDGRy+x2UIeHJD8v3MWpAZrU/j92tbVCEAbou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFFIfSlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFFIfSlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3F8C4CECE;
	Thu, 12 Dec 2024 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021223;
	bh=Y4PDgWnkIWr/+ARIc0mbLWMgTM7UOUMhBN//Kyl3M5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFFIfSloznaJp/g2CKdeXFsW0BEAtTdcxDzMpGn+cRxyd85T9NRXddIwH0WoHwXvC
	 UmgpiFA8bimryna6rtmFYYIgtIooim5v4U9LG14klGOjscQKWxpL29pcz+61EN/FU3
	 M0Yel8ZDocdBDA9IgP92lxok7pnPh2yRyXmNWjIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <pstanner@redhat.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 678/772] drm/sched: memset() job in drm_sched_job_init()
Date: Thu, 12 Dec 2024 16:00:23 +0100
Message-ID: <20241212144417.936119248@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit 2320c9e6a768d135c7b0039995182bb1a4e4fd22 ]

drm_sched_job_init() has no control over how users allocate struct
drm_sched_job. Unfortunately, the function can also not set some struct
members such as job->sched.

This could theoretically lead to UB by users dereferencing the struct's
pointer members too early.

It is easier to debug such issues if these pointers are initialized to
NULL, so dereferencing them causes a NULL pointer exception.
Accordingly, drm_sched_entity_init() does precisely that and initializes
its struct with memset().

Initialize parameter "job" to 0 in drm_sched_job_init().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241021105028.19794-2-pstanner@redhat.com
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index f138b3be1646f..dbdd00c61315b 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -595,6 +595,14 @@ int drm_sched_job_init(struct drm_sched_job *job,
 	if (!entity->rq)
 		return -ENOENT;
 
+	/*
+	 * We don't know for sure how the user has allocated. Thus, zero the
+	 * struct so that unallowed (i.e., too early) usage of pointers that
+	 * this function does not set is guaranteed to lead to a NULL pointer
+	 * exception instead of UB.
+	 */
+	memset(job, 0, sizeof(*job));
+
 	job->entity = entity;
 	job->s_fence = drm_sched_fence_alloc(entity, owner);
 	if (!job->s_fence)
-- 
2.43.0



