Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA50E34CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5A1C433EF;
	Wed,  7 Jun 2023 20:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170734;
	bh=KyW23SPaxxxZQ9QR+kv3kXJAouIFXb+u53XAnDBB9LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRyPGz0PKk2sX3o/5SXzntkh8c9tDL01kfjkbvzRR0CtAjluhdSfY0TyIvTCJITND
	 Vk5LalmuagEIeclmzjg05TCHW+RdG9FJgwBIU78ItSO/ZPVIAgTjXGonbPLbN1d4cs
	 mF/EMyqToTGA1DoROFSxKc+0zWOS6DbSSN+Mt5mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+e44749b6ba4d0434cd47@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 198/225] ext4: disallow ea_inodes with extended attributes
Date: Wed,  7 Jun 2023 22:16:31 +0200
Message-ID: <20230607200920.847390207@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit 2bc7e7c1a3bc9bd0cbf0f71006f6fe7ef24a00c2 upstream.

An ea_inode stores the value of an extended attribute; it can not have
extended attributes itself, or this will cause recursive nightmares.
Add a check in ext4_iget() to make sure this is the case.

Cc: stable@kernel.org
Reported-by: syzbot+e44749b6ba4d0434cd47@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20230524034951.779531-4-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4769,6 +4769,9 @@ static const char *check_igot_inode(stru
 	if (flags & EXT4_IGET_EA_INODE) {
 		if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
 			return "missing EA_INODE flag";
+		if (ext4_test_inode_state(inode, EXT4_STATE_XATTR) ||
+		    EXT4_I(inode)->i_file_acl)
+			return "ea_inode with extended attributes";
 	} else {
 		if ((EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
 			return "unexpected EA_INODE flag";


