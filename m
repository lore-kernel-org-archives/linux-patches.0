Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD703AA1A8;
	Thu, 15 Jan 2026 17:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498462; cv=none; b=R00IlzqANAaWE3bGblCmIJCOdyxXbLwuI7QWfq8H2xp05KVcLSE/XWtrZR7q8m+NYIF2yjyJADB5jemy7vZN16mZEv0oYpNJ9ETRbK89OkaKKZDP/UdOWWWm7+0WnWITFw5vbcfMbnmXrUX+JKzRNeb1WtE/XwA0xLtbjNiRl4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498462; c=relaxed/simple;
	bh=tO1GINWvbiqFsymv9rCMX+j4B7ExHyFQUvrKELxZWIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OatDRWZObHMlpPBP2Vy5+q/F7mMwUl3zWzsvF83z7A8ukJC+BkrnWOCu6KNbzrD6Nk9xPKtJ0ZaY4TiHNY7r73cnogN/8WAhOwjS7HlOMKDR5SYTGD0alAiBLtZw8KMcUx5lbq15hdULYGbe5EHwvlEeUzA2//gHjeHCBQ7Kuyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axzOc9cN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axzOc9cN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051E3C116D0;
	Thu, 15 Jan 2026 17:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498462;
	bh=tO1GINWvbiqFsymv9rCMX+j4B7ExHyFQUvrKELxZWIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axzOc9cN5eqHyArxMI9oiTnl6ONvRembfn+bfh68PKWhiYtFLUNMwU/ub1o/s2P45
	 D0hx+PfvogQGoalHUIzUPA+QastSgtl9IyMM06nEa7cMKFNQfH8hv5yJvhaQUjTRsb
	 owv7681FSIznWkemGaAHymkYc3IGZ3m3EzYRg2Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/554] xfs: fix a memory leak in xfs_buf_item_init()
Date: Thu, 15 Jan 2026 17:48:26 +0100
Message-ID: <20260115164302.191431387@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit fc40459de82543b565ebc839dca8f7987f16f62e ]

xfs_buf_item_get_format() may allocate memory for bip->bli_formats,
free the memory in the error path.

Fixes: c3d5f0c2fb85 ("xfs: complain if anyone tries to create a too-large buffer log item")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -825,6 +825,7 @@ xfs_buf_item_init(
 		map_size = DIV_ROUND_UP(chunks, NBWORD);
 
 		if (map_size > XFS_BLF_DATAMAP_SIZE) {
+			xfs_buf_item_free_format(bip);
 			kmem_cache_free(xfs_buf_item_zone, bip);
 			xfs_err(mp,
 	"buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",


