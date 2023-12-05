Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B24D8BEC;
	Tue,  5 Dec 2023 03:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfixkvGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC8BC433C8;
	Tue,  5 Dec 2023 03:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746328;
	bh=FuHwLO+sE+JD3yP/FpiIsfPvqUHNdSq9H0qX74xstnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfixkvGjnxmsjnFllnbjMs2HIqqTMNyoOlbDKEnoeInTZ2f7YjCmMSkC0GSDUAhVj
	 dk+pA96ooC7DbdnUU9Dc2TcjcJZEDapjClSZoXAYMMIw4M9eMQ7fCfNIaU8XCKGNQF
	 89tlrBCUC8ompCbPMMqhcUHSIScBKt+/JnVzq8uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claire Lin <claire.lin@broadcom.com>,
	Ray Jui <ray.jui@broadcom.com>,
	Kamal Dasu <kdasu.kdev@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Yuta Hayama <hayama@lineo.co.jp>
Subject: [PATCH 4.14 11/30] mtd: rawnand: brcmnand: Fix ecc chunk calculation for erased page bitfips
Date: Tue,  5 Dec 2023 12:16:18 +0900
Message-ID: <20231205031512.153069003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031511.476698159@linuxfoundation.org>
References: <20231205031511.476698159@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claire Lin <claire.lin@broadcom.com>

commit 7f852cc1579297fd763789f8cd370639d0c654b6 upstream.

In brcmstb_nand_verify_erased_page(), the ECC chunk pointer calculation
while correcting erased page bitflips is wrong, fix it.

Fixes: 02b88eea9f9c ("mtd: brcmnand: Add check for erased page bitflips")
Signed-off-by: Claire Lin <claire.lin@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Yuta Hayama <hayama@lineo.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/brcmnand/brcmnand.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/brcmnand/brcmnand.c
@@ -1753,6 +1753,7 @@ static int brcmstb_nand_verify_erased_pa
 	int bitflips = 0;
 	int page = addr >> chip->page_shift;
 	int ret;
+	void *ecc_chunk;
 
 	if (!buf) {
 		buf = chip->buffers->databuf;
@@ -1769,7 +1770,9 @@ static int brcmstb_nand_verify_erased_pa
 		return ret;
 
 	for (i = 0; i < chip->ecc.steps; i++, oob += sas) {
-		ret = nand_check_erased_ecc_chunk(buf, chip->ecc.size,
+		ecc_chunk = buf + chip->ecc.size * i;
+		ret = nand_check_erased_ecc_chunk(ecc_chunk,
+						  chip->ecc.size,
 						  oob, sas, NULL, 0,
 						  chip->ecc.strength);
 		if (ret < 0)


