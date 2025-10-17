Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D043277A9;
	Fri, 17 Oct 2025 15:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715585; cv=none; b=cUHOnv0q9DkLrRKYU/BszxK9bLWgadGLGQCgAz4J9ZZ9caaBbLNH9a/BAkx1QJ9TzT4s84vvbaywOrMtaQJVfinCeTfJm54HG/Rd4SpwhouTSDrFaC6b1v1U0XwaPeF/j2M7fMvTgxyLqtBzwAgqc39QWwIQ7ci5oM855nvhPxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715585; c=relaxed/simple;
	bh=4zdpdPRCqq7CZdYwpS6UvU5dUA8aktcfgard61GO3ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVAnbmfusl8UH5ZcR7R0V849920bscOtlENv2KN7xGUnKgP01EIxKofheprX4Kb7sl+8vLntMXQq03k2pPcNploPFxzi4xr7n3I/QRct1hGXHwHyPspvoRbdWKYjtU/PGQ2DZq+0Hm960g2pvS2wmIr08uskgiVWZcAI4bvaER4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THQayXcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THQayXcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6389C4CEE7;
	Fri, 17 Oct 2025 15:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715585;
	bh=4zdpdPRCqq7CZdYwpS6UvU5dUA8aktcfgard61GO3ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THQayXcOs+PNuhADrZnG4Ti9LQRJVQGHOKKpJVLhi2UPBqOKW2/1eiiljQtXAg5Ke
	 yRfr6jaJFhPh00DaucJoRxpJ3D3Jk2P8KpftgD2nWN3TO8vGrQBmRb9fpdeXXaRlwx
	 xISg+jX7jmM8Mn3/SS+i5/gniX1J7fHFMpzXSJHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Chen <rex.chen_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.17 266/371] mmc: core: SPI mode remove cmd7
Date: Fri, 17 Oct 2025 16:54:01 +0200
Message-ID: <20251017145211.702201309@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


