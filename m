Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034C6427A10;
	Tue, 21 Jul 2026 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661599; cv=none; b=I5T3HRVUvW9W4ZxT6vERp+86N5sQVPaPdXwRtYp3OYTxNO/eJOL376NT404SpPePfdZhlnG+LVHQI/qjZJ6CKAWlgHVa+oLRMnnrk75+1DbcTnjkkgxYdZZ5jzHfAEJeyluOf/26hmjC/4HN3tEg9S1r1Pds72ZZy6+36+fcH/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661599; c=relaxed/simple;
	bh=W3d69mwmoBa3+f3rlSXNDHkbd6il5h3oafTKbjdT92o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pw2WmOpy3zWFCrQ5GEqUBPd4xBdf7eTmT0C5YHvSFWfPvjl+SckZ5A6RGPuL6qELJgd5J3UG4cqKqcT4T1BB4gwSYagEKLH06bpdge1NxGQI8uEBTyRDjOVCvrpXaZuYNeTcRUlJU/7Lucgd1vZSWhCXUxB/9iZFk0lpZw5cupc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgMM8S3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgMM8S3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F111F000E9;
	Tue, 21 Jul 2026 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661597;
	bh=Bf29iQmRH3nbZMJ70HpZ5MN3Lmb39HBd1ndq5iH40DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgMM8S3CiRPYovzrw+qKTSqmD5beRAmekKxVvFZzHeB7jYASir7X9HT6Twc37ACUJ
	 m4TSHt7HhFkuMvbazvXL2xFbANPftdgQMQp7Atr0r1MzA+WoNiXZVw5v+F3Y29ioB1
	 LeeYl343NwEXx7radVBs1idphlN0K8frIAESnLjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Erik Kurzinger <ekurzinger@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0126/1276] drm/syncobj: Fix memory leak in drm_syncobj_find_fence()
Date: Tue, 21 Jul 2026 17:09:29 +0200
Message-ID: <20260721152448.924027774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Liviu Dudau <liviu.dudau@arm.com>

[ Upstream commit e5b93bd6fdb92aa5e4689715d7e8487d9ce66a38 ]

Commit 18226ba52159 ("drm/syncobj: reject invalid flags in
drm_syncobj_find_fence") forgot to take into account the fact that
drm_syncobj_find() takes a reference to syncobj and returns early
without dropping the reference, leading to memory leaks.

Fixes: 18226ba52159 ("drm/syncobj: reject invalid flags in drm_syncobj_find_fence")
Reported by: Sam Spencer <sam.spencer@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Acked-by: Erik Kurzinger <ekurzinger@gmail.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/all/20260507144425.2488057-1-liviu.dudau@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_syncobj.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index 4f2ab8a7b50fde..effa2e31263ba4 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -441,13 +441,15 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
 	u64 timeout = nsecs_to_jiffies64(DRM_SYNCOBJ_WAIT_FOR_SUBMIT_TIMEOUT);
 	int ret;
 
-	if (flags & ~DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT)
-		return -EINVAL;
-
 	if (!syncobj)
 		return -ENOENT;
 
-	/* Waiting for userspace with locks help is illegal cause that can
+	if (flags & ~DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Waiting for userspace with locks held is illegal cause that can
 	 * trivial deadlock with page faults for example. Make lockdep complain
 	 * about it early on.
 	 */
-- 
2.53.0



