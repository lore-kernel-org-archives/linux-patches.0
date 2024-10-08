Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AAD1D27B3;
	Tue,  8 Oct 2024 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390226; cv=none; b=CakL9y95yQA3Jo2vuY/7UGmI45am7mKI8BXHEYbzFr3ON1wqCrTjm5r1ICRXOXbDZnrr4M+y0isD0x1q7l99aiUWsKUFitEVznVt5UN+/gz986OMYWgLvT7xcbCkDAzWVT0vge1hZreqnDF5epDfVmv8xb1EohptdXKwr1yx2rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390226; c=relaxed/simple;
	bh=By4GXQXT32V/B0x5nlafzW/07JXvwFp4m4wVsFLOaQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UutUvgStS/N3/LPSj2IazdkZdYf8IlBPOdj9JhmROVaF627pK+pnLupknB6geVUsAYXvsEphHmfCZUURtRjFl5FNGv0heUKGnJX3RTv/dd43j6U9Rkwq65Nom109rDWoFyT2PuUU7nXZvuzZZUWmdBLKC2m69R73M7k7RzYhZUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8vKr7gX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8vKr7gX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BD6C4CECD;
	Tue,  8 Oct 2024 12:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390226;
	bh=By4GXQXT32V/B0x5nlafzW/07JXvwFp4m4wVsFLOaQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8vKr7gXcQnkgQVnNlraHLuMjBQb9tZ5AD+wUG5R6bXayAGZ/4+KOrnv/JEAPUqRL
	 8Cfria0nIouelJlx+5Xh8xQA5jlDplbR7ApAuiMmEk2Htquhr8Dnw52oCR+9VyJe/W
	 VdqqwxZ8xQFkOjpsluEvvKdL+RE3JpN2HMKPD35Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com,
	Remington Brasga <rbrasga@uci.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 196/482] jfs: UBSAN: shift-out-of-bounds in dbFindBits
Date: Tue,  8 Oct 2024 14:04:19 +0200
Message-ID: <20241008115656.020834574@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remington Brasga <rbrasga@uci.edu>

[ Upstream commit b0b2fc815e514221f01384f39fbfbff65d897e1c ]

Fix issue with UBSAN throwing shift-out-of-bounds warning.

Reported-by: syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com
Signed-off-by: Remington Brasga <rbrasga@uci.edu>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 0625d1c0d0649..8847e8c5d5b45 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3022,7 +3022,7 @@ static int dbFindBits(u32 word, int l2nb)
 
 	/* scan the word for nb free bits at nb alignments.
 	 */
-	for (bitno = 0; mask != 0; bitno += nb, mask >>= nb) {
+	for (bitno = 0; mask != 0; bitno += nb, mask = (mask >> nb)) {
 		if ((mask & word) == mask)
 			break;
 	}
-- 
2.43.0



