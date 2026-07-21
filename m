Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFECF470440;
	Tue, 21 Jul 2026 19:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660538; cv=none; b=DTfN3MkHaBvSQJfEagySTzNqpgfc2fzkwihdft6k/EA2vpmJvOC6QPwZNtbsZCWCbSflRBDPdSH5l5AmP9mI+4AhzSiOuxD/TwSokVAyQtgzZ9lZYiQLiDAl5WuxTaFpmoqiKSzf3wfzQPvOorhdAq5s0Zn+kU/ZsoEWAGGHHlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660538; c=relaxed/simple;
	bh=URCNGnBUjQWH0sAkdgqzYM+K6NTrhSEG+dZDVwG/yzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNmgP0B9AUjeMnhZhChs80onogj1AWm0jxiWEPdbovrwcP5AHy1DJYigXUKR0EsB7pC15Cj+H5wwdzjxa4cTKm3iV2AyJ37C0Le3gJGKc0rZ8nd3eXSfSGgq5AxFigX+eJ+ale3Q4WswS2yrIpxzj2C8WQnj/AvkjjCfyXCCb7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2whUu3hG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2whUu3hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4C91F00A3A;
	Tue, 21 Jul 2026 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660536;
	bh=WxBnTKQJVqWnZBup0PVhDTBxw7sccgCSDIaaTse9R4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2whUu3hGsROjVDmcv8fqjiRCUuvbcquOEAo50wdN1icQUDzxqazV71K7uIrqgIa68
	 Iv12eBH9eCMizCifnoS9H7BCSUXC1IlQyw6Q9AhyMKwnKN1UG2K1953kDbvWZVxDZl
	 PaZslFZLSeWtLMDNAP0aLDeWidJI3qDBIKNo3BP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0964/2077] pNFS/filelayout: fix cheking if a layout is striped
Date: Tue, 21 Jul 2026 17:10:37 +0200
Message-ID: <20260721152615.560479931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e85380e3b11d72..70f2cbd46960ff 100644
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



