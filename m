Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F82E1EB5A;
	Mon,  4 Mar 2024 21:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587769; cv=none; b=NUZqJNghCHG8aCMxRnOkcg84+KU93Qlb31fuj4luy6WvNa82Xx2N2HLx6SofpTipNQvbiaiGZeaZZoV0CeiDq5cDucg4Q4i/dL8L7fPIWRGyOLYs82CQdxHSRwyllHGVZHOc3WGYzaZAkpKskMeD/Ju/mY0m1xPGt6FoMv6mVk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587769; c=relaxed/simple;
	bh=sNfME22/uSDSU9lQFZm64yki6E4KF8ONngganK0XOOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qMem6bpIGfHkTdnBR9HqmqMIx9wa55oeCYimZobamv4GhN6ndAJZe68rPkLFOPzY5SsybRemT3QSQ5FHMrr+XY4jYtctiDMSCMRMq+/0C5B3QtFW51I1+rpSusZDlQbnoW5vCHE2u8OQPa9gA5IbJX/B9PmZPBQjsjsVAc+LC/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMAs01ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMAs01ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B858C433F1;
	Mon,  4 Mar 2024 21:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587769;
	bh=sNfME22/uSDSU9lQFZm64yki6E4KF8ONngganK0XOOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMAs01iegJezheNkrvy/tnR9OTB1hsR8GMcbPDsR51EgzQUZlFS4c0TEe6HC+TrRn
	 j1cvM2w/3V9wBqAa5GLE/ZdKsrqzhx8Z8e3FjEYUSprSuK3ctwsyonwXYSHQKASE1u
	 SI29Nq+c7vbgxLE5GAd8LIaCOUSVQAX0GQYT6CuE=
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
Subject: [PATCH 6.7 082/162] landlock: Fix asymmetric private inodes referring
Date: Mon,  4 Mar 2024 21:22:27 +0000
Message-ID: <20240304211554.460901842@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -737,8 +737,8 @@ static int current_check_refer_path(stru
 	bool allow_parent1, allow_parent2;
 	access_mask_t access_request_parent1, access_request_parent2;
 	struct path mnt_dir;
-	layer_mask_t layer_masks_parent1[LANDLOCK_NUM_ACCESS_FS],
-		layer_masks_parent2[LANDLOCK_NUM_ACCESS_FS];
+	layer_mask_t layer_masks_parent1[LANDLOCK_NUM_ACCESS_FS] = {},
+		     layer_masks_parent2[LANDLOCK_NUM_ACCESS_FS] = {};
 
 	if (!dom)
 		return 0;


