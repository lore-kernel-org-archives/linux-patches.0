Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356A51C07C2;
	Tue, 15 Oct 2024 12:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997040; cv=none; b=RQ2+WjKVrpJnJ6r/eWzUJjkoJiSOi294FsdBm4lulvWDemxHcAZTt9HBl+SDInOUTzY1SQaNOzslRpcQqfFTkCXcg9z1MO0Fo7ZYtRFFHOVs76cyWIsejmvYz0+BMKBJkfFMoIj2+a0CcTOpY6agMNFyPcqHHeMP8ogR/Toz2Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997040; c=relaxed/simple;
	bh=mfNO06x7CzV9C4kVk2BVTBFMvLMPMUdC7WHKpUONeJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVJJ85h0u8psVyVvY1iJkZHt8gy+ahIC2wq5JO5Tnf/aMk+s+eqnEiD1Urg1fNM4rKFsOJVUQ4E0vodvkhNJh4i5gKXiAY1drMkkn1by60BrtOw+EJ5/xGI9ANVv3GdapRULRgLe8ij9SO26HkSnZA2kQGXDfJWSDsUyMv6rZDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRft76h9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRft76h9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999BFC4CEC6;
	Tue, 15 Oct 2024 12:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997040;
	bh=mfNO06x7CzV9C4kVk2BVTBFMvLMPMUdC7WHKpUONeJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRft76h9/cnrylnNnkY2WmgyU4lxkThYE86FcIs1PtAErq6IDB7aGI+t8szEcocLB
	 y6YMW43kaAOF8gLqAXecBxhTwF++vNlezfYDThTR+MXm1+/fHB1RFqwUz+7b4MJKsA
	 qtWLUVKM5JHCj3yHw8LPXhvLE549SnbR2CV+qVmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/518] fs/namespace: fnic: Switch to use %ptTd
Date: Tue, 15 Oct 2024 14:39:27 +0200
Message-ID: <20241015123919.439507737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 74e60b8b2f0fe3702710e648a31725ee8224dbdf ]

Use %ptTd instead of open-coded variant to print contents
of time64_t type in human readable form.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Stable-dep-of: 4bcda1eaf184 ("mount: handle OOM on mnt_warn_timestamp_expiry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1665315e08e9a..17d3bea73f8d8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2557,15 +2557,12 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
-		struct tm tm;
 
-		time64_to_tm(sb->s_time_max, 0, &tm);
-
-		pr_warn("%s filesystem being %s at %s supports timestamps until %04ld (0x%llx)\n",
+		pr_warn("%s filesystem being %s at %s supports timestamps until %ptTd (0x%llx)\n",
 			sb->s_type->name,
 			is_mounted(mnt) ? "remounted" : "mounted",
-			mntpath,
-			tm.tm_year+1900, (unsigned long long)sb->s_time_max);
+			mntpath, &sb->s_time_max,
+			(unsigned long long)sb->s_time_max);
 
 		free_page((unsigned long)buf);
 		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
-- 
2.43.0



