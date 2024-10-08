Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A148192594;
	Tue,  8 Oct 2024 13:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393406; cv=none; b=uKaRYA3Mcxr2cFbnFT0AOAiueNtpmm6udoNmmRCe2OcelI1fC/hoMNZVk9iNFwieR/uDODSFIbhtnVe+XEIqGFXHeeadaGTQNBQ+H1V/wMAGTeeWBMsnFt447UhDN87JvgAs/0YXZQVEwZA0U8kfkuRuVFYx/gPMIIOpiRH3RFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393406; c=relaxed/simple;
	bh=yo1Fg+0bCtnif7TACZFvfd2Faa5GPYFaxv/+CIR7e/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlRR6afOs2g+dy4zjcfDtBIXc77VBSfdGQ6AvfdcIlM1yBRpX5XMqhwAO0PA0fUG5t0obr0wKwaDP11osGQS9b1dALyDOkpG/UY2bRfo8rPG3ZtoCgYFKIRnb0vMJuz9baM185YSb8yBmakn6JpqYpO/fDdwpMxbDMoJHdMbd8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hChrZ02p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hChrZ02p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8372C4CECC;
	Tue,  8 Oct 2024 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393406;
	bh=yo1Fg+0bCtnif7TACZFvfd2Faa5GPYFaxv/+CIR7e/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hChrZ02pzfS8R8S4jC+dcIhc86gFRZmZqugTEaL7C84t9tR2bPFO9PPVAqhpviTMS
	 e+0ubuVvodtzY0IL3VJhKDCoZdPT/BTYP2LELrqZx3xb42Bw+hd58RNV8/g5i0ReVZ
	 snBej48X9FF/RM6obRQ8c2yJkWncgkSfNyzQXLZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com,
	Remington Brasga <rbrasga@uci.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/386] jfs: UBSAN: shift-out-of-bounds in dbFindBits
Date: Tue,  8 Oct 2024 14:06:27 +0200
Message-ID: <20241008115635.018949622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



