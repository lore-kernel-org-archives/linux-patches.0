Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1370742DA3F;
	Fri,  7 Aug 2026 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114244; cv=none; b=H4UcInAyC2BJAEBC7rw5HjXVAnOSgMIAv//1GYa5gvb5E+s/mhAtEkiXPXK+4tbWRSOX3ZXRqkoS/wJS85FjJVhrxPvhed3VStLpqKlNElqglKq3gUfWFrYjocnw81fWem8dW1OlACnWwuuOSrBuooJIc4ZWBuRnBv6tKgE8zqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114244; c=relaxed/simple;
	bh=yEQ9KBpARuRRpyHT7eZWwQHKSnpTGlg9KWnLOrlLthM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzZkt3KnQNXeOh0GqUnsqEhqe0RTp8Vb09Gw4qCBHRtN8wKXLrPPW57CTeUb1KR1EYGQZ4YkYOJW9frG+Fs/S6yb0QtI+eMfRhayK7tYut7x8J8X5FcbRYlByq7C4/Y76a4BpTtqGYNcMNJqt7xYc1IqW6Oewi6BSu/BKUhcGYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDLZHYEZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDLZHYEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9781F00A3E;
	Fri,  7 Aug 2026 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114240;
	bh=dpwqCWorT8VGX5yAVt0Yu/YH9ArZr+hwrmO6fOLrfFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDLZHYEZos1siIWwJP8pxEBO3x7TIpT4QK7gyhe5BG/vMXtyJ1hlR+7Rr1yaCXbKA
	 fRUsXyjooYwIlpwCYitWm3jJaYHrFkbDUL5jlutmtcxFPONq0U2ST7Dg4mVDP5z92K
	 A24bPvf9vFY5E5c8L6vL4K1SA61reHXtSebyi9GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 194/337] spi: qcom-qspi: Correct max DMA length to avoid 64K boundary failure
Date: Fri,  7 Aug 2026 16:36:37 +0200
Message-ID: <20260807143422.761535149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>

commit 90ef2f2961c2dc55957dafe2f53b3efdb4675efc upstream.

The maximum size for a DMA data descriptor is 64KB-1 because the size
field in HW is 16 bits wide. For this reason, transfers fail at 64KB
and beyond.

Lower max_dma_len to 60KB so larger transfers are split into multiple
DMA blocks and do not hit the failing 64KB boundary. 60KB is chosen as
a safe round number below the 64KB-1 hardware limit while satisfying
alignment requirements.

Tested on x1e80100 (Hamoa) with SPI-NOR flash (/dev/mtd0):

Without patch:
  dd if=/dev/mtd0 of=/tmp/spi_dump.bin bs=32768 count=2  # works
  dd if=/dev/mtd0 of=/tmp/spi_dump.bin bs=65536 count=1  # fails

With patch:
  dd if=/dev/mtd0 of=/tmp/spi_dump.bin bs=65536 count=1  # works

Fixes: b5762d95607e ("spi: spi-qcom-qspi: Add DMA mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260722092358.459943-1-vnivarth@qti.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qcom-qspi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -759,7 +759,8 @@ static int qcom_qspi_probe(struct platfo
 		return dev_err_probe(dev, ret, "could not set DMA mask\n");
 
 	host->max_speed_hz = 300000000;
-	host->max_dma_len = 65536; /* as per HPG */
+	/* as per HPG, it is 64KB, limit to 60KB to avoid boundary condition failures */
+	host->max_dma_len = 0xf000;
 	host->dma_alignment = QSPI_ALIGN_REQ;
 	host->num_chipselect = QSPI_NUM_CS;
 	host->bus_num = -1;


