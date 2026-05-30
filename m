Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE87026738C;
	Sat, 30 May 2026 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166028; cv=none; b=d4RMy61xbyYKQ+3OSHvliDPivZvv8PhvTwP4VKAdpBtbaaE0Ucyh4Cul10tmVGpFRK2K+VH1w75zurRfVIO3gKf+5ecfLAMVUqzn/itloEfWFP1rm5aQkCuTZ9GKncDrnNfRP8pFJy7i3nG6i8tgbVb2+yGlfDg+zfqdepfodOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166028; c=relaxed/simple;
	bh=PwUPtg57SmwV4+ZmvietOPDkX8meZ1Es/0nGNj5CEes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3oN33DX6MgsjBM23VIJdq1BUs8eFRoy0EhBCdAhvWcNjfW0z93XCmneBASf6tiGpZSehPloSPCea4DUru5EnB2YPDDWFvIlkTtrJqTc2qrS3sV5W8d5/I/DUHQLh7HFTgkW0F2cLjj6Q/w/qTDfnBI78QQh30rcr+W4ZYgbp3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMOpjACW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMOpjACW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2281F00893;
	Sat, 30 May 2026 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166027;
	bh=gu9qb1BWU7KHQbUTL7IhWqOf7BxIlKv9tXkP8YqUaxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMOpjACWMlt438cning+bwR9GpiE3xx+ABnFr7GEQI1SApIzVLnNefyQMgGuofOmz
	 AMhVYH0tykEm8JKNxtNdy6/kOdToXhGyL3KOjd+7p9c+WHl619ZwT5iQBd7bD4N83N
	 ntMJq/CibwW1WebeiWQQMCyLEo8AORDVp/9bZEJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 5.10 253/589] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
Date: Sat, 30 May 2026 18:02:14 +0200
Message-ID: <20260530160231.633626223@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -3606,6 +3606,8 @@ static int setup_geo(struct geom *geo, s
 	nc = layout & 255;
 	fc = (layout >> 8) & 255;
 	fo = layout & (1<<16);
+	if (!nc || !fc)
+		return -1;
 	geo->raid_disks = disks;
 	geo->near_copies = nc;
 	geo->far_copies = fc;


