Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C4FBA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF1AC4339B;
	Tue,  7 Mar 2023 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211607;
	bh=hPewh0/nGVNuEzvBReTd2k8UkTZtWu+4RhUM1c16L3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j72p/PCDHV38yNqL+m47xkZFGxfl5/q4OVZca8pMcWI/+0Yj8Fi4moGK7Q6Pt+/ac
	 SQi9Ke0fo+G+n6+A8QS67803CnePkEdq+SqWgyZvmbHM0T9TZlh6m3IDdsUm/HVT1O
	 E8X30bjxr6NJZ0jMtJ8JOHYDEABiF6CHvXf0K4Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Witkowski <marcin.witkowski@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 0917/1001] spi: intel: Check number of chip selects after reading the descriptor
Date: Tue,  7 Mar 2023 18:01:29 +0100
Message-Id: <20230307170101.863281058@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 574fbb95cd9d88bdc9c9c4c64223a38a61d7de9a upstream.

The flash decriptor contains the number of flash components that we use
to figure out how many flash chips there are connected. Therefore we
need to read it first before deciding how many chip selects the
controller has.

Reported-by: Marcin Witkowski <marcin.witkowski@intel.com>
Fixes: 3f03c618bebb ("spi: intel: Add support for second flash chip")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20230215110040.42186-1-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-intel.c b/drivers/spi/spi-intel.c
index f619212b0d5c..627287925fed 100644
--- a/drivers/spi/spi-intel.c
+++ b/drivers/spi/spi-intel.c
@@ -1368,14 +1368,14 @@ static int intel_spi_populate_chip(struct intel_spi *ispi)
 	if (!spi_new_device(ispi->master, &chip))
 		return -ENODEV;
 
-	/* Add the second chip if present */
-	if (ispi->master->num_chipselect < 2)
-		return 0;
-
 	ret = intel_spi_read_desc(ispi);
 	if (ret)
 		return ret;
 
+	/* Add the second chip if present */
+	if (ispi->master->num_chipselect < 2)
+		return 0;
+
 	chip.platform_data = NULL;
 	chip.chip_select = 1;
 
-- 
2.39.2



