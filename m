Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C3E3002D8;
	Wed, 21 Jan 2026 18:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019951; cv=none; b=ha+nwvTxJXu4Z3TcslZsrEf8b3dGTZbDXpWjjbW15vro/JoPzUwFwlU8JL2Q+pUj8wgc5qk5Dlpo9a29gMT/ezz8+6bjw3W4nVLKcSilPWXKhDxj4dT/vZjIdozjLQhPFb6iBrzjho4xlUl9zmj3sw4PDpC7jQFNlTarPPRYtnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019951; c=relaxed/simple;
	bh=IpZelcD8yKzBqbmFPYhiEFeHi8l2ewgYNHNzYZ/O3Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8pR5FkLhhRf5sFPnRBd04Xqm9L3S/G2w07SIv/tGfEGHuPGQeyjU9HHEsb1j09uK8sGITZ43h0GRXL5TZtgmSCn9O51I/N2aDJoUNXeyCSRqhQGzOWZMPH1Yj4tnSJ4vbfOTGf4CRH/rEDcOCMQ93M7s9HN1n63wbcu9KQ+cq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsS0PX45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsS0PX45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71552C4CEF1;
	Wed, 21 Jan 2026 18:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019950;
	bh=IpZelcD8yKzBqbmFPYhiEFeHi8l2ewgYNHNzYZ/O3Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsS0PX45q+ZKDPMZY+spYhlvAAHItbrUchn9HJn91we6oIjFe2k3poQi6lI43Wz6m
	 /u6BM0NWhB6IVJnnXBumeR8RMDA/Q+o+uUlsHCZr/rB1MAxph8iOIp/LczO/y8hCAM
	 mFU2Bldhs9+C72geQztZ4RcUJJwTUINBPdlWht60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/198] pnfs/flexfiles: Fix memory leak in nfs4_ff_alloc_deviceid_node()
Date: Wed, 21 Jan 2026 19:14:04 +0100
Message-ID: <20260121181419.131362607@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
index c55ea8fa3bfa5..c2d8a13a9dbdd 100644
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



