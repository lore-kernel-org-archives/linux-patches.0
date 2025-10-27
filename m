Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F412C32C311;
	Mon, 27 Oct 2025 18:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590892; cv=none; b=dPxR25DwA9FQ4vkpSeEMv5PZ0SoxHxbyIpEk+x46hYK3meALpv/eYviM+lgh25TlNmVyrq7qvQRf6wwu9FshX280m7NhQm35uqYoqoqz3gdGWQyB2tvJhMwzcqIwTnqx0LFRB/JPugexjoaZ9D5OzBYhzHp3mMlofV100B/wVo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590892; c=relaxed/simple;
	bh=AxUubOcCWj23dGkup/mCismOND6/wvOCqsNAaeg+hi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8HfLKf3xmfYWYeSLoi6p69QXIU9fzkpe5h9jTqcbL32cyaVzjoBM45gUUwtSsZnyrUBtoJDwysdTnI+j2EerrQmSW/UwTaKhieZuX+u/l+xVxQxqhKZT8UqpoHF1MprNTTwkFhvP3vTmF1S8fg0+P/VCEX8UT09GmdkDm5R2Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkgw2pbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkgw2pbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E9CC4CEF1;
	Mon, 27 Oct 2025 18:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590887;
	bh=AxUubOcCWj23dGkup/mCismOND6/wvOCqsNAaeg+hi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkgw2pbqu/qvnUmoVrIMEOaEzmRyVAwA8fnnEEDw+HQAFulxHNHBepqjEJnUQvzIQ
	 FNFBLZsGx2uQIrcOdf+BcMUjEbAJwOZ+S/N7Sob6sDUiMrWZb2/YV4ppR40Y0kjiN+
	 nRCP5FOlV498iQsdCYGZpf/otLq81kFM07OzxAUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 213/224] ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()
Date: Mon, 27 Oct 2025 19:35:59 +0100
Message-ID: <20251027183514.452859054@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 8ecb790ea8c3fc69e77bace57f14cf0d7c177bd8 ]

Unlike other strings in the ext4 superblock, we rely on tune2fs to
make sure s_mount_opts is NUL terminated.  Harden
parse_apply_sb_mount_options() by treating s_mount_opts as a potential
__nonstring.

Cc: stable@vger.kernel.org
Fixes: 8b67f04ab9de ("ext4: Add mount options in superblock")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20250916-tune2fs-v2-1-d594dc7486f0@mit.edu>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[ applied to ext4_fill_super() instead of parse_apply_sb_mount_options() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3882,18 +3882,16 @@ static int ext4_fill_super(struct super_
 	}
 
 	if (sbi->s_es->s_mount_opts[0]) {
-		char *s_mount_opts = kstrndup(sbi->s_es->s_mount_opts,
-					      sizeof(sbi->s_es->s_mount_opts),
-					      GFP_KERNEL);
-		if (!s_mount_opts)
-			goto failed_mount;
+		char s_mount_opts[65];
+
+		strscpy_pad(s_mount_opts, sbi->s_es->s_mount_opts,
+			    sizeof(s_mount_opts));
 		if (!parse_options(s_mount_opts, sb, &journal_devnum,
 				   &journal_ioprio, 0)) {
 			ext4_msg(sb, KERN_WARNING,
 				 "failed to parse options in superblock: %s",
 				 s_mount_opts);
 		}
-		kfree(s_mount_opts);
 	}
 	sbi->s_def_mount_opt = sbi->s_mount_opt;
 	if (!parse_options((char *) data, sb, &journal_devnum,


