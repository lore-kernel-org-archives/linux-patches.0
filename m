Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213CF18DB0D;
	Tue, 26 Aug 2025 13:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213344; cv=none; b=frtWlpT77D/IITq3J606qDByNMDT9GBCfDKmGwAqXiybPY2FKSDWnajqvNR0HAtIPNXfDCN1km40G+Zv3q0auW7hcy79dl1bxQHwO0vO1zW3jpn7DNkTigwCCv+AQn19TV1wSQDD63P/j1Vp999Pa3oJx0YqvLV96Zhad4a7VLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213344; c=relaxed/simple;
	bh=L39gmGIT1qbjV0CbQJFrRnzPQm5I073gPaPE7PbC4TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJk9SDbV6xvjUaUIKO0hQv7sFiVqqXKSz5Vz9hcH+nlG2+2dPBSWWWpi4KKmZahlBN0sNA7plp9HDD3bBDHdchhwKCHjcOi4KQ+4LY+G0iS1zWj76QTFBX6vaEkSwNjtV+7EGPAG1lM5LebRkMm0DfUBMtgYMOM1/TUSdCaOrYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XBKmajW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XBKmajW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E360C4CEF1;
	Tue, 26 Aug 2025 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213343;
	bh=L39gmGIT1qbjV0CbQJFrRnzPQm5I073gPaPE7PbC4TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XBKmajWPToyD03rV/s9vTyWvuvKb36sRHWFcpu3Lx6Qdi3/Yw3ZRoNcboAkI7eb1
	 8Cf0cmIbw7K2VL4mlMzhFAARpfTao4WuiMAXQTQz96ryYu1QnyuY+Jj/I/i5PBMblR
	 Ax+96HksNnMvlnIO2R/7NuSrDooO98UFrBfmPMQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 312/587] btrfs: clear dirty status from extent buffer on error at insert_new_root()
Date: Tue, 26 Aug 2025 13:07:41 +0200
Message-ID: <20250826111000.855363009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3049,6 +3049,7 @@ static noinline int insert_new_root(stru
 	if (ret < 0) {
 		int ret2;
 
+		btrfs_clear_buffer_dirty(trans, c);
 		ret2 = btrfs_free_tree_block(trans, btrfs_root_id(root), c, 0, 1);
 		if (ret2 < 0)
 			btrfs_abort_transaction(trans, ret2);


