Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5C141B36A;
	Wed,  4 Feb 2026 14:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216713; cv=none; b=Dcc0vJawAyqD3YolUGUvcgaje2EjjipadNQ49F4jtN2LCO6t1EmP+FYy94ggZ9izngi0SjFR0WoL+268YKYuLy66jFz0NHY/D5JwAaRz2t5gMQ9T6F00w3fNbNBtonjR8/sXT2reHQG1G+K9vcidoNIzI5irqxYSHLhpkDXNYb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216713; c=relaxed/simple;
	bh=J4Fj19w7RjptKmur1FL9hGY1VQdqTBpgtl0n23pjWvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0XrV8k6olPvXhLm0fPb7FRlioYoio1NFvG+CheMNiPRh5WusFeESGVyFiSEwG42+LrpLIp6XsvBptF0abpWOZ4WLoppxtzOxYqhZFqi3RbfrVRhpR6VnLz61oeEnJXc4VrfJ8e/WsMpK3+oQonPzfYxAtyzOY1Cqitvgmr4pgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvhtTZlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvhtTZlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC05FC116C6;
	Wed,  4 Feb 2026 14:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216713;
	bh=J4Fj19w7RjptKmur1FL9hGY1VQdqTBpgtl0n23pjWvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvhtTZlQS+zaWrdaLSX+QdPylKCnKSAzHyqQFyHvDche0jz0icQZaAnX6sXct6dWl
	 r6Tb8IpqBy6go2dn4ug0gaK2WNEDePriiPdpzFJkLucotXDBKXeon32vXppck8E5qG
	 /RWUXO7yocLcrS6+CmrOK48LMyFnDEpbNJSVV/cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/206] pnfs/flexfiles: Fix memory leak in nfs4_ff_alloc_deviceid_node()
Date: Wed,  4 Feb 2026 15:37:12 +0100
Message-ID: <20260204143858.251222267@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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
index 11777d33a85e8..35cac4d3f2e8a 100644
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



