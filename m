Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE5D333A9B;
	Wed, 17 Sep 2025 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113994; cv=none; b=WBMUsbZq/qTRbgwcoMuQBomlRdeXpZAhn+uQJ1AdCII6Xlz2egxDQ8SjBmEkGvT6ZJLsa5jwO827ZVhH56DgMLjDRwSamciW7u+fX3cF16E1zGu6VCYFLc6JDD0r4v/Tim/fPxbU0UmenKsFOTkHsQq8tEu4kwT9AHA6VNMcFC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113994; c=relaxed/simple;
	bh=L/wqeGRw++Ta7BWgEXHoOvyZDHu2uWsV8onpUK9uDas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwSCNBwMUH9AsMYFyTi/XDmayDjKxm2Y+5FnK9DlnA3pDo3Glunahq413QP2TMY0C9wJ7AlWplMLoORwsGXDkTH99rn92oXKXFdXt3oP0NWZaMbxtQ9NXn3JYSAwyNCxJJo0WSrrVM4bm3zKS/fjFuhVil0tJiNkOvk+rClgtuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uV7/VYbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uV7/VYbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9901C4CEF7;
	Wed, 17 Sep 2025 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113994;
	bh=L/wqeGRw++Ta7BWgEXHoOvyZDHu2uWsV8onpUK9uDas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uV7/VYbCBrbfA1hrTO3fsH5HBTZ1LslX1zhb6jo75R2S0XiyYGhswqC7b/YKgx0TV
	 tliDNqyCdX4M/MCNVt/y9PeG6+Vj4zcA/i263aT7h/Vq/Y7KY1D3FRl8xnMXc8YSah
	 a5giXO1MkA9H66E9cuIBgD2cMJYtsLdmE0LWSlok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/78] NFSv4/flexfiles: Fix layout merge mirror check.
Date: Wed, 17 Sep 2025 14:34:36 +0200
Message-ID: <20250917123329.940445764@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Curley <jcurley@purestorage.com>

[ Upstream commit dd2fa82473453661d12723c46c9f43d9876a7efd ]

Typo in ff_lseg_match_mirrors makes the diff ineffective. This results
in merge happening all the time. Merge happening all the time is
problematic because it marks lsegs invalid. Marking lsegs invalid
causes all outstanding IO to get restarted with EAGAIN and connections
to get closed.

Closing connections constantly triggers race conditions in the RDMA
implementation...

Fixes: 660d1eb22301c ("pNFS/flexfile: Don't merge layout segments if the mirrors don't match")
Signed-off-by: Jonathan Curley <jcurley@purestorage.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 21016ee2eafc8..e84ac71bdc18f 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -276,7 +276,7 @@ ff_lseg_match_mirrors(struct pnfs_layout_segment *l1,
 		struct pnfs_layout_segment *l2)
 {
 	const struct nfs4_ff_layout_segment *fl1 = FF_LAYOUT_LSEG(l1);
-	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l1);
+	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l2);
 	u32 i;
 
 	if (fl1->mirror_array_cnt != fl2->mirror_array_cnt)
-- 
2.51.0



