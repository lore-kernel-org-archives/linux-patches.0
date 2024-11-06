Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F313E1DE4CA;
	Wed,  6 Nov 2024 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897950; cv=none; b=HxNMXt6N+Uovv/JU/fuA8ujgsypNGoGJkXXkeGBcitZtvA3ga6smw4wDDW/OBL/YC96NpElzDIMw1Z9xJgPXIJaecFM8cK6mQb4tlEMGLZtxPqt9ZuS3ESVXnv66j5yXfTE65qzwHLbmFuRWVHVHLK1/lhQMyyznogxd/EkTpw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897950; c=relaxed/simple;
	bh=J1P8sr+pCyz8p5G1V7/zD4dkv5SdPFsVjAC2JR8Dqgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQ8lY4LkQsNPsDg76y08TY+paAaoF1cA9D8elDL1pADfFLtqEos+CMzqhAaHd6OQ3g4KzhdNPskYZwi8+F9nhRDo93B4Y7lpPSL+Ts/P85ltm+T20PcAGWhNU8hgEQ8fmIGXWlBBSb+dF8uIbR20fo31bX4KnkAx19SFUnFdg3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI/1Mx8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI/1Mx8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762BCC4CED4;
	Wed,  6 Nov 2024 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897949;
	bh=J1P8sr+pCyz8p5G1V7/zD4dkv5SdPFsVjAC2JR8Dqgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jI/1Mx8/xLtUXwzRDMZIUZXg0ajJwrMV1XGZfKQv0CTbSYvO7vHRmemlbYXsZa6nj
	 caWLIdG+vCia2p+f3FhhIygzylKe7F5rW5vUVYxTBm+0BCxCPHWQ0OvrVcnOmikTmL
	 jB02t/1ZPGsZKzzLga/sxTs+FXAIjJF2PImNFK2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/462] fs/namespace: fnic: Switch to use %ptTd
Date: Wed,  6 Nov 2024 12:58:50 +0100
Message-ID: <20241106120332.437898313@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3d8fbafc980ba..f1c0e0a705621 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2496,15 +2496,12 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
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



