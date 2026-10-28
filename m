Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215396;
	b=wVAyn/jUG+5v0ZEdey7hJswUhHbKQdnO+PavmLjBnORN3/shQamQIlscTH7VvSaD/qE8
	 GxSsMgcokvKyuonBFiBfc3JXPS10L9aTX/eNCmQfJjTOlH6FfSKnoTsYH2UM8eciGKcAW
	 Y6oDwt0hmCoO96iyePm6LQ2nwq0HqT/1+MTn/kdkfzWfNhvpw0hf2u26FSZ9AjRZLEYVq
	 pmXsYyzT+XTKeqF3mYAYetEg+yszRdioe9k3D8DTGYxqd5HdL1nwGWKTP7DFsPY0Tv2id
	 pxjLP3aLAhFrCOK7JGe9gf9z9ov2rY0cb/MhrVZauFmrW3nJ/DK7N4L3OFUAOliie5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WcA3y2RhRDY+ynWaQjbXSgq+07wiuEOKefqZgxJKnGk=;
	b=Fp5LuHHjZAiXddRwMlE34A0K2rDYmKHKNeHPwcGlTnMvXzwX8q0uxoWTmUlYnLU7ZSh6
	 M0msvnvpssiO7yk4DaROH/Q+txZ6CfMK/kIv2W2OUCJ9uDq0WYAetaF/pUmyPvh0jXY2K
	 CmLww+gazmeeqpabRS5tV8eYg7ZRS0P6GlwnxEg2fHQ5qGvS9Ev43DIOcPtDZR1zKAKsP
	 vsYJboQDCtBB17R0Gc0A4+AEbV7ZSjaXM1U1jYXG6xD9+l6fCpY4zcBpsxsuQTzFuk0sj
	 0GKCfO7fR/w0GrX0mcm9DtgWuNdH9hsWxE9ew5Yo+o/f++yiuNRD7FbIzKN6tLDSBrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbdYix4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09381606A31E;
	Wed, 28 Oct 2026 19:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbdYix4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5485F1F01825;
	Wed, 28 Oct 2026 19:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215395;
	bh=WcA3y2RhRDY+ynWaQjbXSgq+07wiuEOKefqZgxJKnGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbdYix4ertm1wLxM0bT5yeT72gzN8T3qNrux2gK6slaHYGSDK/W/KIpOr3NbHV8sE
	 F/Occ+9k+OFCe7WE+I8h1aBzRc8hF8NbglWqLzGXxGsp73v12LaBB8d10QYH5sbqns
	 jJQOwLB+0LEfnFRW0gLulLWfF0LAAhZkJKuO5edo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1197/1887] ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning
Date: Wed, 28 Oct 2026 17:54:53 +0100
Message-ID: <20261028170526.645030656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 24bc1b755dc74..d3b8bbeef363e 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -616,16 +616,11 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
 	status = ap->ops->sff_check_status(ap);
 	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
 
-	tag = 0;
 	num_processed = 0;
 	while (tag_mask) {
 		num_processed++;
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



