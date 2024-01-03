Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F41BDDE;
	Wed,  3 Jan 2024 17:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyqmPDc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C499C433C8;
	Wed,  3 Jan 2024 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301342;
	bh=tGYPz9V0O4H55/RhyTr936i/52vPNUlQFl133j+9ppU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyqmPDc63p5IplRcNS48yrbvJeCY9oRreLfTZ93BU5ZkcuiPKyJyF7sU5iDv7sR8o
	 pHoX4mKbZhX3qVbvVM4t1VTo1J+5Lf9ka9RQ3RWNgucV/2UJ4dSOCAJA4sAJjrl4TE
	 oAcjuZpsXB/lY/MJaorBgifgyEg0SrAczQNwHBxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/100] spi: Reintroduce spi_set_cs_timing()
Date: Wed,  3 Jan 2024 17:55:10 +0100
Message-ID: <20240103164908.259988352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit 684a47847ae639689e7b823251975348a8e5434f ]

commit 4ccf359849ce ("spi: remove spi_set_cs_timing()"), removed the
method as noboby used it. Nobody used it probably because some SPI
controllers use some default large cs-setup time that covers the usual
cs-setup time required by the spi devices. There are though SPI controllers
that have a smaller granularity for the cs-setup time and their default
value can't fulfill the spi device requirements. That's the case for the
at91 QSPI IPs where the default cs-setup time is half of the QSPI clock
period. This was observed when using an sst26vf064b SPI NOR flash which
needs a spi-cs-setup-ns = <7>; in order to be operated close to its maximum
104 MHz frequency.

Call spi_set_cs_timing() in spi_setup() just before calling spi_set_cs(),
as the latter needs the CS timings already set.
If spi->controller->set_cs_timing is not set, the method will return 0.
There's no functional impact expected for the existing drivers. Even if the
spi-mt65xx.c and spi-tegra114.c drivers set the set_cs_timing method,
there's no user for them as of now. The only tested user of this support
will be a SPI NOR flash that comunicates with the Atmel QSPI controller for
which the support follows in the next patches.

One will notice that this support is a bit different from the one that was
removed in commit 4ccf359849ce ("spi: remove spi_set_cs_timing()"),
because this patch adapts to the changes done after the removal: the move
of the cs delays to the spi device, the retirement of the lelgacy GPIO
handling. The mutex handling was removed from spi_set_cs_timing() because
we now always call spi_set_cs_timing() in spi_setup(), which already
handles the spi->controller->io_mutex, so use the mutex handling from
spi_setup().

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20221117105249.115649-4-tudor.ambarus@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fc70d643a2f6 ("spi: atmel: Fix clock issue when using devices with different polarities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index dfce0f7d4c640..f1ed2863a183e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3623,6 +3623,37 @@ static int __spi_validate_bits_per_word(struct spi_controller *ctlr,
 	return 0;
 }
 
+/**
+ * spi_set_cs_timing - configure CS setup, hold, and inactive delays
+ * @spi: the device that requires specific CS timing configuration
+ *
+ * Return: zero on success, else a negative error code.
+ */
+static int spi_set_cs_timing(struct spi_device *spi)
+{
+	struct device *parent = spi->controller->dev.parent;
+	int status = 0;
+
+	if (spi->controller->set_cs_timing && !spi->cs_gpiod) {
+		if (spi->controller->auto_runtime_pm) {
+			status = pm_runtime_get_sync(parent);
+			if (status < 0) {
+				pm_runtime_put_noidle(parent);
+				dev_err(&spi->controller->dev, "Failed to power device: %d\n",
+					status);
+				return status;
+			}
+
+			status = spi->controller->set_cs_timing(spi);
+			pm_runtime_mark_last_busy(parent);
+			pm_runtime_put_autosuspend(parent);
+		} else {
+			status = spi->controller->set_cs_timing(spi);
+		}
+	}
+	return status;
+}
+
 /**
  * spi_setup - setup SPI mode and clock rate
  * @spi: the device whose settings are being modified
@@ -3719,6 +3750,12 @@ int spi_setup(struct spi_device *spi)
 		}
 	}
 
+	status = spi_set_cs_timing(spi);
+	if (status) {
+		mutex_unlock(&spi->controller->io_mutex);
+		return status;
+	}
+
 	if (spi->controller->auto_runtime_pm && spi->controller->set_cs) {
 		status = pm_runtime_resume_and_get(spi->controller->dev.parent);
 		if (status < 0) {
-- 
2.43.0



