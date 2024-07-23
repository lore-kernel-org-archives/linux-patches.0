Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0CA13D609;
	Tue, 23 Jul 2024 11:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721735528; cv=none; b=pPmR4kpqYh7fjV5m6+7NezjrYMXsnA8zejDwClQnnXZslD5hFdoQIH+UdKWAt2Lvi2plfeVwuiOVRAYT/IRoI7zaA4YlHrsiEb16rK79RLgEffIJgG3UponFV1zBb58UUESeVAysUF9cIHkAoRt0sb17aCR15aSMFisXXOBIXe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721735528; c=relaxed/simple;
	bh=RlR5xEXAj844xVXxfIqAzbJkTPPfMZAlfsf1HJKSRd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIpqo72R3b4SOTT3CfVkbVSenyWYUMJoWad/b4CP3+lSIfSgP+ji31T8wQehfQVuAUqTGvfgjBmCW9ZzAapRWhY+kAfi7GMxsm/EvovQzqKKe6CN81ihdmKRCqDQSdfzWkeU6ibHkM/SNW0rZPAUrU8eNDKWGplL4MFBQIEjejc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gj4s7LtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gj4s7LtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023B0C4AF09;
	Tue, 23 Jul 2024 11:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721735527;
	bh=RlR5xEXAj844xVXxfIqAzbJkTPPfMZAlfsf1HJKSRd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gj4s7LtXgWRjILs8HfFQAyKARVyiJw+qx3/4PQgVkBlU2lk9jm3YkAokyzr4XOmkK
	 /P9y70ikWIICWvWjymmo9dDnVGnmfR2TqmImWs98cpAhfn2RuhOTZ4pjyodHIOwsvU
	 IurpjWAJkJCT2kcqcovZK55YElwUUWEnueZQ4HIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+50835f73143cc2905b9e@syzkaller.appspotmail.com,
	Kees Cook <keescook@chromium.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.10 1/9] ext4: use memtostr_pad() for s_volume_name
Date: Tue, 23 Jul 2024 13:51:55 +0200
Message-ID: <20240723114047.348582037@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723114047.281580960@linuxfoundation.org>
References: <20240723114047.281580960@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit be27cd64461c45a6088a91a04eba5cd44e1767ef upstream.

As with the other strings in struct ext4_super_block, s_volume_name is
not NUL terminated. The other strings were marked in commit 072ebb3bffe6
("ext4: add nonstring annotations to ext4.h"). Using strscpy() isn't
the right replacement for strncpy(); it should use memtostr_pad()
instead.

Reported-by: syzbot+50835f73143cc2905b9e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/00000000000019f4c00619192c05@google.com/
Fixes: 744a56389f73 ("ext4: replace deprecated strncpy with alternatives")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://patch.msgid.link/20240523225408.work.904-kees@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/ioctl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1347,7 +1347,7 @@ struct ext4_super_block {
 /*60*/	__le32	s_feature_incompat;	/* incompatible feature set */
 	__le32	s_feature_ro_compat;	/* readonly-compatible feature set */
 /*68*/	__u8	s_uuid[16];		/* 128-bit uuid for volume */
-/*78*/	char	s_volume_name[EXT4_LABEL_MAX];	/* volume name */
+/*78*/	char	s_volume_name[EXT4_LABEL_MAX] __nonstring; /* volume name */
 /*88*/	char	s_last_mounted[64] __nonstring;	/* directory where last mounted */
 /*C8*/	__le32	s_algorithm_usage_bitmap; /* For compression */
 	/*
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1151,7 +1151,7 @@ static int ext4_ioctl_getlabel(struct ex
 	BUILD_BUG_ON(EXT4_LABEL_MAX >= FSLABEL_MAX);
 
 	lock_buffer(sbi->s_sbh);
-	strscpy_pad(label, sbi->s_es->s_volume_name);
+	memtostr_pad(label, sbi->s_es->s_volume_name);
 	unlock_buffer(sbi->s_sbh);
 
 	if (copy_to_user(user_label, label, sizeof(label)))


