Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27FD421896;
	Wed,  4 Feb 2026 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217431; cv=none; b=RrBI10BolsnotbBanS0ecvbj6GoIozGZTnGCNKX7NwM9YwaZt6EZQGjnOWhF+J8P2SkbnvDYuFGoG3Ilec2Hi13nmp7PkTx5dPGzkQ/CK3krAt9wIrkfTe7tAevq+TTyMGRhIPozuN2x/3vNOgS3yFUbKhPvgOnpiJo2+b/JW1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217431; c=relaxed/simple;
	bh=9zJydR5/ukk89vrtzDFBVqVwbZ7KgI3P5lJnFGo7TlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYXVdmdnIHS5S9fnJip8+APfHbShOzwZc3fOs1jq8dTEzA0Mk5PjtopMWCFdbZoU3HU6wIsSmdHpwqjf/enSCqt4RqeXqfXvohi+CeJRuqc1dBk8sCytV7tSf8dVGGA/NaGPDIdW+leqq89PqnubkSNQza/qU5v7dat4Rbpi1uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkkZWr6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkkZWr6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4473FC4CEF7;
	Wed,  4 Feb 2026 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217431;
	bh=9zJydR5/ukk89vrtzDFBVqVwbZ7KgI3P5lJnFGo7TlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkkZWr6rVoSmoC2SmmFi779RklS2p3QRwLOrwz6dIPUqsqFP8sGTfLtSGUGpzF2UQ
	 wikpDqtgVP7KGPX4XH6gYgIw3sXOIgO3SkGln21rA9YIzA95Oc6IurHJPgGKmBgvI4
	 TI95EkhMQhSoYP030xniSFjXkAkCmirfmxcLHfkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/280] pnfs/flexfiles: Fix memory leak in nfs4_ff_alloc_deviceid_node()
Date: Wed,  4 Feb 2026 15:36:19 +0100
Message-ID: <20260204143909.818518289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 0c728083654f0066f5e10a1d2b0bd0907af19a58 ]

In nfs4_ff_alloc_deviceid_node(), if the allocation for ds_versions fails,
the function jumps to the out_scratch label without freeing the already
allocated dsaddrs list, leading to a memory leak.

Fix this by jumping to the out_err_drain_dsaddrs label, which properly
frees the dsaddrs list before cleaning up other resources.

Fixes: d67ae825a59d6 ("pnfs/flexfiles: Add the FlexFile Layout Driver")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayoutdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index 95d5dca671456..ed18e9e87c25f 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -103,7 +103,7 @@ nfs4_ff_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 			      sizeof(struct nfs4_ff_ds_version),
 			      gfp_flags);
 	if (!ds_versions)
-		goto out_scratch;
+		goto out_err_drain_dsaddrs;
 
 	for (i = 0; i < version_count; i++) {
 		/* 20 = version(4) + minor_version(4) + rsize(4) + wsize(4) +
-- 
2.51.0



