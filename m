Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3B1F8AC0;
	Tue,  3 Dec 2024 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242275; cv=none; b=u31/Eei+Ugx4m56K944ig0sqjybc9INH/iZ+ss3bk1jVMiAESkcwK88StNKJClvsu4xZF72Gc/sewIKt76t/kfFgEcUPGolWvseBJqyhL4H5MDg0LbHo7A2GbCTg/xVQ+mqm4y/Bzmo3tXxwNkKofiSEnCgfb5GQUSp/dvN0WHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242275; c=relaxed/simple;
	bh=tfZXUnRpHBaFR9Na4YjOiz/uZoypBkVQZQP5KPkEW0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu4HnpjxjGbHZkTbaSJMMWt1ztKUJoJWOzdwjB8w3EJRZG0emo0vquuRxL9YtduG6IBMpYjmIVG07qUgpzRzQ2rPpBoIh1Dh9tjS/4Baf0QzLJv9XQoUjMc8OhVOzitd57wHZIZORhwa8O+M2HNenWwg/kSD6dvSSgFXnbKVEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RStWqPO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RStWqPO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D88C4CEDE;
	Tue,  3 Dec 2024 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242275;
	bh=tfZXUnRpHBaFR9Na4YjOiz/uZoypBkVQZQP5KPkEW0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RStWqPO19BBh7pUejtRFWJukF7kT73HB1j+fvbX7JkQxv2TJHPUxmDLgfZAREiShj
	 XnD6TGTk62YKBd4IMkCTR5L6zT7V9VW/KOErPFu8NGPhY5lVq6uPEn6OT7zjrsvKrq
	 73dZwchMDyGPDyHJ413PDDFzzh/dRIvyAh8XshJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 659/826] fsnotify: Fix ordering of iput() and watched_objects decrement
Date: Tue,  3 Dec 2024 15:46:26 +0100
Message-ID: <20241203144809.460050156@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 21d1b618b6b9da46c5116c640ac4b1cc8d40d63a upstream.

Ensure the superblock is kept alive until we're done with iput().
Holding a reference to an inode is not allowed unless we ensure the
superblock stays alive, which fsnotify does by keeping the
watched_objects count elevated, so iput() must happen before the
watched_objects decrement.
This can lead to a UAF of something like sb->s_fs_info in tmpfs, but the
UAF is hard to hit because race orderings that oops are more likely, thanks
to the CHECK_DATA_CORRUPTION() block in generic_shutdown_super().

Also, ensure that fsnotify_put_sb_watched_objects() doesn't call
fsnotify_sb_watched_objects() on a superblock that may have already been
freed, which would cause a UAF read of sb->s_fsnotify_info.

Cc: stable@kernel.org
Fixes: d2f277e26f52 ("fsnotify: rename fsnotify_{get,put}_sb_connectors()")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/mark.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -138,8 +138,11 @@ static void fsnotify_get_sb_watched_obje
 
 static void fsnotify_put_sb_watched_objects(struct super_block *sb)
 {
-	if (atomic_long_dec_and_test(fsnotify_sb_watched_objects(sb)))
-		wake_up_var(fsnotify_sb_watched_objects(sb));
+	atomic_long_t *watched_objects = fsnotify_sb_watched_objects(sb);
+
+	/* the superblock can go away after this decrement */
+	if (atomic_long_dec_and_test(watched_objects))
+		wake_up_var(watched_objects);
 }
 
 static void fsnotify_get_inode_ref(struct inode *inode)
@@ -150,8 +153,11 @@ static void fsnotify_get_inode_ref(struc
 
 static void fsnotify_put_inode_ref(struct inode *inode)
 {
-	fsnotify_put_sb_watched_objects(inode->i_sb);
+	/* read ->i_sb before the inode can go away */
+	struct super_block *sb = inode->i_sb;
+
 	iput(inode);
+	fsnotify_put_sb_watched_objects(sb);
 }
 
 /*


