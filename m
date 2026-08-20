Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAC43403F8;
	Thu, 20 Aug 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247030; cv=none; b=OYypKSkfZ6NqtI18kdvAth/zLpRcR22yMYPZ0tU48qI/o3icBxqqn4b2X2aN/mL7TKhfO/QtehHOUw70DPJJpgtXNEEb1p/ZZJ3CtLC6bYA22YZG8FeAAZtYGKI9RdZJ2YhQ4G85x34cURWC/xaLGZJ8Ai5u39MPKw29zV96jK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247030; c=relaxed/simple;
	bh=CYVYaRLWc3MRBzknVnUVbOqvTs5gu7mkuwYj66W2meA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q58Bjr84n4G2t6Yuv0l9nwWXy3mDMoyCfeJwkDjCvHULXNT+PTrapV9hah7pKoRii76HDxGGC2p5oSePJmKO+b+Na50GENwImPBhH8wjyBC3piAoR8Gb8CcSss1QuYoi1seDIdNs/PNpK82YvxfuPl9wqZOD/j5YgPcum6e/CAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWFi5brU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWFi5brU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA751F000E9;
	Thu, 20 Aug 2026 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247029;
	bh=2yGc0VP5uWk1XhX43Wl+a8AOarzj1mlWVJPcgrnOmu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWFi5brUZDVLdd7iZgg0ZVR5SJNavLLGUaCmrsy56C9TaviaqMWb6ViavUd2wu6G5
	 Ga7ZMj8lVq77VBnOOoHrZ7k8XMouN1n6VLg/jupiOWp+Z/gJqObs3kk6HuYSbcjYq7
	 xRmrz7QCAcCs5NvjUO83Lx86oyUUScjnUjicgdfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/220] super: remove pointless s_root checks
Date: Thu, 20 Aug 2026 16:55:14 +0200
Message-ID: <20260820145227.201324996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit af7551cf13cf7fb1d4f939db4f1f24c00550ed57 ]

The locking guarantees that the superblock is alive and sb->s_root is
still set. Remove the pointless check.

Link: https://lore.kernel.org/r/20250329-work-freeze-v2-1-a47af37ecc3d@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 749d7aa0377a ("super: fix emergency thaw deadlock on frozen block devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -930,8 +930,7 @@ void iterate_supers(void (*f)(struct sup
 
 		locked = super_lock_shared(sb);
 		if (locked) {
-			if (sb->s_root)
-				f(sb, arg);
+			f(sb, arg);
 			super_unlock_shared(sb);
 		}
 
@@ -967,11 +966,8 @@ void iterate_supers_type(struct file_sys
 		spin_unlock(&sb_lock);
 
 		locked = super_lock_shared(sb);
-		if (locked) {
-			if (sb->s_root)
-				f(sb, arg);
-			super_unlock_shared(sb);
-		}
+		if (locked)
+			f(sb, arg);
 
 		spin_lock(&sb_lock);
 		if (p)
@@ -991,18 +987,15 @@ struct super_block *user_get_super(dev_t
 
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (sb->s_dev ==  dev) {
+		if (sb->s_dev == dev) {
 			bool locked;
 
 			sb->s_count++;
 			spin_unlock(&sb_lock);
 			/* still alive? */
 			locked = super_lock(sb, excl);
-			if (locked) {
-				if (sb->s_root)
-					return sb;
-				super_unlock(sb, excl);
-			}
+			if (locked)
+				return sb; /* caller will drop */
 			/* nope, got unmounted */
 			spin_lock(&sb_lock);
 			__put_super(sb);


