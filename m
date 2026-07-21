Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA78646C4DA;
	Tue, 21 Jul 2026 17:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655836; cv=none; b=bWWAIDoYx2Zh1lkqRYelpl7eweoZ0SPfBxK9bRKcQdhvOtFxGLxeRnLtmqEFQzlwT5LJPlZTzSFSElZRd+TdNlqoiWHQGqoKJWTC3GhosPmh0ULlnG4m4zz2wkghvuDeJ1TP7B6oWNASYE0dxq9HfTeuWoy1W5tOgKAG6xHm3sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655836; c=relaxed/simple;
	bh=hPdIoMEssMmZE3FjDF6CkkR5m3C2gmQrgNQ2nugADUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEo8iSLr5iCBnYRfW5el26C1LdUtIUoBqocyxuVO5SlVRvsRqvMctDwweJJkm/tHDQvcdVRm1d89dNVow/1wpD1ieexh/YurDQipaANsOxGDMpuxDcd7tD6dwM4b829Jet7FN4EM3GRVstoFZjNFPUvyk7iVhKFCsjqf1Sa37m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auBmlR+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auBmlR+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102831F000E9;
	Tue, 21 Jul 2026 17:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655834;
	bh=vZ9h40sY2FSaYLRESjZWaEpK9cnTt778Q8GTeM2AC+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auBmlR+SAKYhJ2CLfU39QzF/fAhFdO5ivOfvvJOwYbRA0zWh73lxXduASX/100+pB
	 7Tfi7yDftaAVcEzZT4ahH1R96AJ1zJ+i+nXW5iuqxgncCwQ9fq8bLHY1psbnr7byI1
	 m1WXRoPuekIS9QIEfvEZSJ+pGcEPY7ICQc9Ug0Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Erik Kurzinger <ekurzinger@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0160/1611] drm/syncobj: Fix memory leak in drm_syncobj_find_fence()
Date: Tue, 21 Jul 2026 17:04:36 +0200
Message-ID: <20260721152518.482887219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 7eb2cdbc574a02..c0cb7d79672d84 100644
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



