Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5DA21B199;
	Tue,  8 Jul 2025 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991984; cv=none; b=PltbwlhW/wu5MPyXC4zDcqUUFZUAZkSvDiGDT/ecwEyPxGiZqCYcQxWWNTXf8quiKEx8WXgRZVdYHabiRdH34pKAxKswk+PHKzeKqjf3okhcP/4wf4xtrA9R3GVhCvo/OEgAwazKIzrvGLKe1O7Kv3RLCkkHHDpGJZWLj+3Qe7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991984; c=relaxed/simple;
	bh=OCl1l/fKqfy0BF0KbDdLme910Gs9XfOTdluedkEFmMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0hgtL1n5woLsbtpuD9jbz4vBoWQY6IG2e1nPL3t88T9cnLPF2r4y755QBStprdEE7o5aId7M0vlFqieVt0aHvs0R0cfnBfCgGCNyMln3dLBclZCtpeIuvVQsX1za1kmmNe4dru914ajveTwH+vmwlrhxjHbKLqs2cVMEOOEtI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZuJgeFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZuJgeFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C67C4CEED;
	Tue,  8 Jul 2025 16:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991984;
	bh=OCl1l/fKqfy0BF0KbDdLme910Gs9XfOTdluedkEFmMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZuJgeFCeei7rG9/sihKFWv1Ol1HghvHttztekmSa0MJdl3LsyIugdSQ/gBvRWBvr
	 ytacrdIQ9e26Hvc/XLg5Jc+jXb9g4nYeY3X28T9WJuojN1IShv0EccezvCl4bO3Uiy
	 w/G2jR7dTskrSsDDgDPcoI6uZOd0xlXN4KpoDtT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 04/81] mmc: sdhci: Add a helper function for dump register in dynamic debug mode
Date: Tue,  8 Jul 2025 18:22:56 +0200
Message-ID: <20250708162224.973457784@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -820,4 +820,20 @@ void sdhci_switch_external_dma(struct sd
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


