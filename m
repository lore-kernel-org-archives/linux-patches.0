Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0507A3112AE;
	Mon, 18 Aug 2025 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526332; cv=none; b=sobn917xHvvGljoP4FqJBGazz68E+aIY3QnBKD5p7jaSqkWbu0iU8UcRQD/Yg8NA0OPKxaNDytpf6cVt0NvP70S74Z+IsVNVokwflM1bWh+kxn0r2WJUeTt9MBcmDdong5rzcPBQsjcISMMev58hvTQKNABjGhsW9CXOuc7E820=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526332; c=relaxed/simple;
	bh=hIkBts7EKP5bG/kPJU5OBKiqt3bq9nJMbyIt0OG2ESI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjhaVnP/894HGeBxfYp2oHLJvLFFHNgX74d/pjPHG8ynvFUzZdFAbeWFfp9sJM+M9KOz+TG0VOR0ZjDUIzsrdeirjWDiBUbGaivL4up5FUU13JHdEcw0gcS1xjMLtPGuUpc2hUEt1oByK8H9EZPDxHJil1jlNs03/Hws3mvcihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMUt5a4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMUt5a4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD18C4CEEB;
	Mon, 18 Aug 2025 14:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526331;
	bh=hIkBts7EKP5bG/kPJU5OBKiqt3bq9nJMbyIt0OG2ESI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMUt5a4T5rhifroKPpprHAKdpoK6GNqOPKjsnMhKFMEWu4dbv/CU9v2WffXla+X9+
	 MPyxcW14HHPlU/IN8EQIDv+ofmRqLrlC5xubXSjLTr6jBTGAX1E8HKg1vrrrK9VHl/
	 nLZ6xMTrkgaUn0s31Fsic+i10Q8a1lluAVLRF3xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 525/570] btrfs: clear dirty status from extent buffer on error at insert_new_root()
Date: Mon, 18 Aug 2025 14:48:32 +0200
Message-ID: <20250818124526.090845923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit c0d013495a80cbb53e2288af7ae0ec4170aafd7c upstream.

If we failed to insert the tree mod log operation, we are not removing the
dirty status from the allocated and dirtied extent buffer before we free
it. Removing the dirty status is needed for several reasons such as to
adjust the fs_info->dirty_metadata_bytes counter and remove the dirty
status from the respective folios. So add the missing call to
btrfs_clear_buffer_dirty().

Fixes: f61aa7ba08ab ("btrfs: do not BUG_ON() on tree mod log failure at insert_new_root()")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2872,6 +2872,7 @@ static noinline int insert_new_root(stru
 	if (ret < 0) {
 		int ret2;
 
+		btrfs_clear_buffer_dirty(trans, c);
 		ret2 = btrfs_free_tree_block(trans, btrfs_root_id(root), c, 0, 1);
 		if (ret2 < 0)
 			btrfs_abort_transaction(trans, ret2);


