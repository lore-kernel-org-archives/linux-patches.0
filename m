Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE62215774;
	Thu, 12 Dec 2024 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018235; cv=none; b=Nst4ULtjGyDkY+l4G2uKb8fwVVgOYgY8TZWvAAPmnNk+N4IOMEVvvnGyhyGBwyzBFvAXUpAZnbYE10ULRnEu/cuh0UIgiXMyeEt5b/HtyNIpBx6y1+BeenBF6vJvehthorgph9EXbgSAu+fuqLznG51r4u8WlgF0/YozsVPpVpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018235; c=relaxed/simple;
	bh=OEBgii6E3+lDXv8qYuoJbbk0f0SLYa/OgVqkc53R2is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGndh8Ru57dAcg8pNd0eOTbn7j2i2wwhDcXCuCjgkHj403gIKYRFtu+t/iEU5ONYHm9H5iVoYYQz0RXwoRx9qV0CE133Vx4NogfBU+CkJt74mHE1bbjOEMecHyvSbbCc+gGH1GToxiIpzCYjg4AYNBeoY+9ymOprgwwt2ZaHTRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxBz2SJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxBz2SJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6476C4CECE;
	Thu, 12 Dec 2024 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018235;
	bh=OEBgii6E3+lDXv8qYuoJbbk0f0SLYa/OgVqkc53R2is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxBz2SJNtPJhGMoJrtVS5ZB9TWpeGzvkh/Pik2dY00IPqk7Zu8qXvg+YYiTgE3pvJ
	 W1t1LfJZj/JNzm3AciBiAKRE2Ju144PQLjnRlNl3Fy05JRcnEbFoGXIRvWDQoz18gA
	 98M9u8M4s9BPkbSIagI6vmNbs0lAup3aCOCKhVEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <pstanner@redhat.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/356] drm/sched: memset() job in drm_sched_job_init()
Date: Thu, 12 Dec 2024 15:59:16 +0100
Message-ID: <20241212144253.980302811@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a3a622fc672f..fa4652f234718 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -635,6 +635,14 @@ int drm_sched_job_init(struct drm_sched_job *job,
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



