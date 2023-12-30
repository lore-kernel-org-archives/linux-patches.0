Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861C8486;
	Sat, 30 Dec 2023 12:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="US9D6Xzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A04C433C7;
	Sat, 30 Dec 2023 12:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938038;
	bh=jxojuaY9+845dnjGq1Is6JatDyGV/qJwa2qg+XRCYY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=US9D6Xzf3gjaMzx3/4ybclKtxkKD5wcfI8aFpHZ7DUErc36li10UTATAg1vDm6OBZ
	 C5D971UWtv0HwODLgnxtARSl7aO956BP8EzaCQWyeeJNdy2WAfh4Cu29qOhqPP5kuA
	 F2yHr9XTBfacpzM1WJBQVFPz2f37ElSVVmrh1i+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ronald Wahl <ronald.wahl@raritan.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 136/156] spi: atmel: Prevent spi transfers from being killed
Date: Sat, 30 Dec 2023 11:59:50 +0000
Message-ID: <20231230115816.793269633@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 890188d2d7e4ac6c131ba166ca116cb315e752ee upstream.

Upstream commit e0205d6203c2 ("spi: atmel: Prevent false timeouts on
long transfers") has tried to mitigate the problem of getting spi
transfers canceled because they were lasting too long. On slow buses,
transfers in the MiB range can take more than one second and thus a
calculation was added to progressively increment the timeout value. In
order to not be too problematic from a user point of view (waiting dozen
of seconds or even minutes), the wait call was turned interruptible.

Turning the wait interruptible was a mistake as what we really wanted to
do was to be able to kill a transfer. Any signal interrupting our
transfer would not be suitable at all so a second attempt was made at
turning the wait killable instead.

Link: https://lore.kernel.org/linux-spi/20231127095842.389631-1-miquel.raynal@bootlin.com/

All being well, it was reported that JFFS2 was showing a splat when
interrupting a transfer. After some more debate about whether JFFS2
should be fixed and how, it was also pointed out that the whole
consistency of the filesystem in case of parallel I/O would be
compromised. Changing JFFS2 behavior would in theory be possible but
nobody has the energy and time and knowledge to do this now, so better
prevent spi transfers to be interrupted by the user.

Partially revert the blamed commit to no longer use the interruptible
nor the killable variant of wait_for_completion().

Fixes: e0205d6203c2 ("spi: atmel: Prevent false timeouts on long transfers")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Link: https://lore.kernel.org/r/20231205083102.16946-1-miquel.raynal@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-atmel.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1336,12 +1336,10 @@ static int atmel_spi_one_transfer(struct
 		}
 
 		dma_timeout = msecs_to_jiffies(spi_controller_xfer_timeout(host, xfer));
-		ret_timeout = wait_for_completion_killable_timeout(&as->xfer_completion,
-								   dma_timeout);
-		if (ret_timeout <= 0) {
-			dev_err(&spi->dev, "spi transfer %s\n",
-				!ret_timeout ? "timeout" : "canceled");
-			as->done_status = ret_timeout < 0 ? ret_timeout : -EIO;
+		ret_timeout = wait_for_completion_timeout(&as->xfer_completion, dma_timeout);
+		if (!ret_timeout) {
+			dev_err(&spi->dev, "spi transfer timeout\n");
+			as->done_status = -EIO;
 		}
 
 		if (as->done_status)


