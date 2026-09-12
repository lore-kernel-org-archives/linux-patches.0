Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199BE32B126;
	Sat, 12 Sep 2026 19:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239748; cv=none; b=bzLV9bZ2HWuh0E1GnyWawFxOdIn/c+srJnw+HjcfB2caXNp7Fz60VItqN2KEAsy5rT/s5DC4ePMJ5o9y/5blekWsXAVQil2jl6oBQ+9T0gW+x+RuLb1xrFB27EMgw8eR6oHNKwm9IzsXppqOwd7xK1aXlRyDb1SgLg7seKG3CZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239748; c=relaxed/simple;
	bh=KrY1TRv/aLz2grDIZtS5K0ppeC3f1OwR+M+m1cDziG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iC1wWSVqhXTf+BOW6HChGP5j+KqiQeEZqs+trIyrVvJpvbyyCXSURWK61DHQyCu04ts854Ip60VhcvAgkhkmGRLv6rNxKhUMSU+zn+7RcaSac0G9T/cFFrxFL+88tq3JnCqO7KqpCQE8lsS8ZywDMwRm6JO6VtIGkuATpMq9eUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feDzlCIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feDzlCIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3101F000FF;
	Sat, 12 Sep 2026 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239746;
	bh=z4pbdSvXrZR2GjFvla4eFwMQa1PwDffzuvdFy+tPmsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=feDzlCISi7ZJnDxmiL2cXOHmWxWeoYd/xht4fCArfBeRhKYwnZ+w4dhl3INTgMbm1
	 aPTaP7CFBeV/8WGgiuoVf4Wja+XB1Md+qhRorrPqaqpB7fEG7enHNnrC/uQ5z4InHH
	 Ck8DB6k/fu6YQc6A2FIfk4d6ArwTr1IhRmIDslAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Aivazian <aivazian.tigran@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 728/935] ext4: fix spurious message about orphan cleanup on RO fs
Date: Sat, 12 Sep 2026 09:02:38 +0200
Message-ID: <20260912065543.529599531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 5aa98f874c013bcce9bb84ffded2f0ef886e4e33 ]

When orphan_file feature is enabled, ext4_orphan_cleanup() was always
walking through the orphan file looking for orphan inodes. This is
mostly harmless but for read-only filesystem it results in spurious
"orphan cleanup on readonly fs" message and in other cornercases it
could result in similar somewhat misleading messages. Skip orphan
cleanup if the orphan file is empty to avoid confusing messages.

Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
Reported-by: Tigran Aivazian <aivazian.tigran@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260803160037.64285-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/orphan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 48c0d323ff8f8..56a032f58a218 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -388,7 +388,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 
-	if (!es->s_last_orphan && !oi->of_blocks) {
+	if (!es->s_last_orphan && ext4_orphan_file_empty(sb)) {
 		ext4_debug("no orphan inodes to clean up\n");
 		return;
 	}
-- 
2.53.0



