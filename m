Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAC31D88D7;
	Tue, 27 May 2025 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366556; cv=none; b=dH1ZqHOWhQgHuHObSvbgo9/qhs78EE7ZxPT2Ra2dccwlqIUpRxZxZcGrqKuciYo5jcK55VuFCC1r/KU3pYb6KisBaJOGwID7BdUq372g5srx7IFamm+UsLckt3Q05U/IiGzPCPgqV3GkTbl6duFgMicTfSGBbTu1DJgQ1Zp5fbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366556; c=relaxed/simple;
	bh=MDpnTMOvmFzjDu+IOSUhBS3n+2gsBGs53JQj+mvI03Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8Mzyvy/q3cZNFyk/6SPJ7oUZUdSugz+SeiAbJQvB2MSU+4ftyKg3ZpPLOrcntogQq8gPmr6IYUpM3QGOX5EvZ23l33mIdts3Eh8XmD1L4WAVYXZdISK7jp8IoK1dAtFX6b59oUtpxFIA+QS/mCTHrCuZ64QPnvPStSRSSAh0I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rt4+/jhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rt4+/jhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB35C4CEE9;
	Tue, 27 May 2025 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366556;
	bh=MDpnTMOvmFzjDu+IOSUhBS3n+2gsBGs53JQj+mvI03Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt4+/jhqqKy5lz2Gx+knqLGxxuuI8sEKMzYQcxIDbAadRI2i3TevF8QJdJr7/vSOM
	 qoYJFBkWWS6OURAF6PF1m4XTc2rX0IvM63xMcdYNfxciU3PT3KvoiVVl7UrCuTi1e6
	 glE1TYFccBDZ9cn2EDPlhABH8Hwz+dA9qcktG+XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Bretz <bretznic@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 106/783] ext4: on a remount, only log the ro or r/w state when it has changed
Date: Tue, 27 May 2025 18:18:23 +0200
Message-ID: <20250527162517.459859605@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 528979de0f7c1..b4a02be2eacf6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6776,6 +6776,7 @@ static int ext4_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb = fc->root->d_sb;
 	int ret;
+	bool old_ro = sb_rdonly(sb);
 
 	fc->s_fs_info = EXT4_SB(sb);
 
@@ -6787,9 +6788,9 @@ static int ext4_reconfigure(struct fs_context *fc)
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



