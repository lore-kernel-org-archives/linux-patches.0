Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E535FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BFBC4339B;
	Mon, 15 May 2023 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169844;
	bh=V+LebuTAQf3IroqiJmTNAP7rY7/JNxVn3Zv3axklaOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uc0tq8P4u0UU8L5U5BtTVp2f0OjgApOKzONNxdlpO9iM908Z20HtolPRUPfviOUG0
	 x7kwhkD9R2HTD7PhpRWUbqUlIBlVtMrhGkL+4HXATNn6J0oZE51/3MRYdrKiWziT2D
	 j+W0x+uIcaHEkVjLvzvHhxB6yHr8vLuFJ5xvi2KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 149/246] smb3: fix problem remounting a share after shutdown
Date: Mon, 15 May 2023 18:26:01 +0200
Message-Id: <20230515161727.024289599@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

commit 716a3cf317456fa01d54398bb14ab354f50ed6a2 upstream.

xfstests generic/392 showed a problem where even after a
shutdown call was made on a mount, we would still attempt
to use the (now inaccessible) superblock if another mount
was attempted for the same share.

Reported-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: 087f757b0129 ("cifs: add shutdown support")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2705,6 +2705,13 @@ cifs_match_super(struct super_block *sb,
 
 	spin_lock(&cifs_tcp_ses_lock);
 	cifs_sb = CIFS_SB(sb);
+
+	/* We do not want to use a superblock that has been shutdown */
+	if (CIFS_MOUNT_SHUTDOWN & cifs_sb->mnt_cifs_flags) {
+		spin_unlock(&cifs_tcp_ses_lock);
+		return 0;
+	}
+
 	tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 	if (tlink == NULL) {
 		/* can not match superblock if tlink were ever null */


