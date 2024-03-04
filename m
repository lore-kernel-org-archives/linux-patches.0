Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D578B47;
	Mon,  4 Mar 2024 21:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588733; cv=none; b=Hiv/PFe96fhm2jPOgOlSxwh6X+3KXwPFQANensGAyGx+5HoRdSpzDguYFa+5CxQLQw/MaNyqMT117d/xRoN4S/L0ozjn0yzh1/zUyhM/wt73CdGK28Mqacz4XEUZuYgofn5YIXjofv11g9JQYfwPpgMdmUzq8DLUoQqVlvc1xNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588733; c=relaxed/simple;
	bh=eHUrcp5VYUa2sqnG2RPE0UKUS9iM8LSzQ8ka9NFdRNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5eG5UpxqIvsPfvPodX+MOfie+wbsjJbmmzM8rtU64XmQWQ9bcfBL+VQ4FwLZCFtXMOcE3sjrJDOdcgLyLYsT5KDcfZ6Ae1ykA9A5OHd5Nuwgv44vC2bBX9/zFDpZTCyMEvrVOo0JxsOfo426sPy27U+9VxjvGa0vQLqlBoRqvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ca3HtBQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ca3HtBQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8123FC433C7;
	Mon,  4 Mar 2024 21:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588732;
	bh=eHUrcp5VYUa2sqnG2RPE0UKUS9iM8LSzQ8ka9NFdRNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ca3HtBQ3sYsYWrIw4UHSVe8e7zWiBLnruLAyYWI+asbpHvw6ozp1qSf7lkTIdQNwf
	 OtU4FAN38gbxM4p67OpAc4FFN3sKieHXN3qhW+bzYd1h5HkU5J3ebTg/wVKRpoIZ3h
	 xRIChA6L2V6ALAsl9JHEuvSJ6FLtiQ1SazGNHAvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Jann Horn <jannh@google.com>,
	Shervin Oloumi <enlightened@chromium.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.1 076/215] landlock: Fix asymmetric private inodes referring
Date: Mon,  4 Mar 2024 21:22:19 +0000
Message-ID: <20240304211559.388822539@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit d9818b3e906a0ee1ab02ea79e74a2f755fc5461a upstream.

When linking or renaming a file, if only one of the source or
destination directory is backed by an S_PRIVATE inode, then the related
set of layer masks would be used as uninitialized by
is_access_to_paths_allowed().  This would result to indeterministic
access for one side instead of always being allowed.

This bug could only be triggered with a mounted filesystem containing
both S_PRIVATE and !S_PRIVATE inodes, which doesn't seem possible.

The collect_domain_accesses() calls return early if
is_nouser_or_private() returns false, which means that the directory's
superblock has SB_NOUSER or its inode has S_PRIVATE.  Because rename or
link actions are only allowed on the same mounted filesystem, the
superblock is always the same for both source and destination
directories.  However, it might be possible in theory to have an
S_PRIVATE parent source inode with an !S_PRIVATE parent destination
inode, or vice versa.

To make sure this case is not an issue, explicitly initialized both set
of layer masks to 0, which means to allow all actions on the related
side.  If at least on side has !S_PRIVATE, then
collect_domain_accesses() and is_access_to_paths_allowed() check for the
required access rights.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Günther Noack <gnoack@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shervin Oloumi <enlightened@chromium.org>
Cc: stable@vger.kernel.org
Fixes: b91c3e4ea756 ("landlock: Add support for file reparenting with LANDLOCK_ACCESS_FS_REFER")
Link: https://lore.kernel.org/r/20240219190345.2928627-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -824,8 +824,8 @@ static int current_check_refer_path(stru
 	bool allow_parent1, allow_parent2;
 	access_mask_t access_request_parent1, access_request_parent2;
 	struct path mnt_dir;
-	layer_mask_t layer_masks_parent1[LANDLOCK_NUM_ACCESS_FS],
-		layer_masks_parent2[LANDLOCK_NUM_ACCESS_FS];
+	layer_mask_t layer_masks_parent1[LANDLOCK_NUM_ACCESS_FS] = {},
+		     layer_masks_parent2[LANDLOCK_NUM_ACCESS_FS] = {};
 
 	if (!dom)
 		return 0;


