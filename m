Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510AE3033E7;
	Mon, 17 Aug 2026 14:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975463; cv=none; b=BTl6hq1RD+4eEX+qRDQ22dpYg32otmHn7SK80TlvLqUbtcmG27z1sXwLCLbF7Yi74/Pi0oEQ7WeTGL5/+RLUQrJ2HHOEx6YFJsZgcKlAOLlSXCMTV8dEcKqX8YivfFt7mst4+Ys45lRuuQs6KX1+XZ89MNLyokn5WDnDWZgVAlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975463; c=relaxed/simple;
	bh=6vgehgVJsOU4t9hTfRy5Hwwu+glUFYM4Da/96M5A3PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2arDHGLdySbqTlHMmTdkdKe64c0s+xstfGjhhWReaXWKclSgJ4CnU6ToNsENXOA2wSu/46CUqGIKrYbR4wLbk4DhappyKVN6aoUPOZN3KLKTxqJp7B6dUqRdnqL9s2fpPXzt57gNBWmhaPPG2OZ+pbjjsHtF6r4dnEgbexxmQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTlpkoxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTlpkoxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A131F000E9;
	Mon, 17 Aug 2026 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975462;
	bh=oO1GEwRXOyJaII58hT0YgZeoWStLMnfAtgz2v+8JUls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTlpkoxAMmv1h6xlfXfuPbr79B1h5ZzRM21xtv3CYJ27Rh07TpS68q5x6Ppo9LRfz
	 w1+iH3dbx7NHt4oV5BXxfLPsZLinMBOc5Px8ztMOGwR2nTVrylLjAJBFe6PEF/SuHM
	 VfWClL+sUaJSV73kV7qDAtS40vYgET6PQY9Wg7tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/389] ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning
Date: Mon, 17 Aug 2026 15:27:56 +0200
Message-ID: <20260817132540.422484934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
index 399d0766fd6d4c..26c3b287ac1f6f 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -650,14 +650,9 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
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
 
 		/* To be picked up by completion functions */
-- 
2.53.0



