Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037147;
	b=JZYTvW3m1JgWa59RiJkop6Dbfs/FDih8Cnif/KvlUdON7m0bnZ8JZElRtDbZm7wU/QZ+
	 xtnqA0hRtdrSIZo66Wpy0BMHnHDXibBPkMLxQeCDRYDPdlOL3lTMO58185gzz7MAL6Ep5
	 mwA6DbIuvI9QPdkHnN9GLhl6MpKwYoSVVTl4Q8m/C8PccQF2VrrGfH3Ne3/y3LGlL0MTG
	 zoEVlX2eTLsUvp/rjQcQPBMruagz4ms5JxIYSi9NDUJsAMOhessqkv528WBS/zBiznxsc
	 THWx7VZVaZ7SGu+gdBv6/R0PD00LM6uIwi8kAVLL3kCNwDPxmNx38bve0VoBQSqK0EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O9jlS4gh4ATas0yxpqTdd/OSOqGDFQ2/OCIL6baGBTw=;
	b=rMLEbxyJyNErkh5AJjxkDO/y7+afoZ14TAz42SL4Y++QGoLFBN7KUb47jPxYcHOcDVAl
	 IorVfuOPCVPf48MYxl8oJteCvcK8IusxLKhvsOCfwtzQfT+Ur8JQz6ZMNRJcfDP2Y3Wff
	 Xpji6mgX180aEAJuXrOmMaVOotWAXdDwXXVxeggL4A7HW35X+81gzY3fPaO556bDGXVJd
	 v7WR1xFg8boc3SQeXYlJFDF2YLOJGsHrCh8RBUebnQsKT+tfprVDKvU2yeK475AGSNxio
	 8ATTYSiZY9jQ7eL/+cVCFr0QZnPdBadmA+E0P2XfnsYxyK1IXZYcNi8CRwV4EmKtQYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmehYdJz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07FF606A338;
	Wed, 18 Nov 2026 21:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmehYdJz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DF11F000C6;
	Wed, 18 Nov 2026 21:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037146;
	bh=O9jlS4gh4ATas0yxpqTdd/OSOqGDFQ2/OCIL6baGBTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmehYdJzVcFmbfaXKwc5sU4nyoxqJCygiCUjc8I1YBHwaNqzBygHcMuaUJAyykg43
	 fumx4UUSLJ06IFaXQzHynlfOZMv7yj8B9iAba5inTMjfgZXMZ34bTboI7ovWR2NPjE
	 kdfz2ZPMdDglJs7liNJiT3GNFv4b9oIXfTSWFVN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1310/3318] xfs: fix buffer overruns in xfs_ioc_attr_list
Date: Wed, 18 Nov 2026 15:32:12 +0100
Message-ID: <20261118150359.572664217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 0b9081a774ee7b9dff1e9ac3765b73c1d6bba5b2 ]

When we converted the al_offset array in struct xfs_attrlist into a VLA,
the size of the object shrank by 4 bytes.  Unfortunately, the buffer
size validation in the attrlist ioctl wasn't updated to notice this, so
the al_offset[0] assignment blindly writes off the end of the buffer.
LOLLM noticed the omitted check and complained.

Cc: stable@vger.kernel.org # v6.5
Fixes: 371baf5c9750a2 ("xfs: convert flex-array declarations in struct xfs_attrlist*")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Applied the unchanged fix at the existing xfs_ioc_attr_list() location because the upstream file split is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1d0c529255667..8f57f478a9b24 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -383,7 +383,7 @@ xfs_ioc_attr_list(
 	void				*buffer;
 	int				error;
 
-	if (bufsize < sizeof(struct xfs_attrlist) ||
+	if (bufsize < struct_size(alist, al_offset, 1) ||
 	    bufsize > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 
-- 
2.53.0



