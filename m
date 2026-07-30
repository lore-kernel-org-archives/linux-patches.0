Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7892379988;
	Thu, 30 Jul 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423613; cv=none; b=dPiFg6Ir+7d1QES0xPPbp5Mr2vrKm6i6PmysuY5dE8heQC7kdZt+Wtq/LI5RruqE5yES3XKxwIJF0RZElaHLuVR7Jbz5rvtgcaDjwXpJNOpB63HJGculSv46JbPONZNo+P4tTeCEDXwgPWo35UJ4S0k4dflfB1GIPGAIUMbZ6Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423613; c=relaxed/simple;
	bh=vg9Iepm3JWoeISM08UcUbLe9s3U7f5fj7/HWKt4G2tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZFSFuW2doWWsqDo8A8JX4Y8hCeVgaMfVLrCOan3LmWswsz5vcTv8XRu9Cai4vuT5+1RyDcyyoB3eKI6a2ngacIpWqLH/FDqcm0j3cYlfGRcYrCC7gyjI/sISzmNGGiKMGZieFuRjsX4VEGv2ml16pmxnsrpxxl3LLiUZAxzv18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXVowdoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXVowdoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD50C1F000E9;
	Thu, 30 Jul 2026 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423612;
	bh=o0zZW5cCYhUegrcp6el7Xdd+dYbV0SEjH4OvpNAHWL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXVowdozH1I8yQ5NWxR5d2GOJTF8Mt811zt7uz4KD3UdKIbScLt+zR5BGgqGv5M3V
	 QKM5CWvsD/6NSpmgZsJJ94gUWaqnZpQbH1oKhd4SoLGqxgMExLnRtrXjfeGc9adoPL
	 R/IJUikh7aijr+2+JToxnE7aWfbr7NxCy7Jpyiz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/675] ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning
Date: Thu, 30 Jul 2026 16:07:14 +0200
Message-ID: <20260730141447.346535053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit c2130f6553f4a5cbdc259de069600117a995f197 ]

The hand-rolled bit-scanning loop in the NCQ completion path has an
infinite loop bug.  When tag_mask has only high bits set (e.g.
0x80000000), the inner while loop left-shifts tag_mask until it
overflows to 0.  At that point !(0 & 1) is always true and 0 <<= 1
stays 0, causing an infinite loop in hardirq context with a spinlock
held.

Replace the open-coded bit-scanning with __ffs() which correctly
finds the least significant set bit and is bounded by the width of
the argument.

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index d3472bfc606ffc..36cc28b8986509 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -607,14 +607,9 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
 	status = ap->ops->sff_check_status(ap);
 	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
 
-	tag = 0;
 	while (tag_mask) {
-		while (!(tag_mask & 0x00000001)) {
-			tag++;
-			tag_mask <<= 1;
-		}
-
-		tag_mask &= (~0x00000001);
+		tag = __ffs(tag_mask);
+		tag_mask &= ~(1U << tag);
 		qc = ata_qc_from_tag(ap, tag);
 		if (unlikely(!qc)) {
 			dev_err(ap->dev, "failed to get qc");
-- 
2.53.0



