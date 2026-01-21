Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CBF3233F4;
	Wed, 21 Jan 2026 18:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019449; cv=none; b=KgTZWJ8GJDb6fVU6671KuX9GL3sTG2a2RIjAcgrlXm96QZQqBk7DB/Zdi8hTSyp90+zWrgLqyJ8AADL/6cx8WLwQbvN2Vljy93uVvXJRCHvGAJfQsJx4rzH8PGRQN3vSJRa0XPoz61YGCUuNgr3cJSKTIsDb1akprAI6x8l6utU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019449; c=relaxed/simple;
	bh=bfXlM75s4xjfouc3P/2WOfB7VucP7NAVcKCYcBag+Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5+MY/41NhRjLjv69V67oSRgmWjGYyD9IYzMjxmokL9Fw7F2Dv3J4Q0roWcZfnEIfO95IpP3FdZTSLITPditX2xdPjqhL0TlLyDYG2CiqcOu1QOtPO3ZUP4rydXEwshDVNdEuetyrd7CLNpklyl0Rqy+cjZsHipTD8DFxkV2XhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDzYK8bm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDzYK8bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A69C4CEF1;
	Wed, 21 Jan 2026 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019448;
	bh=bfXlM75s4xjfouc3P/2WOfB7VucP7NAVcKCYcBag+Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDzYK8bm7gVLimDQhphLT6AF+krYPecZ4LDRreDgv69Rjr1iN0cSBpzIH5MzFAh2B
	 Pbzp6klHZGqIVPRgZLbRPVLvKXXjSE7MIzVxrX17gKrdyOiGu16DYP0c2Q0iAA3dty
	 YELwsusMyigBEL2w3yYCHgyIlZcZJKe+M/4LktyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/139] pnfs/flexfiles: Fix memory leak in nfs4_ff_alloc_deviceid_node()
Date: Wed, 21 Jan 2026 19:14:18 +0100
Message-ID: <20260121181411.829224963@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ef535baeefb60..5ab9ac32f858e 100644
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



