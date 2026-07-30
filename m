Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A075344D011;
	Thu, 30 Jul 2026 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425498; cv=none; b=Fbx8APTfAXNipy0/pZS+qbzNYZguXDkdoQPK1nEfsCwTwyoYVrPQgqjJhuOYMR6UuO9Fv/xOiBIN2TrlH5MTJIi/tPnMjVDE+/raGLYJKV5FEbWrXYnhsOU1sZFpaiaTWdfaqg5ZXj//0JHUGqEf7+Mp8lqErhRy/RfwsC5jPDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425498; c=relaxed/simple;
	bh=8S1H6qIE98E/24lEdL9PMw8OW5lXscDM50PGp1909m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmlTPWTn22Cx2KkSGXovG5x2dRQa5mApO+RJcHJfeDFlD77bEdjg3aYWWftc5jdCL9HALASf9vmL58lRur48DYWit47QLDyyOFWN8wClOb+fgKkBuxnwbQze3wvaq3TKGXzIIFg16lMkZa5ZexEwbRTOUOZQ5Ee5L94Nq1/621A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7yIOJS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7yIOJS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072A81F000E9;
	Thu, 30 Jul 2026 15:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425497;
	bh=/zL938gSD17Zbyx38k4lGspNs4FWiO1mspSWa9DYxEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7yIOJS+q5UzaGyACwpBYrQa2Fc/uff2DKxnAz5mnydZTzE87QjLyoOJNjMvkWWEo
	 em5I+Y4vzlkwkC5xYBMmToEbzlHDGe9kgo7DIvw5Pbahx3l/jcOXD7k4K1e3OxgTds
	 VOdgqRpMfwDPvik2oZiSzYH9M25prZTwrQkF94+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/602] ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning
Date: Thu, 30 Jul 2026 16:08:00 +0200
Message-ID: <20260730141437.844555797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 74514608a7fada..66db8dd8ec2670 100644
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



