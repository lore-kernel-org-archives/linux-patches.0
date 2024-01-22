Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7164A60269;
	Tue, 23 Jan 2024 00:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971126; cv=none; b=VUUTOV0wSCq0VGoDyIl3z0xXRK/5dnGqjRmcS+9a/w9x7QEdy76Kfpe8BLJet9w+5oykbUmPvaHHZq3ItMa2gG4WWTk4rLt15qcKEQsiDriYBqGvOj3IQ8aCbpTtSzbr6VI+y6sLrpM2Ao3lVyZARF9MOyvFwwSAv9ilhBa5x/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971126; c=relaxed/simple;
	bh=YXE41PDjGFySlu7jFRIlpWbdBVdFXNXqkWdVmWlLaOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGX1xb3sAzsfBtuk0Gm5jRh78MO3KbpJyD5zS6yFHIeuHB7+/tFE/2h+v7E5i9+krl/DALnppQfgqGBK8pazaaFkyj9HuaYoWd/NDzj5brS9crbTUAhiEEiI1trAGalT+cyQ3ZhnnyQ8VtxwcGsodWi9X//MH69OvL9HXxGEqsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14FbHIzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14FbHIzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BE9C43390;
	Tue, 23 Jan 2024 00:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971126;
	bh=YXE41PDjGFySlu7jFRIlpWbdBVdFXNXqkWdVmWlLaOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14FbHIziyFTw2YvDvyJKHK510we3VUzICmcgjSq/7a6Y7pxBaOdbbt9AXePGh40TS
	 jX7ik9K2UnISi9p51eID9G5K6pS8x4/xba7n/ub82BkuPuBFwJRyo72EPmwzxMCTJk
	 G4RtPXQiSNfWgsgqsDYXn5M7XqTA/U6GK2LffkIg=
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
Subject: [PATCH 5.10 093/286] fs: indicate request originates from old mount API
Date: Mon, 22 Jan 2024 15:56:39 -0800
Message-ID: <20240122235735.635355359@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 046b084136c5..b020a12c53a2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2627,7 +2627,12 @@ static int do_remount(struct path *path, int ms_flags, int sb_flags,
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
@@ -2886,6 +2891,12 @@ static int do_new_mount(struct path *path, const char *fstype, int sb_flags,
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



