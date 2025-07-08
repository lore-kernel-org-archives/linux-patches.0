Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869AE2E4985;
	Tue,  8 Jul 2025 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992653; cv=none; b=f9btWhqn6K4NOsAkz6Bxg0tUlRA71tLHzfm1tFxX9xZc4PHNcsjY/Xst5irHwropxs+RlhsfiQ/nRz3XgC5PnHNXi/6dVqcgb/Qm22tca4z14g3yIdH11BHaxPlImGWejWAGUEWNEAbS8+GZEx3NeNmNIEI/Jqm9uAvvGH6hj7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992653; c=relaxed/simple;
	bh=ECWiuLrV6eh4hCbriOQMxxhWqsc6XAe3tCJjAt/mGHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzAKa+kxntwkF/VtV4JU4F5zunWyLHfQlMJGI3U3tWX+JG2rrjCz+5rvrazLfKmJzcgwpFJunitOIiGVB25RJIHqy7yknyJqoVy15N6inqoTWgqbw4uFVloyQaz3PL/X26J43hXkethHge5YCHVVGkGvbURct5PY8X+IapDLmYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlKG7N2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlKG7N2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C8DC4CEED;
	Tue,  8 Jul 2025 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992653;
	bh=ECWiuLrV6eh4hCbriOQMxxhWqsc6XAe3tCJjAt/mGHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlKG7N2uvYUwL/YdiL/xvPUOuDo365bZP8bBJ2rrujxC8fvL6FlhVrY6QUwcKWRDY
	 qYvCFTUz/dzwMT6sUqnjwOZPIp8LxHO45y7zXUfQXdT1/N3lwOGmN0pPNJui8wEdtH
	 Mw+hXCmXY8b+lC9hb30Aml/8BgfA31kXbaZOXHJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 011/232] mmc: sdhci: Add a helper function for dump register in dynamic debug mode
Date: Tue,  8 Jul 2025 18:20:07 +0200
Message-ID: <20250708162241.731350607@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -825,4 +825,20 @@ void sdhci_switch_external_dma(struct sd
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


