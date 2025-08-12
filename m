Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5C2ECE85;
	Tue, 12 Aug 2025 18:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024601; cv=none; b=kXr8TNjX3keoJL983C9l3ABh0byaU2B1Y1cdP5PYObQaolofeBJhOFGfLrYsnSueqMhZVgYbRroGX5CFIZydHqWGx45QMX+zwWNnwdqw3CJUEmvBrhGFEDc7yDGaJTLwnZJVCMZLV1C5gQsjkqUgnSSPde4sPWvxfx3w/I6sMTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024601; c=relaxed/simple;
	bh=1H9DlU+7eWyEgzYlDI20KVpFA1luYNCk6ZWCpBTKlCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnVwjRntH3/WW8y1ik/lB1C/0ZQMqaM/+QPi8IlrbOEPQImy6GR4LYexhwNqJCcDAXSQP/HxjXsbvTXrbQyiJME0OIVv964JsIW9pCUtMYVAxdoJt3fBcp4fpzHIS1Jhopeoga/4815bnIDvsqnEar9lhTXYROqsESv2E8gPR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbrKViAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbrKViAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D21C4CEF6;
	Tue, 12 Aug 2025 18:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024601;
	bh=1H9DlU+7eWyEgzYlDI20KVpFA1luYNCk6ZWCpBTKlCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbrKViALwsNjSlStpbSsWqNapC0BU0yb/p/9hqLKuEgBY2R8pPr9S3+gauyQjoqdN
	 GWoy7KKUVGxwVeTyRdQunK23q10IqlvbiCaWwtPy2Pgym3w42z3Cnb225LvR97MMYF
	 DHQNtHZFhfRfFDUrK+7kR1nw1gPv6Fnu6Qf0Ija8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 388/627] ext4: fix insufficient credits calculation in ext4_meta_trans_blocks()
Date: Tue, 12 Aug 2025 19:31:23 +0200
Message-ID: <20250812173434.054995548@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 5137d6c8906b55b3c7b5d1aa5a549753ec8520f5 ]

The calculation of journal credits in ext4_meta_trans_blocks() should
include pextents, as each extent separately may be allocated from a
different group and thus need to update different bitmap and group
descriptor block.

Fixes: 0e32d8617012 ("ext4: correct the journal credits calculations of allocating blocks")
Reported-by: Jan Kara <jack@suse.cz>
Closes: https://lore.kernel.org/linux-ext4/nhxfuu53wyacsrq7xqgxvgzcggyscu2tbabginahcygvmc45hy@t4fvmyeky33e/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250707140814.542883-11-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 91da3ae0bbc6..8997a5f096b4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6139,7 +6139,7 @@ int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
 	int ret;
 
 	/*
-	 * How many index and lead blocks need to touch to map @lblocks
+	 * How many index and leaf blocks need to touch to map @lblocks
 	 * logical blocks to @pextents physical extents?
 	 */
 	idxblocks = ext4_index_trans_blocks(inode, lblocks, pextents);
@@ -6148,7 +6148,7 @@ int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
 	 * Now let's see how many group bitmaps and group descriptors need
 	 * to account
 	 */
-	groups = idxblocks;
+	groups = idxblocks + pextents;
 	gdpblocks = groups;
 	if (groups > ngroups)
 		groups = ngroups;
-- 
2.39.5



