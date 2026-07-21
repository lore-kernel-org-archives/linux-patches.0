Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF3435DA40;
	Tue, 21 Jul 2026 19:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662537; cv=none; b=M/Pw17Ie8tdRORM0md2TkO0iz+xANg7sOwpgFke7cSPhIqBrUeeo1R3fj5Pr0U6gCUNSrRa/qRRfNh8/MdiBIdIszVAUiB58MaS7BGAKhkyjsgTnYTRspHN/WRvZ+MdvmPXzBSK3/ppdyZlPaKwuzrUqI+Qr/8uCWFb3c7VjzAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662537; c=relaxed/simple;
	bh=nIdiGvioeaprJTIb33q7mqrXyBLCI+A6Lf5BvSB/AVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYzTg4ZiyPFNOevCRJhNRmH5CSaDYCoTPtaAv0utNIkv5P5aKkS7/ErSCyc/VQKq2qkWZdSTpbWUlbie13h6+Ki38D7lXW+cKzIzNvb6Syj7vGwBN0cSWETQisoyhhcOo6wqJx9nxJHaLAe9QMJVClWsY8IbC59eDXKqauLtvk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDxGoWDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDxGoWDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17711F000E9;
	Tue, 21 Jul 2026 19:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662536;
	bh=qTwZIdt+a/XClSoAI9uDQbW07dhv85U3FNp9M8Xrqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDxGoWDbnrGOip488xblWLFdOLWjuAvDmQo9DkMSLQUlOaj0BG0JGtYVb2JqxEYis
	 rc118sX0fjJ8ElDDAYNC6bSldBucVsS1Qgaa3OHYJIAGiGpxri9sh4Z7s2N4s0Glga
	 eUg0E1QrD/4qbi6z2c7nXhqcFB15oQqDew7cghpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0482/1276] pNFS/filelayout: fix cheking if a layout is striped
Date: Tue, 21 Jul 2026 17:15:25 +0200
Message-ID: <20260721152456.888183334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 91668417d4e925c98cae4a55b1b9860380ddbf16 ]

A layout can still be striped with num_fh = 1 as it is perfectly possible
that both MDS and DSs can handle the same filehandle. Hence check according
to stripe_count > 1, which is the correct check to begin with.

We should not be called with flseg->dsaddr = NULL, but if for some reason
we do, return our best guess with is flseg->num_fh > 1.

Fixes: a6b9d2fa0024 ("pNFS/filelayout: Fix coalescing test for single DS")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index d39a1f58e18d9d..c064433cf6d636 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -778,6 +778,8 @@ filelayout_alloc_lseg(struct pnfs_layout_hdr *layoutid,
 static bool
 filelayout_lseg_is_striped(const struct nfs4_filelayout_segment *flseg)
 {
+	if (flseg->dsaddr)
+		return flseg->dsaddr->stripe_count > 1;
 	return flseg->num_fh > 1;
 }
 
-- 
2.53.0



