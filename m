Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDFC8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C50C433C7;
	Sun, 16 Jul 2023 20:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539305;
	bh=K9B+w4Xvaj5BnylAtvpWvjyUye1JbhDvaLJ4XwSu1Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ca50iIAyLDTCBaaiKMvgDtXeBtyh9cF+N1+ZUK/qwwDawK2GDXgO3gHCWbg+/yaVe
	 f35jbEqy/3FHhreKT+2cotdYBkswKGpyALNW7qmYvQ2M5ogyfB5ZZ4Icefn/08ADM3
	 q/3WQSGsofLx6Gh6W/TYtc5g91Xc7Bce87EUXAv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chevron Li <chevron.li@bayhubtech.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.4 729/800] mmc: sdhci: fix DMA configure compatibility issue when 64bit DMA mode is used.
Date: Sun, 16 Jul 2023 21:49:42 +0200
Message-ID: <20230716195006.051201699@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chevron Li <chevron.li@bayhubtech.com>

commit 20dbd07ef0a8bc29eb03d6a95258ac8934cbe52d upstream.

Bayhub SD host has hardware limitation:
1.The upper 32bit address is inhibited to be written at SD Host Register
  [03E][13]=0 (32bits addressing) mode, is admitted to be written only at
  SD Host Register [03E][13]=1 (64bits addressing) mode.
2.Because of above item#1, need to configure SD Host Register [03E][13] to
  1(64bits addressing mode) before set 64bit ADMA system address's higher
  32bits SD Host Register [05F~05C] if 64 bits addressing mode is used.

The hardware limitation is reasonable for below reasons:
1.Normal flow should set DMA working mode first, then do
  DMA-transfer-related configuration, such as system address.
2.The hardware limitation may avoid the software to configure wrong higher
  32bit address at 32bits addressing mode although it is redundant.

The change that set 32bits/64bits addressing mode before set ADMA address,
  has no side-effect to other host IPs for below reason:
The setting order is reasonable and standard: DMA Mode setting first and
  then DMA address setting. It meets all DMA setting sequence.

Signed-off-by: Chevron Li <chevron.li@bayhubtech.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230523111114.18124-1-chevron_li@126.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1167,6 +1167,8 @@ static void sdhci_prepare_data(struct sd
 		}
 	}
 
+	sdhci_config_dma(host);
+
 	if (host->flags & SDHCI_REQ_USE_DMA) {
 		int sg_cnt = sdhci_pre_dma_transfer(host, data, COOKIE_MAPPED);
 
@@ -1186,8 +1188,6 @@ static void sdhci_prepare_data(struct sd
 		}
 	}
 
-	sdhci_config_dma(host);
-
 	if (!(host->flags & SDHCI_REQ_USE_DMA)) {
 		int flags;
 


