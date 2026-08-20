Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA8D47A88F;
	Thu, 20 Aug 2026 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247205; cv=none; b=QtMElFoPC0q+Nt5qFNw2FBZcD41mfqPyB9Sbhb+C7lnvHm2yxNK/Fywp1gXlx6+mIyuntGBSv75dNnQ3YGdkZNLmA4T4NFkDyjHAbKI4+FrgQYvqJHsH9pgugoSKpqA6gZTA7nDISOAL+crXSBTo8v7HtOh/izH3ISYtF06Bvgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247205; c=relaxed/simple;
	bh=5imQocZXzC6YE2A0JgYg0NLO36UtcBU4JDnF23EIevI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LH0cinriZm7Lz4jLBP5gv/+fQTuAlMxAKHf2uy0TJ0oASdEWy9LaGHSRlc5RrECMqHEcxGOpaidMvJ95LFkWXXkFcUwFTVY9OPGTb+S+BrAq76r4Cvi6zv4TceWZ8d/f7Bs6xwHuUT5bG2Nbr5h1RkZFC1FmAJ2Ry7SzWd3CYuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3pUHEZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3pUHEZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F5F1F000E9;
	Thu, 20 Aug 2026 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247204;
	bh=gYQOyZFJNvFVVbImxlpAH7QfCfNx9BRrJlzCEPl5unU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3pUHEZcTlaX6EVGQRsnDQi9XB4b495qcS9LZy1OTEhFvvy6bju/a3tYXgewas8Tf
	 KNwG3wR0Y0/TcD3mrcSg54PqotWRnUNLo+oSmH8t79ezn9vhUBOXbjvHEOKkXEjxtm
	 3gUCAXICH/1xMgnCBd8eeVIgDLLWNI5uu9gRew9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/220] btrfs: zoned: fix missing chunk metadata reservation
Date: Thu, 20 Aug 2026 16:55:36 +0200
Message-ID: <20260820145227.859533414@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit 8bc4d7209611e8aa9d5409b6a4a86a9eb91b69a3 ]

reserve_chunk_space() stores the return value of
btrfs_zoned_activate_one_bg() in ret. The helper can return 1 after
successfully activating a block group, but ret is later used to decide
whether to reserve metadata for chunk tree updates.

As a result, successful activation skips btrfs_block_rsv_add() and leaves
trans->chunk_bytes_reserved unchanged. Use a separate variable for the
activation result so positive success does not affect the later
reservation. Keep activation failures in ret instead of returning early so
the function uses the common tail path.

Fixes: b6a98021e401 ("btrfs: zoned: activate necessary block group")
CC: stable@vger.kernel.org
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4346,25 +4346,29 @@ static void reserve_chunk_space(struct b
 		if (IS_ERR(bg)) {
 			ret = PTR_ERR(bg);
 		} else {
+			int activate_ret;
+
 			/*
 			 * We have a new chunk. We also need to activate it for
 			 * zoned filesystem.
 			 */
-			ret = btrfs_zoned_activate_one_bg(info, true);
-			if (ret < 0)
-				return;
-
-			/*
-			 * If we fail to add the chunk item here, we end up
-			 * trying again at phase 2 of chunk allocation, at
-			 * btrfs_create_pending_block_groups(). So ignore
-			 * any error here. An ENOSPC here could happen, due to
-			 * the cases described at do_chunk_alloc() - the system
-			 * block group we just created was just turned into RO
-			 * mode by a scrub for example, or a running discard
-			 * temporarily removed its free space entries, etc.
-			 */
-			btrfs_chunk_alloc_add_chunk_item(trans, bg);
+			activate_ret = btrfs_zoned_activate_one_bg(info, true);
+			if (activate_ret < 0) {
+				ret = activate_ret;
+			} else {
+				/*
+				 * If we fail to add the chunk item here, we end
+				 * up trying again at phase 2 of chunk allocation,
+				 * at btrfs_create_pending_block_groups(). So
+				 * ignore any error here. An ENOSPC here could
+				 * happen, due to the cases described at
+				 * do_chunk_alloc() - the system block group we
+				 * just created was just turned into RO mode by a
+				 * scrub for example, or a running discard
+				 * temporarily removed its free space entries, etc.
+				 */
+				btrfs_chunk_alloc_add_chunk_item(trans, bg);
+			}
 		}
 	}
 


