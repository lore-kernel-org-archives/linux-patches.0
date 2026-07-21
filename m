Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220493E49FD;
	Tue, 21 Jul 2026 22:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671850; cv=none; b=TAd0cUdMaptQAQMNh/ya4MWrXOuTDRSbSO2s7QLm8g9HA180DexwiliMR4lFecN553p6BzdkgfxozK+gKM/6MH/TXy2WrswmEWxLCHeAa7quz1LuK+LSDHOnZlwFQHwzU+ydVEN1Cv24PJ5zWUQJi1SsTDlu7ajwv/kzlvIOjx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671850; c=relaxed/simple;
	bh=0UBeR/+eXu7dQX8HPtw/Xkw38Ajlaq68NRfbzJu2C00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw8jZSxtyfj5vC2nfpKcAITlcUcCmW3rvBYM1Kd3IaXbuxvFEZjOOtVEJ4o+dgkRbInh5EVIIuY9zox5veaqU7u+HZGq4MCa8Lqc8gkPz2XTVv1nXXvDY059RInk+qy8XA3eoTcE6h12Sq6pOgudR8oWICuDkXf08NQm1Q2ssrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eny8A5kM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eny8A5kM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F2D1F000E9;
	Tue, 21 Jul 2026 22:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671849;
	bh=dEe/J8DJjvhP+1QLewye0xiEYB6yqz5k0UJSwFUP4wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eny8A5kMKKOGuDp+fMRiw82UXs0CpQ7JiR0p/TMC6y7s7qGLri3VIUpX1wzSqcc1K
	 e1kdNl5F6E0YIlPG0QxR8vvzMCGvr50bLvkktnvArd/li4n2FlJ1iYI24JI0cmStDS
	 /QwctFhFriNIMvz92xf0o2uVgEbJAiAVq49upzME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/843] pNFS/filelayout: fix cheking if a layout is striped
Date: Tue, 21 Jul 2026 17:20:35 +0200
Message-ID: <20260721152415.035470252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 45eec08ec904f0..ba04cfc52fd1df 100644
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



