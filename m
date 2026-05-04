Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805D53DE45A;
	Mon,  4 May 2026 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904226; cv=none; b=j23Sg1rAI/MEYLWupqtDJHcKocjOGBTfwzPIGhHageVJOGDtILwEGxOxn9oMt/4FCoxEjtIqC19eVthESV3A3eq++3T8GWjHHeiJzA8quiqfI1mHTSFNUmVPTlP+qv/4A9KgVBOxW0MRNw0B+M8mlygqKV3BvdctK2hHVO1toyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904226; c=relaxed/simple;
	bh=/tWs2VnnBVzkVkMcd5iv4Zd+ICUqci4Geobfw5/sHp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8imTVqpNKLj35rMRSqHkf9MF0hNEryAN7cZ7N3Rp4sK2iqb55igxosBd/BNATJcMVsA0uLMpAPO8aoAEEI26XuSpJG58LIpJQCD9FmWH+4Bw7LJnuuN65lJvP7klwcS/F/OQxvU1XXpSWgVRDF4VGjLXKD5uNy64WiiYxaH4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nbnbpjw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nbnbpjw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A25C2BCB8;
	Mon,  4 May 2026 14:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904226;
	bh=/tWs2VnnBVzkVkMcd5iv4Zd+ICUqci4Geobfw5/sHp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nbnbpjw7HTcEywQGuWvBwqnPJd3F2dkHQ3kLZ1ZBuaIhqXQiv3BORag596y4Mrxdn
	 nD/IxYjKARzSbALTT5xX9N5yJp+1M589swJQtRaXhlEN40vXYJLLc4G+0Yj+GLUBSu
	 kPr0UIyIgSNLfVn0mzH8yZ9tR2PWzsGivMwU5AvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjaikumar V S <sanjaikumar.vs@dicortech.com>,
	Hendrik Donner <hd@os-cillation.de>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: [PATCH 6.18 199/275] mtd: spi-nor: sst: Fix write enable before AAI sequence
Date: Mon,  4 May 2026 15:52:19 +0200
Message-ID: <20260504135150.469507879@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Sanjaikumar V S <sanjaikumar.vs@dicortech.com>

commit a0f64241d3566a49c0a9b33ba7ae458ae22003a9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sst.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -203,6 +203,8 @@ static int sst_nor_write(struct mtd_info
 
 	/* Start write from odd address. */
 	if (to % 2) {
+		bool needs_write_enable = (len > 1);
+
 		/* write one byte. */
 		ret = sst_nor_write_data(nor, to, 1, buf);
 		if (ret < 0)
@@ -210,6 +212,17 @@ static int sst_nor_write(struct mtd_info
 
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


