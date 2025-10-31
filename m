Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459003C17;
	Fri, 31 Oct 2025 14:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919509; cv=none; b=vCFMDF3QzQz8e9DJL+jroEi9V7APhIbUQy5YFUXnm2gC9XmZYuy79OzCZbVwRXSKagTI4XWD75Mr1K/sw9HUwCfTvhQUNg7ivrdVie+hbBnLo/vpLNqvoke7ZWi6J6xo+CsCRvIVO02cv4LIigqx1MuYNLAcyb+PFxXbqUGJ5w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919509; c=relaxed/simple;
	bh=8sit1LMYuqSTR3IJ9YaVMwQA1dMqb26a1/DfWaUEePY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLr8WeH1P8g9040akTgTU1KRkM7jmzj7KZ53fUaczNJmxz8hNu4j5zUMuyQPRFRiK01dvJX2c//BLyxaxrtu/66p9FAvMAYUnnJiV7zfVBZNZWGmEtPk621b254dfH0dno492XGFf60t1MuK/HGKcqPI1WQjwFPBja9ZRheC3vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyMOY26X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyMOY26X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65666C4CEE7;
	Fri, 31 Oct 2025 14:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919508;
	bh=8sit1LMYuqSTR3IJ9YaVMwQA1dMqb26a1/DfWaUEePY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyMOY26XRJH+Hgd3N9DG/lDk7EGhlTnwySTVC6jwv7LdDpkPFHqBrSplbsA+jYCyF
	 2PWgQ3rSp68gBOkCQykZBb9GkR057ntoLyEPcQ10YezYr+OA0c1ZWq5hoD25pHPxDU
	 Sm9VTENoNaDSMElFLkDdAt16KfiMKQz3sRMz/tR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 13/40] btrfs: abort transaction in the process_one_buffer() log tree walk callback
Date: Fri, 31 Oct 2025 15:01:06 +0100
Message-ID: <20251031140044.342323580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit e6dd405b6671b9753b98d8bdf76f8f0ed36c11cd ]

In the process_one_buffer() log tree walk callback we return errors to the
log tree walk caller and then the caller aborts the transaction, if we
have one, or turns the fs into error state if we don't have one. While
this reduces code it makes it harder to figure out where exactly an error
came from. So add the transaction aborts after every failure inside the
process_one_buffer() callback, so that it helps figuring out why failures
happen.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f3ca530f032df..1c207a6d71ecf 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -350,6 +350,7 @@ static int process_one_buffer(struct btrfs_root *log,
 			      struct extent_buffer *eb,
 			      struct walk_control *wc, u64 gen, int level)
 {
+	struct btrfs_trans_handle *trans = wc->trans;
 	struct btrfs_fs_info *fs_info = log->fs_info;
 	int ret = 0;
 
@@ -364,18 +365,29 @@ static int process_one_buffer(struct btrfs_root *log,
 		};
 
 		ret = btrfs_read_extent_buffer(eb, &check);
-		if (ret)
+		if (ret) {
+			if (trans)
+				btrfs_abort_transaction(trans, ret);
+			else
+				btrfs_handle_fs_error(fs_info, ret, NULL);
 			return ret;
+		}
 	}
 
 	if (wc->pin) {
-		ret = btrfs_pin_extent_for_log_replay(wc->trans, eb);
-		if (ret)
+		ASSERT(trans != NULL);
+		ret = btrfs_pin_extent_for_log_replay(trans, eb);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
 			return ret;
+		}
 
 		if (btrfs_buffer_uptodate(eb, gen, 0) &&
-		    btrfs_header_level(eb) == 0)
+		    btrfs_header_level(eb) == 0) {
 			ret = btrfs_exclude_logged_extents(eb);
+			if (ret)
+				btrfs_abort_transaction(trans, ret);
+		}
 	}
 	return ret;
 }
-- 
2.51.0



