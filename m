Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5AD5BAD4;
	Tue, 23 Jan 2024 01:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974354; cv=none; b=G9u2XVgKaYmW5jQisNzuDXJsONEfwyiXKtwCBYGi9OnKs/RjQtmxKj8zF1eJBUaRiTMa9v4ZI5C4KAygChQ/BaK8d7Gs65OI5PyOfb+ztHrHYG+E//nUq7V1BNnjj2RMTvP7OSaW3SuXKCDOobt7umiJPytDkacj7/8txfKPS3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974354; c=relaxed/simple;
	bh=v3IeE+8rmDxty5o8oE0Cvuz+/Q/BIdzODwZrLqCn8Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETkTGIIydGpVyTgQ8eelzhvoktAIzTepK4QqVcnfVAHOxmivvhLo1KU5B94lythdD75SOxkz8sm4xS4lWqCrKww/RRP+XRbn6xAW3oGgaweHcOVBfn6P7ikOgmptjx9/xbVHPemnEmsUq7NgkZ8n1wsIS5eJg/02tnpsEcaIcEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RE0UhB+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RE0UhB+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EF7C433F1;
	Tue, 23 Jan 2024 01:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974353;
	bh=v3IeE+8rmDxty5o8oE0Cvuz+/Q/BIdzODwZrLqCn8Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RE0UhB+rJ333u/zgL22avvAVzl+Ss+YljXnCzTWtLvn8vw8y7TY7Ha8bZ45uiAfMi
	 ljZBGnWzn22jNsRlBDawi6TmqIOnbbC4TZn/WEsm+jl65wTTm1xC5IbK6ieVJ969K5
	 l8TIw1CgH2Nf6c4xA6p5gJlUrSMrYpQR4Ety7NQQ=
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
Subject: [PATCH 6.6 062/583] fs: indicate request originates from old mount API
Date: Mon, 22 Jan 2024 15:51:53 -0800
Message-ID: <20240122235814.025508898@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e157efc54023..bfc5cff0e196 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2873,7 +2873,12 @@ static int do_remount(struct path *path, int ms_flags, int sb_flags,
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
@@ -3322,6 +3327,12 @@ static int do_new_mount(struct path *path, const char *fstype, int sb_flags,
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



