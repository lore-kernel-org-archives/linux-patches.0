Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE49148FE5;
	Tue, 23 Jan 2024 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969169; cv=none; b=o5Wv2sCISeGG0rsTj78Y44rAc2ZruKLH48R9k4calgcAnnADmBsRV2XwoMJa2poqFBFv4MKH7S4jlp19PJEV/gnq9du3SPTrI9vNc+FTD+VE0T7aQpRtE0D9fNdxk/9L238WYMzdzkziwtjHDvgesrlrFLuHHxKeI6Qu9VVt3pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969169; c=relaxed/simple;
	bh=gGJTKi/uJccg7l9CSAqtBwLvNG1/g+nW28l9X1XtckI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ho+1uUac6Ac5WelTcxFZjwWsg68HEnjTSWGwKMPiH7KOykNBNaxJxvR4mw+BlUrusfhRo4+m9ZIPjCpNg03Ll27Qv5TXRGhE69t/AKvxJovTCzoRdSTlQBFkHGZLvl6pdWVHFj9UTdaaga6gIjks+OjZuRseCaxzrljlLtxkNhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYqrD+lX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYqrD+lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF18C433F1;
	Tue, 23 Jan 2024 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969169;
	bh=gGJTKi/uJccg7l9CSAqtBwLvNG1/g+nW28l9X1XtckI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYqrD+lXkndbhu9aQzOzMZBvuCM3IjLIuPkhmqZuNmOt9b4p5It7qXESca1uBE564
	 M59idc/i4efJhLnKlwadqXTk4fXpwOTYy6ks/PieDR6SU7+Wwo6BIIBgnO687tNFL0
	 h7hJtFkoLYSAuy8Glp/8DDRUKCzZXD3MeRI3t6lM=
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
Subject: [PATCH 6.7 070/641] fs: indicate request originates from old mount API
Date: Mon, 22 Jan 2024 15:49:34 -0800
Message-ID: <20240122235820.229656894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index fbf0e596fcd3..6c39ec020a5f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2875,7 +2875,12 @@ static int do_remount(struct path *path, int ms_flags, int sb_flags,
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
@@ -3324,6 +3329,12 @@ static int do_new_mount(struct path *path, const char *fstype, int sb_flags,
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



