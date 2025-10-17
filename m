Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23F9288A2;
	Fri, 17 Oct 2025 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713884; cv=none; b=uOSsVf5GxB9Lo4lZZ6X1O7pe38BxChDO/nNXozCKU1MW3Rz2M7upEUQ3RDdeS+eI4wVLueDIzTnM6QBp1IEWpOhqqztz1md0Hvd47TDxBkqVwflkZQXaTXMr4cUepCWLsQIRYjrW2pLT8ShjoU0/sMoaPtm5wUN299XyEmZnW9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713884; c=relaxed/simple;
	bh=ALgrt0DWv0fc9qZgD93OxJROKDDLRnsov3qaHI3Wo/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rv1sM6OmlIyV+ioyVz3Rzk+hWAhLtN+HYf+fsEVv2kvKRJyJYOXuXH8vVNtq7gl6lmDfRdM/OoWJstMSTnTk15zOHsAb29LIbgFwBgBYNOOr1Z4g6sZ8rJnbGc/GzIB1iG6PgMOa3fdSOgxDaWt+/YscoypI0jbY40wP9r0Ubvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFq9cLHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFq9cLHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAE2C4CEE7;
	Fri, 17 Oct 2025 15:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713884;
	bh=ALgrt0DWv0fc9qZgD93OxJROKDDLRnsov3qaHI3Wo/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFq9cLHJ5lnAYLrTtMkcYvj3APS+UqmJs0toUHsnqqhhHzNtqHCza2P6+vwyh7UYs
	 3XYAAlB0Y2lZqoWJsxfgaEYpE+Ccymbww13J1AM7PHzzCf6QLTOAtY2So+L4Kkj8/q
	 BWvm2Kxhe1IwVEqY8/RDoUN9QqorRXXPDTtu4drM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Chen <rex.chen_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 120/201] mmc: core: SPI mode remove cmd7
Date: Fri, 17 Oct 2025 16:53:01 +0200
Message-ID: <20251017145139.152363189@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


