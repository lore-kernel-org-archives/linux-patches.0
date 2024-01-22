Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53D537C;
	Tue, 23 Jan 2024 01:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972179; cv=none; b=OIIF9bb5z6H0JUK8Pm17JGNNlYMcapdzMKboAXBdxDHbS91fo3pZE90yu0kBOoM9t5FU3fO2RZHw8rIuDb8HsMQigFPK6Qat0EkAwK5qQwpnOHi5ptOB+cBCspuwkOmCz8I5K08DSeqqSv7zkxrnFwee7DMBrMSW/2pQHBE2EsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972179; c=relaxed/simple;
	bh=5sPpnX0s9FzfZKOalfa+f+a3q5XKW8xG7jEtyBT/Wjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dT8ZKI/tItiMV0Y4E8984v+jvXZpiittqgrOzTRTNAjGZapPmPDibBuyU5sZIka2gahG4gebcLCZKOTHmIyT1XlZleBfRaIRb8asdbCixzAuD78f/q0RZaxI5aWW5Vu5PnGdXYf6MhEtpG+5l6rAsbqUvk43ChsxfIemIM2K2Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNLj0HaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNLj0HaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D2DC43394;
	Tue, 23 Jan 2024 01:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972179;
	bh=5sPpnX0s9FzfZKOalfa+f+a3q5XKW8xG7jEtyBT/Wjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNLj0HaXGsYrQWv2Pk9CT31eidaSsqhd/wopNlCMZfZPaf+c9I3+SoyP8WK7MlXRk
	 dASVo3rFc3pc3cBxeErEWXcqxsHHcz30duN+GL2sEe/ix+7z3+H/9hIC0DJkqngTiU
	 FTs4eRItTW3iQIorW7VP1v69OSugXvhjOODjpwqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/374] fs: indicate request originates from old mount API
Date: Mon, 22 Jan 2024 15:56:00 -0800
Message-ID: <20240122235748.226496663@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit f67d922edb4e95a4a56d07d5d40a76dd4f23a85b ]

We already communicate to filesystems when a remount request comes from
the old mount API as some filesystems choose to implement different
behavior in the new mount API than the old mount API to e.g., take the
chance to fix significant API bugs. Allow the same for regular mount
requests.

Fixes: b330966f79fb ("fuse: reject options on reconfigure via fsconfig(2)")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1a9df6afb90b..932986448a98 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2647,7 +2647,12 @@ static int do_remount(struct path *path, int ms_flags, int sb_flags,
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
 
+	/*
+	 * Indicate to the filesystem that the remount request is coming
+	 * from the legacy mount system call.
+	 */
 	fc->oldapi = true;
+
 	err = parse_monolithic_mount_data(fc, data);
 	if (!err) {
 		down_write(&sb->s_umount);
@@ -2981,6 +2986,12 @@ static int do_new_mount(struct path *path, const char *fstype, int sb_flags,
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
 
+	/*
+	 * Indicate to the filesystem that the mount request is coming
+	 * from the legacy mount system call.
+	 */
+	fc->oldapi = true;
+
 	if (subtype)
 		err = vfs_parse_fs_string(fc, "subtype",
 					  subtype, strlen(subtype));
-- 
2.43.0



