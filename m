Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137D359701;
	Fri,  9 Jan 2026 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962222; cv=none; b=newM8ncmOEDBkGsO9o4i/DVREew0LNlshMgW+Og2E/ff1Qfl17wADF6YgouyQMm2r+H4qczgBI6Fha92MlDb7k/u25X+e3sUHXciXGqLZSVA1GAKpcj/gXjpH/NKr2xRdKQhNOfwsUBtni6OToW4iAWdKA5yCsNR3USxW4eB5aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962222; c=relaxed/simple;
	bh=1uqyp8IlEsiizIwuAFWLTKEQ4jHpljuAxGy6yBlV8VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSVNU3rHqhhZzsaXy3/bjiRh2iqA+GEArTipiX01sdtMnKPEZMBEIzp8SIblYet2hkpE1ZBz1zdR6SGXn6gSWvfz/hc6eexOtCjldFHQuvUMuzOcScub8wgPmaHHIL0YkFTCO1f7s79mDbxff6YpBjRx1TwQA+PCZ+AxAdHIV/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdwkeddG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdwkeddG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24998C4CEF1;
	Fri,  9 Jan 2026 12:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962222;
	bh=1uqyp8IlEsiizIwuAFWLTKEQ4jHpljuAxGy6yBlV8VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdwkeddGS9pu7ixjCc8epLnKvxdNEXhL9xD6g0D6dcxwGJZnyemlbUpi3knGSVQKG
	 nrpxahHnr6qIPWlyNjoZI5S0AiSkOkSsjsl8qJwHfkOxWIVgDv6L+EMBHLZf1S5GGI
	 dB5ee5u0r3Ah2TQHdp7FN7aFc9HJ2j4e0fkCuEcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sverdlin Alexander <alexander.sverdlin@siemens.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 290/634] spi: fsl-cpm: Check length parity before switching to 16 bit mode
Date: Fri,  9 Jan 2026 12:39:28 +0100
Message-ID: <20260109112128.443700160@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 1417927df8049a0194933861e9b098669a95c762 upstream.

Commit fc96ec826bce ("spi: fsl-cpm: Use 16 bit mode for large transfers
with even size") failed to make sure that the size is really even
before switching to 16 bit mode. Until recently the problem went
unnoticed because kernfs uses a pre-allocated bounce buffer of size
PAGE_SIZE for reading EEPROM.

But commit 8ad6249c51d0 ("eeprom: at25: convert to spi-mem API")
introduced an additional dynamically allocated bounce buffer whose size
is exactly the size of the transfer, leading to a buffer overrun in
the fsl-cpm driver when that size is odd.

Add the missing length parity verification and remain in 8 bit mode
when the length is not even.

Fixes: fc96ec826bce ("spi: fsl-cpm: Use 16 bit mode for large transfers with even size")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/638496dd-ec60-4e53-bad7-eb657f67d580@csgroup.eu/
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Sverdlin Alexander <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/3c4d81c3923c93f95ec56702a454744a4bad3cfc.1763627618.git.christophe.leroy@csgroup.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -352,7 +352,7 @@ static int fsl_spi_prepare_message(struc
 			if (t->bits_per_word == 16 || t->bits_per_word == 32)
 				t->bits_per_word = 8; /* pretend its 8 bits */
 			if (t->bits_per_word == 8 && t->len >= 256 &&
-			    (mpc8xxx_spi->flags & SPI_CPM1))
+			    !(t->len & 1) && (mpc8xxx_spi->flags & SPI_CPM1))
 				t->bits_per_word = 16;
 		}
 	}


