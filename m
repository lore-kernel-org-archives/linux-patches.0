Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FFE43CEC7;
	Tue, 16 Jun 2026 18:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634534; cv=none; b=Dmtx30+1m3TjSCYvlON6vhvYzzzAL69HtiPPoGadx2XlmYhVKtjmgtxQb/WhVKWbqzcMPkV/8RwaMi+HVGj+CQlgP1DA91W6Yo3MZxbTjm/JWpXEHEbiUMX43iaRruueJm70o2+JIXadWJwtj0jC8uhy8bPSHBKhix5lY26ei88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634534; c=relaxed/simple;
	bh=f7yl/BbKLT8RF9byvvl5PbNna/Lebp72sVv+cpenqCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXVny7YDffSeNW5qP+eGSiZdfHo4TI9auSqo3ytweqHLV0+Vij5v9lSraWtjEcyrjh5Pl1ZdTINpMWJBHNA6cE1E0+mwUTm6WRHOub5nYy0dNhnHCzhJnTfPrb6AEU+pN1juBYDulShTyaw3EiKWFD0mptTTj/Pss1B+Ib2XyA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfsXiL0g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfsXiL0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5E01F000E9;
	Tue, 16 Jun 2026 18:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634533;
	bh=UXucQe9Io+UAaDANiYA7pL0m5bHYyo/g6wo9jqZOIC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfsXiL0gI18k/TbIgFgo4lGwTGMu8zwjUiEW2xuqVNPw1USaEiOZBvvxn4BczvzW8
	 erOn7X5D5gh8+ncPnpkfyP19W0pBPxpaSt4tOoALjWuqjkG4arSIOFieV4qk0SkB5k
	 7oFntaThDU28EfyEqDkmRhIrjAVP/PYIn3Kj8XXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjaikumar V S <sanjaikumar.vs@dicortech.com>,
	Hendrik Donner <hd@os-cillation.de>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/411] mtd: spi-nor: sst: Fix write enable before AAI sequence
Date: Tue, 16 Jun 2026 20:28:41 +0530
Message-ID: <20260616145116.203006163@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
@@ -112,6 +112,8 @@ static int sst_write(struct mtd_info *mt
 
 	/* Start write from odd address. */
 	if (to % 2) {
+		bool needs_write_enable = (len > 1);
+
 		nor->program_opcode = SPINOR_OP_BP;
 
 		/* write one byte. */
@@ -125,6 +127,17 @@ static int sst_write(struct mtd_info *mt
 
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


