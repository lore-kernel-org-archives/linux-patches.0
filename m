Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C071EF0A1;
	Tue, 15 Oct 2024 11:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992404; cv=none; b=pAx/WKZWrTBL3xucjGQL0Q686HYQ4m4tXQwG6zFAu4gCFjgW0Jsoc/1D5Y0AF4dMgfoDbLsLECiU4Cy/2vxsfE+Hp7MvZeFzkVI93u0gkc6EOPXavBYEdlPO9J1LuxZwtI7esMFBxejKnvzWFvh3/dAzJg2mWB0pXGK45Lfqfhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992404; c=relaxed/simple;
	bh=0Jbpeerxt/6n+ZJldJpq134ML56hInQ3D0OMDI5rqlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrplVM4EmkKntOKmfUkQrQYyt12DcNDWyCaTqZrg53j4S8M27g6UcmzeKakyhxdrF3PIeTvc8r5ec8J6GlSD8XnWYGLeeZHZCTvFPRC3noV07DZZOJv+xaOWG5VMSsTbwM/gjxFvx5e2zQuCSakuvRqlI1Xb1N89B2a3gRX0CkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0pp3yId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0pp3yId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0017EC4CEC6;
	Tue, 15 Oct 2024 11:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992403;
	bh=0Jbpeerxt/6n+ZJldJpq134ML56hInQ3D0OMDI5rqlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0pp3yIdQrscdYWQjpKvV9+7hp2BpsTmJjRA3zoPyG1MLUOBjMyk4Zg2Zziy2Qjrc
	 dbwB/llAmn+RmyvJ0eQezpb2Xj5j9FjD2AuNrywXx+/Oba3luiPDmfaeOGwQglachE
	 AgCsfZROBWela53LEQZSYz/4AJjODvogPxn9Mp7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Hering <olaf@aepfle.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/691] mount: handle OOM on mnt_warn_timestamp_expiry
Date: Tue, 15 Oct 2024 13:20:53 +0200
Message-ID: <20241015112444.528110999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

[ Upstream commit 4bcda1eaf184e308f07f9c61d3a535f9ce477ce8 ]

If no page could be allocated, an error pointer was used as format
string in pr_warn.

Rearrange the code to return early in case of OOM. Also add a check
for the return value of d_path.

Fixes: f8b92ba67c5d ("mount: Add mount warning for impending timestamp expiry")
Signed-off-by: Olaf Hering <olaf@aepfle.de>
Link: https://lore.kernel.org/r/20240730085856.32385-1-olaf@aepfle.de
[brauner: rewrite commit and commit message]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c17e3a6ebd179..22af4b6c737f4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2569,8 +2569,15 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 	if (!__mnt_is_readonly(mnt) &&
 	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
-		char *buf = (char *)__get_free_page(GFP_KERNEL);
-		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
+		char *buf, *mntpath;
+
+		buf = (char *)__get_free_page(GFP_KERNEL);
+		if (buf)
+			mntpath = d_path(mountpoint, buf, PAGE_SIZE);
+		else
+			mntpath = ERR_PTR(-ENOMEM);
+		if (IS_ERR(mntpath))
+			mntpath = "(unknown)";
 
 		pr_warn("%s filesystem being %s at %s supports timestamps until %ptTd (0x%llx)\n",
 			sb->s_type->name,
@@ -2578,8 +2585,9 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 			mntpath, &sb->s_time_max,
 			(unsigned long long)sb->s_time_max);
 
-		free_page((unsigned long)buf);
 		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
+		if (buf)
+			free_page((unsigned long)buf);
 	}
 }
 
-- 
2.43.0



