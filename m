Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5398F5DF15;
	Tue, 23 Jan 2024 00:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970557; cv=none; b=PljsY88FrqJvrV28EGlDyNW8rOXGyi4aFRiNzUjfS30b6SoS+x24M+JeiHoEg9kNLoP3jYgI0Iq4uI3A5jH/P41SOdOKLQtTSp4guwiapwyPOCETaIdmtQG1cOlVIZEdVH2qYh3QP8yYqYEoHTXBixJRe/MRuMpsPwr5M0OyIX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970557; c=relaxed/simple;
	bh=c2DAF+DjxveJh6uxIMEfjWYa+LCD1OBate2ApazTVEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGmGOH9ifUq+Ebx+4d9bXdc0PTrQeaDwdmZTtZTIqIqvcj2rC+VpTjon2dHCDeGRrVevJTH+VbjS7aa3bTneWRqk9g1RkqBuTtF8h8AektQLtrLenzM5ncJZsKXdYgFyr59pBiI4QyXvHOnfUZkYPCkyBdNbkvY1BlEeOqtXZNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwEN5rv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwEN5rv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71DBC433F1;
	Tue, 23 Jan 2024 00:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970557;
	bh=c2DAF+DjxveJh6uxIMEfjWYa+LCD1OBate2ApazTVEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwEN5rv8gM1qyHD1R2+DiWaVN3WtrFq7fNSje6gAwpUytpKwyJH5HOF1uF5EE/mXz
	 0Vc/kg9vPVz2/oMVFC3c96QLHdo0ZdLRTqMx46o84SrqllajtFbm6H+bv7XnT3X5NH
	 vkGXfvSK2Vq7q40jg+0naZ0UAqNGxLS2oYIdzQ7Y=
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
Subject: [PATCH 6.1 052/417] fs: indicate request originates from old mount API
Date: Mon, 22 Jan 2024 15:53:40 -0800
Message-ID: <20240122235753.479670275@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e04a9e9e3f14..29a8d90dd107 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2693,7 +2693,12 @@ static int do_remount(struct path *path, int ms_flags, int sb_flags,
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
@@ -3027,6 +3032,12 @@ static int do_new_mount(struct path *path, const char *fstype, int sb_flags,
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



