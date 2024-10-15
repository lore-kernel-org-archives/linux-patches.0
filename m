Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B259E1E9078;
	Tue, 15 Oct 2024 11:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992396; cv=none; b=UsgvtYctaYBufivXZLGZxJ9qYMOrPM5BwtLEZrx+IvCo1PghEZkm1xQgY0pf++PTmOUGfx/tlQynF9HSRcGzXP7y8vaSuduJyxfdfEwUU17g/MDFwCprwL+kn6OYihr7DoBiJTqsrUtSjv4i95fnAX6uEEfFuE/0R6hr1EajVss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992396; c=relaxed/simple;
	bh=JvV5bPVmTwTm8X5MLGRMUE2iX/xCAzHDjlgOA+jra2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiB8KLwQVYTtdMcArr8Mo3FzDs/8kzVKyhAm1gJbzMJW8uYfHk8I3EjKt76L1mQjDA7AZyfxZGDO9gWOasybukDaITzOLQE8tfBP3TzTLH63ysHRVTNkRe2WDGq/DIShJGSgM3qbp29gF2ckGrtWhzYRv3SrpyufXueNgE1gmsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUCuQX04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUCuQX04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21843C4CEC6;
	Tue, 15 Oct 2024 11:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992396;
	bh=JvV5bPVmTwTm8X5MLGRMUE2iX/xCAzHDjlgOA+jra2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUCuQX04Zh6pdbKKw4wcYKIKiok7+rmkh4ucc6LXMsF/vFKyqppAxPXlFC9zB5FT7
	 HjFbrrJd11uJBQOJsTmZvt5SR7XguIjZWE3nuC0V2cfpfTYx5lSddwr+KCcCridQK0
	 ezXdB8dOi6HGFXCEty+vc8xOHhNkB7heIx8SQsD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/691] fs/namespace: fnic: Switch to use %ptTd
Date: Tue, 15 Oct 2024 13:20:52 +0200
Message-ID: <20241015112444.488661305@linuxfoundation.org>
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
index 04467a2a7888e..c17e3a6ebd179 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2571,15 +2571,12 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
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



