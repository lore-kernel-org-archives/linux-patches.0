Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6702837703B;
	Tue, 21 Jul 2026 22:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673807; cv=none; b=BwY90ycvSDuhaU0TGoFlwevpV6HI0HQ04MQoOcOwsBrSFi4pzk9giGUKVfCYTbbBfqbLSrMKE1OdxvG+ymFDU09tL43W67w09GQ6/ggg59rx4A9kran1zqWQ629MfBKS1BNYJhKkPLhF++e4gaeZD/0FNd7QxOZ2sYBa4i1FmvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673807; c=relaxed/simple;
	bh=e3SKTmliUTAWOMPCwoBc56Xpu3gB8bAEWw/i51ns1uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jskUrmhIQ8iJGmWmTgcw4tl9REtwj6brNkEppA5G8p92rJVPb95gZD6ePxFR+960B3ZIsJBjLDpOg8AI7z48IZVNCY8t82pnGGzKkbqb0If3EFM2qRvJ1RqeRKyTFSc+8Z/RxndD5hw5C5tLK/TB76N6V7SWr22F7wCEgIGwusc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCLxxgYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCLxxgYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5A81F000E9;
	Tue, 21 Jul 2026 22:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673806;
	bh=aKqaVPd3ei1pGXwxfZ6a1y7AbgM9jCOYCYX0Z1rE9Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCLxxgYFEzZP0zXdT9CLPW+mLgf3cyPVa/KFxk896QDCSYxR4wYSbs9W7dz1AMmyj
	 91cWyjgOPK+8dJ3IIU5MoibQiCkmxkk6ZUssGw8iZ8TMkCiUfsjpWA1lJcBVHi7Qqw
	 6R3OswbtvsgsjLL1HBQK0j9Nwk+w1ROPXo4i2dBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 301/699] pNFS/filelayout: fix cheking if a layout is striped
Date: Tue, 21 Jul 2026 17:21:00 +0200
Message-ID: <20260721152402.486862441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2ed8b6885b0919..a98f1f90d53cd7 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -784,6 +784,8 @@ filelayout_alloc_lseg(struct pnfs_layout_hdr *layoutid,
 static bool
 filelayout_lseg_is_striped(const struct nfs4_filelayout_segment *flseg)
 {
+	if (flseg->dsaddr)
+		return flseg->dsaddr->stripe_count > 1;
 	return flseg->num_fh > 1;
 }
 
-- 
2.53.0



