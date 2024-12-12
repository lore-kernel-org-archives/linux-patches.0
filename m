Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C2E1487CD;
	Thu, 12 Dec 2024 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016824; cv=none; b=n8Go1I+SE9cWtmVRtldfQ0Gd+HvzCPtSIcH4y4NBY+c8HNlTJZJZPDPDAIBhGz23eWiHlNTx4Tgrs91ripFd3lUqH4st5BOyRKTQR6dReitGFNJHiGIyygjn0O2I4g1AtOorWMRRczJ+mrcw+1xOqqaa1WklPBzFEWvP/Z4tDKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016824; c=relaxed/simple;
	bh=fup1lN4VSEo2DLTAWUjtIYU5+Sw8VqQVdZdEH4447TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c8NxKWpV1vVEN7HzHLTBKPvmLwKtO62BFerV7vtJefML/TxfDbQlziUUQ0uCTYQYWtWVlGlUm8fXid5UzQuHpTISGGFfAGBLES9yWp+8qkDY2F2uH2zhs8Wm6F/bS5gsgEZj7uLzKt6YCibd73ESKX0XuaVLMc1Swq+mCqhmFxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocPPKA5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocPPKA5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD62C4CECE;
	Thu, 12 Dec 2024 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016823;
	bh=fup1lN4VSEo2DLTAWUjtIYU5+Sw8VqQVdZdEH4447TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocPPKA5ilh3FAaAyUmgGnJ7P0f/hYvc0BDQk9X5Xm/XFEpZLwCpRScJkvuIxLEp2y
	 Keq4HR9pq2+++knhgmZw7r2hSRKedD22SX6vsPeqdbWKbkJ1zai3nSNlo/LkHyOlJk
	 3BihuF1zs06Dt3U23sXAjKF5TT0pJzlf1TKdWBv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <pstanner@redhat.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/466] drm/sched: memset() job in drm_sched_job_init()
Date: Thu, 12 Dec 2024 15:57:56 +0100
Message-ID: <20241212144318.911949473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e97c6c60bc96e..416590ea0dc3d 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -803,6 +803,14 @@ int drm_sched_job_init(struct drm_sched_job *job,
 		return -EINVAL;
 	}
 
+	/*
+	 * We don't know for sure how the user has allocated. Thus, zero the
+	 * struct so that unallowed (i.e., too early) usage of pointers that
+	 * this function does not set is guaranteed to lead to a NULL pointer
+	 * exception instead of UB.
+	 */
+	memset(job, 0, sizeof(*job));
+
 	job->entity = entity;
 	job->credits = credits;
 	job->s_fence = drm_sched_fence_alloc(entity, owner);
-- 
2.43.0



