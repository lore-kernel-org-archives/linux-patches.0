Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08D832D42B;
	Sat, 30 May 2026 17:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160509; cv=none; b=oLDnb0/lPt8C6i51X6UO6OR1m81CPq0Qo9Pg2sEPvXNMKBXvX/xLR0b4w/dYaH7OKu0yZXQJGcPm9aycEemuTEG9R45ReHvVUPAV9mE0mtD4XA4e0Y3+xuX6NfOJqYMHbscIGKvLla34S9zuembbb4MS52HNmo8zxgj1+tbGo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160509; c=relaxed/simple;
	bh=dSb67y0dFE8ghqG+Nuzw2eNL1GjKP2OBjBYhamyACKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDlB1TC7kLWcnpPQmAqk/JL48YolXtHGUj50v25DERNkDhmdJ8jDC3hl9ye2ffif2WLwCwSRwSlQuALaG6pFNTcJZjRvo/xEwVYab/MM/PrZid2XMGN3M4SIg6fzFwIP0NZ8wXFgHxQXukhKtZe6c8FQjU5D2O0UjMufTMQu3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLZGVeSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLZGVeSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A591F00893;
	Sat, 30 May 2026 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160508;
	bh=euU0aQdGMm9+Bz4SjJ8gCgHKIbz9MDCE2o7mHPIJKNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLZGVeSuy5+RDUp6jC7T4UWyoWj9XGuXSmxb/L/g0FiiQ64Ez9KYMYexoCeQovcfY
	 rjuKgEYPDvkyoHc0sbfIoMUHwCO31LxznMmucAvud9os8rkwg/leVQiRNqqWTQm5eL
	 ngzYpSmz0RT0kswiLgFIrorjMXRxPWwuKDV/W3Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 6.1 357/969] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
Date: Sat, 30 May 2026 17:58:01 +0200
Message-ID: <20260530160310.198217543@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 9aa6d860b0930e2f72795665c42c44252a558a0c upstream.

setup_geo() extracts near_copies (nc) and far_copies (fc) from the
user-provided layout parameter without checking for zero. When fc=0
with the "improved" far set layout selected, 'geo->far_set_size =
disks / fc' triggers a divide-by-zero.

Validate nc and fc immediately after extraction, returning -1 if
either is zero.

Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://lore.kernel.org/linux-raid/SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3993,6 +3993,8 @@ static int setup_geo(struct geom *geo, s
 	nc = layout & 255;
 	fc = (layout >> 8) & 255;
 	fo = layout & (1<<16);
+	if (!nc || !fc)
+		return -1;
 	geo->raid_disks = disks;
 	geo->near_copies = nc;
 	geo->far_copies = fc;


