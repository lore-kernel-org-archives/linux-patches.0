Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77A21F8EE2;
	Tue,  3 Dec 2024 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240370; cv=none; b=OVYGr74dAg/WCV0z6nLDiYavaUxovdYJlPgFtPMSiHOH9bq3urZHr/MoX9brkGBFu9DPDrtk+UAQPhlRlG75zNbK/EF7rIMUZNGjtaVEhl41Z0QeTUHA8nr3no2n/5Y7hLIgpYadfjwaoEEUaRpf6Y/jVPqsordch+FUuPkPCI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240370; c=relaxed/simple;
	bh=DWbXUxtqpNQxMzLonsHmIFXkLb8LkQ/zfWHe00xGAyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uiAvre3wvjauggmc6sZ1ro37LZ75kjZrpjG2mJ35b7dmWVKLh5aG5T7cvmJVA7VvK6hIPOJE7lIA2k6AJHP5VuDOiXvmto1X2qyb0wsDT29d6zkecKpuLGgJjtRV9QHK1tjFSWxb4UTi+5JPf3Vp/kblcjbDFhXV/EJO/+q7OMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWCglzkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWCglzkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D813C4CED6;
	Tue,  3 Dec 2024 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240369;
	bh=DWbXUxtqpNQxMzLonsHmIFXkLb8LkQ/zfWHe00xGAyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWCglzkFhCsrlaCjCuJ9W/KimGLDPwjqrANZjHExZKXw1lVdLhX6iYF7rw9Rngmrl
	 L77/ZRPIjHFb0KByjFZb65y7RIqrTjc45e1W7/K5X3aS5FTiW0JtuWrcpy5MTjFB4/
	 NzxIC1P8lkJWurbAUcN0AIBkyduIG2a6U8o+S9Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/826] mmc: mmc_spi: drop buggy snprintf()
Date: Tue,  3 Dec 2024 15:37:23 +0100
Message-ID: <20241203144748.266133920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 328bda09cc91b3d93bc64f4a4dadc44313dd8140 ]

GCC 13 complains about the truncated output of snprintf():

drivers/mmc/host/mmc_spi.c: In function ‘mmc_spi_response_get’:
drivers/mmc/host/mmc_spi.c:227:64: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
  227 |         snprintf(tag, sizeof(tag), "  ... CMD%d response SPI_%s",
      |                                                                ^
drivers/mmc/host/mmc_spi.c:227:9: note: ‘snprintf’ output between 26 and 43 bytes into a destination of size 32
  227 |         snprintf(tag, sizeof(tag), "  ... CMD%d response SPI_%s",
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  228 |                 cmd->opcode, maptype(cmd));

Drop it and fold the string it generates into the only place where it's
emitted - the dev_dbg() call at the end of the function.

Fixes: 15a0580ced08 ("mmc_spi host driver")
Suggested-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20241008160134.69934-1-brgl@bgdev.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmc_spi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 8fee7052f2ef4..47443fb5eb336 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -222,10 +222,6 @@ static int mmc_spi_response_get(struct mmc_spi_host *host,
 	u8 	leftover = 0;
 	unsigned short rotator;
 	int 	i;
-	char	tag[32];
-
-	snprintf(tag, sizeof(tag), "  ... CMD%d response SPI_%s",
-		cmd->opcode, maptype(cmd));
 
 	/* Except for data block reads, the whole response will already
 	 * be stored in the scratch buffer.  It's somewhere after the
@@ -378,8 +374,9 @@ static int mmc_spi_response_get(struct mmc_spi_host *host,
 	}
 
 	if (value < 0)
-		dev_dbg(&host->spi->dev, "%s: resp %04x %08x\n",
-			tag, cmd->resp[0], cmd->resp[1]);
+		dev_dbg(&host->spi->dev,
+			"  ... CMD%d response SPI_%s: resp %04x %08x\n",
+			cmd->opcode, maptype(cmd), cmd->resp[0], cmd->resp[1]);
 
 	/* disable chipselect on errors and some success cases */
 	if (value >= 0 && cs_on)
-- 
2.43.0



