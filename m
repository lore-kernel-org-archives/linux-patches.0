Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8367C2DF3DA;
	Tue,  8 Jul 2025 16:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992208; cv=none; b=ayXrKGDnGkWFsv53V0VvLTEfBVDnGJcoWMePol1iECAAMW6MVhY6LJ4Z8tQJ9R9PBdBx+6K72RY2norSLSKex8Bijgv531aDrkWL0PN7PAYZZwRGygQ8zZ7kRG26v/RaOXYlPiL06Nogvk9YxFQ99DRrEcc2LaN8VYgYmMw2Or8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992208; c=relaxed/simple;
	bh=zQ3m4GEle6MQldJtvBdKY2QoCnW8bYkB1RF1DvlA69M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWF/Ik8sIATKXCsATSBbSSkTLouYLUrZyBpM6C0Z00xeGPNBehTQW+tnUB7igaTlFwUz6O7pOd8S8j5+Nxf+0KD6Tt6LO59X9OQVJZd7Y/hyQZoglNCMxkfrVBNW6keNRrAkG73TqApskxaJ9CnF4KLVUMZPC2hshr6f48jbYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iclpobVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iclpobVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F54C4CEED;
	Tue,  8 Jul 2025 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992208;
	bh=zQ3m4GEle6MQldJtvBdKY2QoCnW8bYkB1RF1DvlA69M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iclpobVkYYOPJn54/cAcK0qHGkKuFp8PEdGxqpG1w9aICC0AaRPPjeKnaZXA6G4Cw
	 1Q9Yks/UUnEM3BXq15geaaFghibwrzdQWmB9bl6XBqjtkR4lTNUAGvYesuuggRz7fa
	 g1YjrSK4ki1PM9fRLZ2eblmvXmncPAA2GMDHBojQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jonathan Liu <net147@gmail.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 008/132] Revert "mmc: sdhci: Disable SD card clock before changing parameters"
Date: Tue,  8 Jul 2025 18:21:59 +0200
Message-ID: <20250708162231.002292733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit dcc3bcfc5b50c625b475dcc25d167b6b947a6637 upstream.

It has turned out the trying to strictly conform to the SDHCI specification
is causing problems. Let's revert and start over.

This reverts commit fb3bbc46c94f261b6156ee863c1b06c84cf157dc.

Cc: Erick Shepherd <erick.shepherd@ni.com>
Cc: stable@vger.kernel.org
Fixes: fb3bbc46c94f ("mmc: sdhci: Disable SD card clock before changing parameters")
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Reported-by: Jonathan Liu <net147@gmail.com>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Closes: https://bugs.debian.org/1108065
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20250624110932.176925-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2035,15 +2035,10 @@ void sdhci_set_clock(struct sdhci_host *
 
 	host->mmc->actual_clock = 0;
 
-	clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
-	if (clk & SDHCI_CLOCK_CARD_EN)
-		sdhci_writew(host, clk & ~SDHCI_CLOCK_CARD_EN,
-			SDHCI_CLOCK_CONTROL);
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
-	if (clock == 0) {
-		sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+	if (clock == 0)
 		return;
-	}
 
 	clk = sdhci_calc_clk(host, clock, &host->mmc->actual_clock);
 	sdhci_enable_clk(host, clk);


