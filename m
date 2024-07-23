Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0C5156F29;
	Tue, 23 Jul 2024 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759347; cv=none; b=XdaDp7MjkZVNXKukVXm8bUtXcON6qn7qoHgi9CElqf8wU1TUsyJUKJAFwmZfk4oYTDJCsXtNXqqO/8t4pDMk5SPGbqNNFzPPTkEfVs3C9gS/agQ1NEJ2jTEMGKKZ5a8G2pNo0st1dM75fLlYGhXe5cwJrKMPmGB27ynC8z3SQpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759347; c=relaxed/simple;
	bh=0f1iCKbGTXoRMnzRE6a0D+3eMmn2zHJeJyKR4r8qxdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEaPod/CuohcDeG3P2KSDcWuPdcaXHJSirCKip5+4mhIOrbrlaA9waGnrGSDcGt0iviy99g7JGhH/UPVS0zLgMXF9qg2N7smseKYF+MpC78DeabK7gax+JyLVdpAw8VtUVLdM1DNt33y1mmszmamMZ/6JllfFdYu/S1IHoITgaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYoexWgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYoexWgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BE0C4AF0A;
	Tue, 23 Jul 2024 18:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759347;
	bh=0f1iCKbGTXoRMnzRE6a0D+3eMmn2zHJeJyKR4r8qxdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYoexWgXntsHSAD5hsAVzfmDeEgi076KtxLFulOWujBuPQBMNGk9zk7OyH2ziCPeL
	 WHMIkupchTErIgBgG1W1S3g9bI5/l+SpbAILh382x88syhukzw8aN56eUJCDRFvSA5
	 /hy+TpkgqmPcFfSrD2p9nBfjwKV+9tH6OoJ6tfHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/105] erofs: ensure m_llen is reset to 0 if metadata is invalid
Date: Tue, 23 Jul 2024 20:24:02 +0200
Message-ID: <20240723180406.520054002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 9b32b063be1001e322c5f6e01f2a649636947851 ]

Sometimes, the on-disk metadata might be invalid due to user
interrupts, storage failures, or other unknown causes.

In that case, z_erofs_map_blocks_iter() may still return a valid
m_llen while other fields remain invalid (e.g., m_plen can be 0).

Due to the return value of z_erofs_scan_folio() in some path will
be ignored on purpose, the following z_erofs_scan_folio() could
then use the invalid value by accident.

Let's reset m_llen to 0 to prevent this.

Link: https://lore.kernel.org/r/20240629185743.2819229-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index abcded1acd194..4864863cd1298 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -763,6 +763,8 @@ int z_erofs_map_blocks_iter(struct inode *inode, struct erofs_map_blocks *map,
 
 	err = z_erofs_do_map_blocks(inode, map, flags);
 out:
+	if (err)
+		map->m_llen = 0;
 	trace_z_erofs_map_blocks_iter_exit(inode, map, flags, err);
 
 	/* aggressively BUG_ON iff CONFIG_EROFS_FS_DEBUG is on */
-- 
2.43.0



