Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2933D7D9D;
	Tue, 16 Jun 2026 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636441; cv=none; b=TQPfuncy7p6NFYoRHXxNNkGIq7suzXRg6OWDuiamWOqx9jWq4aeohtnfLbiir6QfPSQkBOHbSZFqttr8Wg6quwWscfHtIkzHH7ElWl2DD5EcczqGm3hm/ovKNW8g4221fa4vNH7FdWZpE1Jz2qoXSI3F2cnJ8PXGjgxVDTd8Q28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636441; c=relaxed/simple;
	bh=T0msyVZL0xPc0gXDKA+c/TB5USKywn2Zo+ECKOY3KS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDZhG4nKmb0yHR9wQviKXJFqh668ABDbI1o2fiq882Lc+9Q5lX/Qc2QFCL8cpeNgQKzYI+7Ybv5UboRpWqh3NtxN9fpFQ7xteNZiK+oBvQglq3ltXloNb+Vrz5AYmN0UmgczyUPaxppEC1d5ADbo/523DESU1g9zZ3uUJuyEP78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdC+imUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdC+imUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583211F00A3A;
	Tue, 16 Jun 2026 19:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636440;
	bh=pyXRqcAd4NfvyoEk/WTLptovRCH/McFifBb27bhj53Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdC+imUkSr93Q7g0/muaORumLudGW8gjJ+hOn4alwn9HYk6D/ML++6wao+QsD04oB
	 UweMkq9/1J5ZVtA5vdpEdHZVc+8COXU3OCNX3NwXIDFABPqUj4otldDGJRSyfeS7qr
	 hiBhweNSvAwSzElCyeV/zIYIWHUEQVvMzZoAx2qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjaikumar V S <sanjaikumar.vs@dicortech.com>,
	Hendrik Donner <hd@os-cillation.de>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/342] mtd: spi-nor: sst: Fix write enable before AAI sequence
Date: Tue, 16 Jun 2026 20:28:55 +0530
Message-ID: <20260616145059.340436342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Sanjaikumar V S <sanjaikumar.vs@dicortech.com>

[ Upstream commit a0f64241d3566a49c0a9b33ba7ae458ae22003a9 ]

When writing to SST flash starting at an odd address, a single byte is
first programmed using the byte program (BP) command. After this
operation completes, the flash hardware automatically clears the Write
Enable Latch (WEL) bit.

If an AAI (Auto Address Increment) word program sequence follows, it
requires WEL to be set. Without re-enabling writes, the AAI sequence
fails.

Add spi_nor_write_enable() after the odd-address byte program when more
data needs to be written. Use a local boolean for clarity.

Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
Cc: stable@vger.kernel.org
Signed-off-by: Sanjaikumar V S <sanjaikumar.vs@dicortech.com>
Tested-by: Hendrik Donner <hd@os-cillation.de>
Reviewed-by: Hendrik Donner <hd@os-cillation.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
[ kept inline `nor->program_opcode = SPINOR_OP_BP;` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sst.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -63,6 +63,8 @@ static int sst_write(struct mtd_info *mt
 
 	/* Start write from odd address. */
 	if (to % 2) {
+		bool needs_write_enable = (len > 1);
+
 		nor->program_opcode = SPINOR_OP_BP;
 
 		/* write one byte. */
@@ -76,6 +78,17 @@ static int sst_write(struct mtd_info *mt
 
 		to++;
 		actual++;
+
+		/*
+		 * Byte program clears the write enable latch. If more
+		 * data needs to be written using the AAI sequence,
+		 * re-enable writes.
+		 */
+		if (needs_write_enable) {
+			ret = spi_nor_write_enable(nor);
+			if (ret)
+				goto out;
+		}
 	}
 
 	/* Write out most of the data here. */


