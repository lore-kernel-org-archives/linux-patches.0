Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D223208;
	Fri, 17 Oct 2025 15:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713257; cv=none; b=VpO4ipzOu9EvRZpawQ8aSRzTjUNgxBdDvb3D2mXUVBu19CMWuXGx0dvmTGMAJ9t6FMpYuN+paWlW5+z1EMFdyDI5ZrKP6US/VJT51wKTxTEK1yWOzG1RWX22aE1a8LJnecwtTBHG7QFXQixsNPgpJsccb1c3vkyzrJVK3cDtBrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713257; c=relaxed/simple;
	bh=Ogi7HJ2VpwkbCCqEdrWzJXHpAXA0LeZ7bOFaOadCHgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pP2Bdg+jCLfWDKUou9NFsJb6SUVx7AAx9sNG6DMJV/jvpAsjiJOZmRawr84Nthi4WbOkOdrojPmHI8V5NpeZk1dQXx5upTqsNRUlOVXdcliOdhU3fIr+dmRYNKZFxKwHOuw2bMDECSoCGHN0JXxizXcigyQdBp5uNQhRIeZAYVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS8K5Gq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS8K5Gq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBFAC4CEFE;
	Fri, 17 Oct 2025 15:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713257;
	bh=Ogi7HJ2VpwkbCCqEdrWzJXHpAXA0LeZ7bOFaOadCHgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS8K5Gq3p7RQ65/zBtMK954GEltOU37jfkUgMhwkVx7DmxAdBFbBzpuN7RyYBYrOB
	 bRC3hk/4tixcbfWZioXt1sIyHYHtfYrmSdOEbn6SiArMsfdO3w4qmp6hMbiFFMiAz8
	 W8laUu/eMYf188N43k6LrApr3YEBm6KessJ+LGn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Chen <rex.chen_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 103/168] mmc: core: SPI mode remove cmd7
Date: Fri, 17 Oct 2025 16:53:02 +0200
Message-ID: <20251017145132.821666014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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


