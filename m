Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA5226A08F;
	Mon, 23 Mar 2026 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277639; cv=none; b=r611zkq23B3czKCdYxggvjWu6jxLHqxrILrxx2wiCchfx9tLD4cm0krc1CagZ97oO9RltBa+5iMA6UyChhzsT0StzLbDXzLibT5yGK6JrJpYJdfWnqNmiPDt9zD3sqxgw8BWqft35Cp9Z624Qxwaw4S+C8uqATFInv2d643UKtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277639; c=relaxed/simple;
	bh=WHviqgNfywEja6Wns09EL9cbUreoUb2YrTJ5LPx8xs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rg4KUzmSVDo5NmhA0CkjimOOdfCuMHubCljjTH2nuaVgFAc7TIjBEQ5FdMWd06cchhx9Er1LFjj4mzHzgG6cFHgmsQ2nLitC4ZQUnXJRPS2yY6hh8GZoyiy2Lvz2gVMCyVlxh76qfdvGWPQ1NJN1u7xOtvczPP9nBCuIuulgwio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4IrH4d5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4IrH4d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63545C4CEF7;
	Mon, 23 Mar 2026 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277639;
	bh=WHviqgNfywEja6Wns09EL9cbUreoUb2YrTJ5LPx8xs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4IrH4d55/EB2ttQZP94VBKYIaxv8Af3p2lD9OYQqvxBju/f/HGiI3EScEe/lu7q6
	 dhFEHHAgGWlu8MIEheIzD0VSR/wZLs88eAeI/supow/RhcNFTfmu1n3o0t47zzJ47d
	 Ao32SAokv0l0PPlW7X8ZyQhKI6GKhfTR5gCfEauA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/567] ext4: drop extent cache after doing PARTIAL_VALID1 zeroout
Date: Mon, 23 Mar 2026 14:39:37 +0100
Message-ID: <20260323134535.226250944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 6d882ea3b0931b43530d44149b79fcd4ffc13030 ]

When splitting an unwritten extent in the middle and converting it to
initialized in ext4_split_extent() with the EXT4_EXT_MAY_ZEROOUT and
EXT4_EXT_DATA_VALID2 flags set, it could leave a stale unwritten extent.

Assume we have an unwritten file and buffered write in the middle of it
without dioread_nolock enabled, it will allocate blocks as written
extent.

       0  A      B  N
       [UUUUUUUUUUUU] on-disk extent      U: unwritten extent
       [UUUUUUUUUUUU] extent status tree
       [--DDDDDDDD--]                     D: valid data
          |<-  ->| ----> this range needs to be initialized

ext4_split_extent() first try to split this extent at B with
EXT4_EXT_DATA_PARTIAL_VALID1 and EXT4_EXT_MAY_ZEROOUT flag set, but
ext4_split_extent_at() failed to split this extent due to temporary lack
of space. It zeroout B to N and leave the entire extent as unwritten.

       0  A      B  N
       [UUUUUUUUUUUU] on-disk extent
       [UUUUUUUUUUUU] extent status tree
       [--DDDDDDDDZZ]                     Z: zeroed data

ext4_split_extent() then try to split this extent at A with
EXT4_EXT_DATA_VALID2 flag set. This time, it split successfully and
leave an written extent from A to N.

       0  A      B  N
       [UUWWWWWWWWWW] on-disk extent      W: written extent
       [UUUUUUUUUUUU] extent status tree
       [--DDDDDDDDZZ]

Finally ext4_map_create_blocks() only insert extent A to B to the extent
status tree, and leave an stale unwritten extent in the status tree.

       0  A      B  N
       [UUWWWWWWWWWW] on-disk extent      W: written extent
       [UUWWWWWWWWUU] extent status tree
       [--DDDDDDDDZZ]

Fix this issue by always cached extent status entry after zeroing out
the second part.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Message-ID: <20251129103247.686136-7-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ed63260d792b1..2818d297ce464 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3302,8 +3302,16 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 			 * extent length and ext4_split_extent() split will the
 			 * first half again.
 			 */
-			if (split_flag & EXT4_EXT_DATA_PARTIAL_VALID1)
+			if (split_flag & EXT4_EXT_DATA_PARTIAL_VALID1) {
+				/*
+				 * Drop extent cache to prevent stale unwritten
+				 * extents remaining after zeroing out.
+				 */
+				ext4_es_remove_extent(inode,
+					le32_to_cpu(zero_ex.ee_block),
+					ext4_ext_get_actual_len(&zero_ex));
 				goto fix_extent_len;
+			}
 
 			/* update the extent length and mark as initialized */
 			ex->ee_len = cpu_to_le16(ee_len);
-- 
2.51.0



