Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBF73B9D9F;
	Sat, 17 Oct 2026 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259850; cv=none; b=KmOFdGeMfVMBAu+VNp+yH1gJzJciCHWqkjLFmuNvQw/S/+Py10e7erZHSfi36+6g177NDFzj2wa2ORX1tPLfdHRzPoyVDPGZxjE/EQkksAPJYtcwZjWPTIF53eUlxDU01Q5CsXlfzRMzLst7JppCcWaKa4vnyKXDvErD+uJbem4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259850; c=relaxed/simple;
	bh=uI+ABIp/qIOMqORjKA92tyQ/w4WrONry6lk+m7WgKWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwYYCPbbeN0zqvF8q3nPOsu1gRqcn+vITCoHEba3GZo8+16zFfxzKGgtjKT2K9ROkizbTAy6CctGmJuPnZIRMBtskpM978ytJOzf0r87Q3zBycBUkdAsMI1OaQFKbf0BMeuH39BKF8fuBqzdL3TW9ZDlfv/bUq4wMtDO9OwV8cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bf9G0UYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bf9G0UYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368FF1F000C4;
	Sat, 17 Oct 2026 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259849;
	bh=wKtmA/r+uyV3IcteaW+e+HKo7at2F9sSgdE2LuEeKP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bf9G0UYof/35A7+IMwdSMKbyDWS3Xtp7nR4BIIdNNGx/1hNbbtIah7I0/HdsfyCgz
	 RZDEoOP8boaKnq7N5mGfMySi4d4xlLqMTwThn+jLx3xXvbHUke74i6Xv6e2ROQV/zo
	 RCtchMw4k3lA9gtuEjdySNTHYYfrt3G312gUM/Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1350/1674] f2fs: use new ioprio Macro to get ckpt thread ioprio level
Date: Sat, 17 Oct 2026 18:00:22 +0200
Message-ID: <20261017160505.814303928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 270b09313b4e16cdfd01d8371023a1661dd1112e ]

IOPRIO_PRIO_DATA in the new kernel version includes level and hint,
So Macro IOPRIO_PRIO_LEVEL is more accurate to get ckpt thread
ioprio data/level, and it is also consisten with the way setting
ckpt thread ioprio by IOPRIO_PRIO_VALUE(class, data/level).

Besides, change variable name from "data" to "level" for more readable.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 5cb33b00c8fb ("f2fs: avoid NULL checkpoint thread access in sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 58def29e99750..f47b745d3c390 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -339,13 +339,13 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 	if (!strcmp(a->attr.name, "ckpt_thread_ioprio")) {
 		struct ckpt_req_control *cprc = &sbi->cprc_info;
 		int class = IOPRIO_PRIO_CLASS(cprc->ckpt_thread_ioprio);
-		int data = IOPRIO_PRIO_DATA(cprc->ckpt_thread_ioprio);
+		int level = IOPRIO_PRIO_LEVEL(cprc->ckpt_thread_ioprio);
 
 		if (class != IOPRIO_CLASS_RT && class != IOPRIO_CLASS_BE)
 			return -EINVAL;
 
 		return sysfs_emit(buf, "%s,%d\n",
-			class == IOPRIO_CLASS_RT ? "rt" : "be", data);
+			class == IOPRIO_CLASS_RT ? "rt" : "be", level);
 	}
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
@@ -470,7 +470,7 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		const char *name = strim((char *)buf);
 		struct ckpt_req_control *cprc = &sbi->cprc_info;
 		int class;
-		long data;
+		long level;
 		int ret;
 
 		if (!strncmp(name, "rt,", 3))
@@ -481,13 +481,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 			return -EINVAL;
 
 		name += 3;
-		ret = kstrtol(name, 10, &data);
+		ret = kstrtol(name, 10, &level);
 		if (ret)
 			return ret;
-		if (data >= IOPRIO_NR_LEVELS || data < 0)
+		if (level >= IOPRIO_NR_LEVELS || level < 0)
 			return -EINVAL;
 
-		cprc->ckpt_thread_ioprio = IOPRIO_PRIO_VALUE(class, data);
+		cprc->ckpt_thread_ioprio = IOPRIO_PRIO_VALUE(class, level);
 		if (test_opt(sbi, MERGE_CHECKPOINT)) {
 			ret = set_task_ioprio(cprc->f2fs_issue_ckpt,
 					cprc->ckpt_thread_ioprio);
-- 
2.53.0



