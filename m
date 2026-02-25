Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758772F7478;
	Wed, 25 Feb 2026 06:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002775; cv=none; b=fwUQp9FiuAsQyrEIgysMyJ7t42Z8x5iHTfue5y0RdiAWEz3UptITxMRs81RXk0mBHgvNE3oOtzzOpt3HRhnJogDUybqBsMJxuwW9YFf+k3u8axWIcnNxenP/dGo89lltVA5blsEcfRsJzgvpp7vk6RplhsQIzQGjz0qg8hxlAPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002775; c=relaxed/simple;
	bh=E5ySe/YLbJJp8MNcBl63+ptiEhHfISA+8D9Ht+1MAXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeh2wa4sZdT727exbs4ChyQzJYu6b7lhSfcdYE/gCVxp7b7vtDUshaHGkWB9a9qL0PnRnHhK624QLuwAD/4KBmk1Mq44TjrnCPbF1nTz/uCJoS5WcXZ467cGO4yUx3/MqhMFqo76FRGHJl/QTh668aYmZ34DF/u7EGjKzcFLfl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrHYG1R4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrHYG1R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7FBC116D0;
	Wed, 25 Feb 2026 06:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002775;
	bh=E5ySe/YLbJJp8MNcBl63+ptiEhHfISA+8D9Ht+1MAXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrHYG1R4/q6YcAVeqba8aKnQqX+MxabYS7zXuT15f6/rypwH1fTSkPKHeZXgGDSJM
	 4LQJZmnz1sdMT5phD68Hq1v7NaDi24DV8wLDC84ldo17TuE/n85ZmPTkJBjGfruTSd
	 PKKgq09cwb+hrVc9rRGMOEV4q5j5oFpSmPUD7dWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.18 613/641] ext4: dont zero the entire extent if EXT4_EXT_DATA_PARTIAL_VALID1
Date: Tue, 24 Feb 2026 17:25:39 -0800
Message-ID: <20260225012403.364656572@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 1bf6974822d1dba86cf11b5f05498581cf3488a2 upstream.

When allocating initialized blocks from a large unwritten extent, or
when splitting an unwritten extent during end I/O and converting it to
initialized, there is currently a potential issue of stale data if the
extent needs to be split in the middle.

       0  A      B  N
       [UUUUUUUUUUUU]    U: unwritten extent
       [--DDDDDDDD--]    D: valid data
          |<-  ->| ----> this range needs to be initialized

ext4_split_extent() first try to split this extent at B with
EXT4_EXT_DATA_ENTIRE_VALID1 and EXT4_EXT_MAY_ZEROOUT flag set, but
ext4_split_extent_at() failed to split this extent due to temporary lack
of space. It zeroout B to N and mark the entire extent from 0 to N
as written.

       0  A      B  N
       [WWWWWWWWWWWW]    W: written extent
       [SSDDDDDDDDZZ]    Z: zeroed, S: stale data

ext4_split_extent() then try to split this extent at A with
EXT4_EXT_DATA_VALID2 flag set. This time, it split successfully and left
a stale written extent from 0 to A.

       0  A      B   N
       [WW|WWWWWWWWWW]
       [SS|DDDDDDDDZZ]

Fix this by pass EXT4_EXT_DATA_PARTIAL_VALID1 to ext4_split_extent_at()
when splitting at B, don't convert the entire extent to written and left
it as unwritten after zeroing out B to N. The remaining work is just
like the standard two-part split. ext4_split_extent() will pass the
EXT4_EXT_DATA_VALID2 flag when it calls ext4_split_extent_at() for the
second time, allowing it to properly handle the split. If the split is
successful, it will keep extent from 0 to A as unwritten.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Message-ID: <20251129103247.686136-3-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3310,6 +3310,15 @@ static struct ext4_ext_path *ext4_split_
 		}
 
 		if (!err) {
+			/*
+			 * The first half contains partially valid data, the
+			 * splitting of this extent has not been completed, fix
+			 * extent length and ext4_split_extent() split will the
+			 * first half again.
+			 */
+			if (split_flag & EXT4_EXT_DATA_PARTIAL_VALID1)
+				goto fix_extent_len;
+
 			/* update the extent length and mark as initialized */
 			ex->ee_len = cpu_to_le16(ee_len);
 			ext4_ext_try_to_merge(handle, inode, path, ex);
@@ -3379,7 +3388,9 @@ static struct ext4_ext_path *ext4_split_
 			split_flag1 |= EXT4_EXT_MARK_UNWRIT1 |
 				       EXT4_EXT_MARK_UNWRIT2;
 		if (split_flag & EXT4_EXT_DATA_VALID2)
-			split_flag1 |= EXT4_EXT_DATA_ENTIRE_VALID1;
+			split_flag1 |= map->m_lblk > ee_block ?
+				       EXT4_EXT_DATA_PARTIAL_VALID1 :
+				       EXT4_EXT_DATA_ENTIRE_VALID1;
 		path = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (IS_ERR(path))


