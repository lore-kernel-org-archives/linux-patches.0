Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED6F1FBC8C;
	Mon,  2 Jun 2025 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873191; cv=none; b=fNMhWCPiKwVhrpux+pyDp+yxtTSgUEoTPeIO/JmEvbL+ij0+mkvqZkSyDtJt/ZgtyQ2ap0e+XSoIFj0Ah72a8Kc3k4TLGsGBkoS9LymmQ1jmGu52s1N+ocR+huEw5gFM/qkb7mH0sRkxyYK64On4RR+efhswBF2rmiaeZAZs7tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873191; c=relaxed/simple;
	bh=vY/Qeax+H4vchTi5bMoMdR4F8EOKBeV9NJfwwMczh4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1xQN+hL1GSs9Hkeqnttir5+NxI2csK0Ttd8fphDNsnV+IDypHniGSFvRIloKN3W8eDCwQgXo3YUnCrSnplEswDZmb0ga9lEEFcR9mzjSdDBta0c5aRdl3eozaHu31NAma7vmDVYUqwzsrFH3IP+uxw7H+4oFyhEE7ooaD2wK+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0CeRZPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0CeRZPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD023C4CEEB;
	Mon,  2 Jun 2025 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873191;
	bh=vY/Qeax+H4vchTi5bMoMdR4F8EOKBeV9NJfwwMczh4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0CeRZPQHgOzkONhsXlNV4Y2dLEQiLRv7kg+hyx1/3rtQoUFLj2/23bIcR6I45/Ye
	 IrdVvSi3QvDjpKfemZ270SjQXKoCf7OlHlVNsiE7rzqZvVYYaVa7jHSPQaN0izMJ1w
	 /dmrAdhCgmaN8iicTUoCiUhmHjfBA5vu8KcM/GdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Bretz <bretznic@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/444] ext4: on a remount, only log the ro or r/w state when it has changed
Date: Mon,  2 Jun 2025 15:42:10 +0200
Message-ID: <20250602134343.597831169@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nicolas Bretz <bretznic@gmail.com>

[ Upstream commit d7b0befd09320e3356a75cb96541c030515e7f5f ]

A user complained that a message such as:

EXT4-fs (nvme0n1p3): re-mounted UUID ro. Quota mode: none.

implied that the file system was previously mounted read/write and was
now remounted read-only, when it could have been some other mount
state that had changed by the "mount -o remount" operation.  Fix this
by only logging "ro"or "r/w" when it has changed.

https://bugzilla.kernel.org/show_bug.cgi?id=219132

Signed-off-by: Nicolas Bretz <bretznic@gmail.com>
Link: https://patch.msgid.link/20250319171011.8372-1-bretznic@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 751c879271e05..3dcaf06ada364 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6771,6 +6771,7 @@ static int ext4_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb = fc->root->d_sb;
 	int ret;
+	bool old_ro = sb_rdonly(sb);
 
 	fc->s_fs_info = EXT4_SB(sb);
 
@@ -6782,9 +6783,9 @@ static int ext4_reconfigure(struct fs_context *fc)
 	if (ret < 0)
 		return ret;
 
-	ext4_msg(sb, KERN_INFO, "re-mounted %pU %s. Quota mode: %s.",
-		 &sb->s_uuid, sb_rdonly(sb) ? "ro" : "r/w",
-		 ext4_quota_mode(sb));
+	ext4_msg(sb, KERN_INFO, "re-mounted %pU%s.",
+		 &sb->s_uuid,
+		 (old_ro != sb_rdonly(sb)) ? (sb_rdonly(sb) ? " ro" : " r/w") : "");
 
 	return 0;
 }
-- 
2.39.5



