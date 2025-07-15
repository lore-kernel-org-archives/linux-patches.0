Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B142E9EB2;
	Tue, 15 Jul 2025 13:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587610; cv=none; b=YhS3GiE8riC3rmKPPYp4XiSOXWp4ZG+73BLwPRaYDIPMjDBzqs080YMg287BNGPwsKenVD3lMxhSCSCO6fFMpIExqvwFMKiYY5xZQ4TOXAll9wpv9awxnxojWWbat3AG5xyIDJUDL15ft2bB/xOS9D9hMdJIeqAK9gFyH8UE+r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587610; c=relaxed/simple;
	bh=oBA8EHgn1HyYA93kPjtEgFY8xrzWWPtROdXtlFTWzrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRQd8MsGb2C+zMxo5D69p0MnKMok0TS833J5TdMWuxmidUXhCi4oK50ttvo9BV8ujYMd9nKVyLBI54W9HOCL59tvFEmLDF7qSlL9lUU/c5vVpp4Wk7ZQMPmHgDSkFqskCmiUtsvI7alxWraTQzqwzeXywh1YU+snO3L0e01Ck4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMUmhcLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMUmhcLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CEEC4CEE3;
	Tue, 15 Jul 2025 13:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587610;
	bh=oBA8EHgn1HyYA93kPjtEgFY8xrzWWPtROdXtlFTWzrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMUmhcLrHka21TryrxP4gMbNScwkBUeJ5LoOU/AJZ1apySKDDO7t8lCc3s0pBxBwv
	 cd+p7gbmeX02tCxyULX+AkCXOFUAJDMNPPhXy3vRjrna8FaZA6zkuT2f6x6w0xcIMQ
	 e995mJJwC+BxfNr2S4pLb6T2cmlnvLVemcYLVUB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 077/208] mmc: sdhci: Add a helper function for dump register in dynamic debug mode
Date: Tue, 15 Jul 2025 15:13:06 +0200
Message-ID: <20250715130814.030239260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Shih <victor.shih@genesyslogic.com.tw>

commit 2881ba9af073faa8ee7408a8d1e0575e50eb3f6c upstream.

Add a helper function for dump register in dynamic debug mode.

Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250606110121.96314-3-victorshihgli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -813,4 +813,20 @@ void sdhci_switch_external_dma(struct sd
 void sdhci_set_data_timeout_irq(struct sdhci_host *host, bool enable);
 void __sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd);
 
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
+#define SDHCI_DBG_ANYWAY 0
+#elif defined(DEBUG)
+#define SDHCI_DBG_ANYWAY 1
+#else
+#define SDHCI_DBG_ANYWAY 0
+#endif
+
+#define sdhci_dbg_dumpregs(host, fmt)					\
+do {									\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (DYNAMIC_DEBUG_BRANCH(descriptor) ||	SDHCI_DBG_ANYWAY)	\
+		sdhci_dumpregs(host);					\
+} while (0)
+
 #endif /* __SDHCI_HW_H */


