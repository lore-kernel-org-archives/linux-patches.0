Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A53E3BB5A;
	Fri, 17 Oct 2025 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714510; cv=none; b=u7spm9XCR38Qj3YeIncmRiqyMRpEMKHrThNOCvZpe8qwD+xF3AE9iU80mc5ysvxvoGYt5YyQVvXJwoEIi2DQIb56SrEpRe8Bq3vVY6iEGkV8O29lQ/8O+FZ28KubMofGiUP6TP5mJU+Xzp2ZDgbPJmsc3ZcO6gDQG/HhISjU2Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714510; c=relaxed/simple;
	bh=FAQIZP5txqK6j11Ly+swF6oau2ML6MnNpptR2HK2Sz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rs1I7LbMUHrN999FDJy6V3aQdbL9GgweePkcROwg5biQPJKXNu6puWdGfgXmWdCSazkHYTdulq3LOa56sq0wZLBFiQ0rc1scQ/6PwzqAfl9/8PF02hAd7mRGaRzN1BJkzt8HV8yFHGl2SDy43qyZZiHO7TKEhGuVWGKIMeY1lU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLZVsBAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLZVsBAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE206C113D0;
	Fri, 17 Oct 2025 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714510;
	bh=FAQIZP5txqK6j11Ly+swF6oau2ML6MnNpptR2HK2Sz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLZVsBArlgjHSnK58uKkNmuKCYhuWt8tZv0qAaCQj7mNMrXBHa03j+PAZUVEC68mE
	 6KWXnSe6SGFcL9rdwt6ZZPfaga6Km91BQW0tNWnGgRFAm8MBod1Dlcigpl+ToUa5Y8
	 ij1/G4YvhnQT01QLGDhPLuz2esq/8n/t13Ne3YKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Chen <rex.chen_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 169/277] mmc: core: SPI mode remove cmd7
Date: Fri, 17 Oct 2025 16:52:56 +0200
Message-ID: <20251017145153.299940508@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Rex Chen <rex.chen_1@nxp.com>

commit fec40f44afdabcbc4a7748e4278f30737b54bb1a upstream.

SPI mode doesn't support cmd7, so remove it in mmc_sdio_alive() and
confirm if sdio is active by checking CCCR register value is available
or not.

Signed-off-by: Rex Chen <rex.chen_1@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250728082230.1037917-2-rex.chen_1@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -945,7 +945,11 @@ static void mmc_sdio_remove(struct mmc_h
  */
 static int mmc_sdio_alive(struct mmc_host *host)
 {
-	return mmc_select_card(host->card);
+	if (!mmc_host_is_spi(host))
+		return mmc_select_card(host->card);
+	else
+		return mmc_io_rw_direct(host->card, 0, 0, SDIO_CCCR_CCCR, 0,
+					NULL);
 }
 
 /*


