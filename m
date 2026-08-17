Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58A94B04A7;
	Mon, 17 Aug 2026 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976612; cv=none; b=IEe9PMvPGzCpWvuielPgI2OS+Ks3YObCMaqcp1AnOOFHtJkphz7hkw6AUuS++fzMvJ2IqKs1PcxLPThcYODYGuPpY9MEbCQ/NyoqO8fZRLfR5srNt6Cjfm0VwHwYMbtZSMmCkU6rxIQjA3cmyyvr7AeY1FdbTbr9sOdjr8pmBfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976612; c=relaxed/simple;
	bh=8asJxpqReLLMzFt+NsAj3H61kAZS1hk/iPbAHYYqDgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfpI8qGVTUYpn91ZdNiMSWc5p4fg0mor/ZFIpM/oNG+hZlEHYjsFM1Tyl8eBk+K0031EFdf7M8Qe1QbRDDOwmV5WH6HE4cPvjoAoqc2x2xn1vTLoHrp66m5A6lWgQnpK0veoU4kG/p+Ht3wt/HwdLfBK0beXnNbxUGCqndJUJmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgY+Zp+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgY+Zp+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C411F000E9;
	Mon, 17 Aug 2026 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976611;
	bh=v6XODoVUTxfgFt2D20Hcy7PEvCPc1qZ1Ojb10vB2SWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgY+Zp+ZkI9bNJ30rG/j4jDk+x7EBQpx0XqVwHeYhXK6ktHiMl3/gwFc4LZ2vWwX1
	 QimcdP3hmuEmLBItFMe9Cc0P406tWn4HzDvs7KIn5iGdPOmtSy4t63pS8+x7ePQSi8
	 Ga9ah+Op6fo7dkVtud6p1A2UtSKT8aYbHR+KR+fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/456] ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning
Date: Mon, 17 Aug 2026 15:27:13 +0200
Message-ID: <20260817132541.720956278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 98c91c89a3b336..1692c29227a024 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -655,14 +655,9 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
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



