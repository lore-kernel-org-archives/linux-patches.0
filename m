Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B723ABAF;
	Tue, 15 Jul 2025 13:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586417; cv=none; b=fGAbb2v27drOYTA/XM0kWwQ+1IcPn+qPKS7ldIXcGbOVrC5nzOMvf+Zxus54iOVk3cptB5CHmY9eW6AQMCoi7eAvOVnBjVa8p4HgHpjLKP6HwSocl0ODOlaAvNzJ31iy1tboSigsSR2pGskCJD7q8UnMku2FFBYSGUlBJd7xvVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586417; c=relaxed/simple;
	bh=vQMxG+dtStwQWd3JoOoTDMvuu+YEWnj8bAEsu3NaAyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY0RbgakdrwyztF1IWgMVDPi2AGeFF3GaZXlNSbiLhQQd08ROqENi0SMlvQx5KDp4zCL/J18r2fIwM1gPhJEK0aWLeMZjch9+vvhAP8N6VlZXuHXOJYfzrVgX7cdAQoMYFit9cLl4+z+br+/QAz6stUULuW6Iu+8wddag8t66DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shvuVlLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shvuVlLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78EDC4CEE3;
	Tue, 15 Jul 2025 13:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586417;
	bh=vQMxG+dtStwQWd3JoOoTDMvuu+YEWnj8bAEsu3NaAyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shvuVlLWGMJzvHd05JX0KbPXJ/4HUC62Verl/qAjOwlJ+qGPpC9+EPmPj7FmPE7J2
	 WZwMPq0IlLqX2cHyI0e7Yk2c2P4p5OHHaPa4zSZwMUJ4VpuRESsgs3/ODOGuQB5gfQ
	 xbRn6p6Yw9SBLObqH8pjkCBKICSWc/36yOuRA5bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 057/148] mmc: sdhci: Add a helper function for dump register in dynamic debug mode
Date: Tue, 15 Jul 2025 15:12:59 +0200
Message-ID: <20250715130802.610804014@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -801,4 +801,20 @@ void sdhci_abort_tuning(struct sdhci_hos
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


