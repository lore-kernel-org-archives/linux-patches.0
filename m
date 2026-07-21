Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7F63B47E5;
	Tue, 21 Jul 2026 20:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666462; cv=none; b=S+o/jzlXhDX8ujPFx4EYOAcM0hiFY+o69Ewq3oMKZThl4AbDH7U677DBhMIBVZIPZY9PwhGAR+SAsK5VQUbyVKTjkvCqUjQ9fLBOKq7VIPgHubvOOPtNdCamh6exUcv36zmgxWLdSJM4SGf01KazV41BcQoaDgKLdPxiPsa/lIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666462; c=relaxed/simple;
	bh=UxSv4yCViqQcChj14TL5IzaSGte46xecgggPyd+1z6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4LHDY3/exSrZex29VwB7hu5z7CHP6OE/W9yIaUJfCDaI2e3sDkFhOCGVL0HDxoEDglAHD9mQq0mkoh74OywZKielqkScfbf/U6LMJWd1/CSOLjf5v9w6nWx3BeNaWnSO9KDE6065JLnljPf1OrWsleb+mFsFxbW48Qr4GSAQ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQRUxcTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQRUxcTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD731F00A3A;
	Tue, 21 Jul 2026 20:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666461;
	bh=9z+NA1fGLQF5Isne5A6EUAg9UB+RDNQPXBJ9DEWZ4ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQRUxcTDieblrExTKTTL7/amPO8P4Z2m5EXpzMwWocxWVds7OepnGb1tg5XWJ3P8p
	 llxA7zJ1yiHz2/pGavJd+cQwvXORNn7X6/vAV5P+m0erIn/UUmRBoA6V2HQ+scYILK
	 VdKP/OGVRJzyUgHsxHvohK2wBsObgJVQTwjBAIHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0649/1266] pNFS/filelayout: fix cheking if a layout is striped
Date: Tue, 21 Jul 2026 17:18:06 +0200
Message-ID: <20260721152456.380729296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 569ae4ec608455..4b4dcd6fe78250 100644
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



