Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D87746A5E2;
	Tue, 21 Jul 2026 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648633; cv=none; b=niW9VKbPxvYfkGjZGULnXeffUd9zGDWEXFxzcQ/V3NvEHMzDoyVgpgaLayxKfsShu3KFaFbyfjbE13BB7pRAbVDmtryuwV4EaY4oU82iHkzYszfbEF+YXvUBXorhwvYodBzZpKxy08TnwNOaLUKrWGm1VGCqowYj+BTT/PXST9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648633; c=relaxed/simple;
	bh=sPCEh7RPKg59zBzlYCg9npb8t7Iyx138YYQXWe7yeYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxCQ9678e51Nch5vhrSjdK8iFq6zErzmgVwqQsFK1YtCE2G//9WlppIWR9q1LbE2nOct3TSlISltUAU0mI6aSnG96TDzSqPCgf7PaTSV8UPujCJWRPckUGtO+1FcUkGZyvX9366fJui46yoX6gwZmnUI5GXZojlC0LJGzcgci84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+CAwZ0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+CAwZ0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34FD1F000E9;
	Tue, 21 Jul 2026 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648632;
	bh=Qs1Rl7R/sAR/KeI2bpjymYaOpuStTNz06vw0flr/xY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+CAwZ0wRJJbTakmux+XvWVQtGg0wOgbiZWsnsVw42OurzuV1gy1306aipBBC2/zQ
	 vOC0jbrCusg7HNg9I6wFH1QvlCDJgm3lMKYgPW/zKqbqc4QBbKABBx/c77ppmSVyQv
	 QiNxOUbyOZIRT4dsCqeN030jpyKKcRmgnzmYgqzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Erik Kurzinger <ekurzinger@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0229/2077] drm/syncobj: Fix memory leak in drm_syncobj_find_fence()
Date: Tue, 21 Jul 2026 16:58:22 +0200
Message-ID: <20260721152558.078534569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index 8d9fd1917c6e64..c9dbf64c0c9f2c 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -442,13 +442,15 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
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



