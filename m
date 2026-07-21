Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9823B52E2;
	Tue, 21 Jul 2026 21:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669337; cv=none; b=XyxSS5OWJV4yORFljp7KgkPYW55YiZfIb8CYips4f08JNJPlDO50V2QGSGMZ1OLRwVlLpLR2pd2yU5ReH2IOuf7l1T94SuPsgwksIVp7Jc2heHNKWYV2S3OSm4ME9Qd4LMVrk7P+4+0RMUmB7ZsDRx26fCZx957KuvatVoWsm00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669337; c=relaxed/simple;
	bh=Zuce0nqE0eoCgA7TjexgpJLSabz/sMEi+4Vgcz5Ihg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoqBIh5l5E2V42TmlKTxIrei9i0W4rZWX0fO8StjxZ+FLJxwuObJl5FolDpT6EcxqQsRnNuguAe9PSTW+va+ze/kTTmP2gCRAfNf19qaZkXHy460xTMReqJ+Fs2JTKtCYid7qSt6PvLIn0NmM5GSamST71qWfqpJnY6YiSY0x34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXcRgkG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXcRgkG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC54D1F00A3E;
	Tue, 21 Jul 2026 21:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669329;
	bh=c+l1oVhpZiJj7PFTAgVdiZW6DZz1kJ6hGA1WT1X5jM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXcRgkG86jc6Dkxq7p83nXtZ8XiqPTyc/TF2h9A6oV2Mir+mfBBffaDUHr1LdoqAY
	 +hDhXYwl5PZQ9xneC+spFdyjtcPbkyBQY/ChvPgEFiWKqU2XBPHXWQ3/JfiCWMknrP
	 ywikwIfjI6DmeuPw3J/TtPzM8t8TE8fskv+oKDEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0512/1067] pNFS/filelayout: fix cheking if a layout is striped
Date: Tue, 21 Jul 2026 17:18:33 +0200
Message-ID: <20260721152436.066325599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index b363e1bdacdac6..9fa58811534dd1 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -786,6 +786,8 @@ filelayout_alloc_lseg(struct pnfs_layout_hdr *layoutid,
 static bool
 filelayout_lseg_is_striped(const struct nfs4_filelayout_segment *flseg)
 {
+	if (flseg->dsaddr)
+		return flseg->dsaddr->stripe_count > 1;
 	return flseg->num_fh > 1;
 }
 
-- 
2.53.0



