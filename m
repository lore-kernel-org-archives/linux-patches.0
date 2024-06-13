Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A317FD;
	Thu, 13 Jun 2024 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282723; cv=none; b=PkcoiHoPtTuu11vJHGoPMCjPnOZxIjsboVA8pG+0FRe2x4hPCEHUZCUMFZwos5bQMkoHGcrvpzNCQaZSx6KEgfUUv/7igXVvMPCafZYnG6B1BGowsi1AMDljy4A+2/KB8wjmzYPTtKuIG0wJbCmxjMMuElbTlxvB8YTOuZ7f23k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282723; c=relaxed/simple;
	bh=0IGOi/jqgsD99IAaitNM95LJIh+yw1RVSTFHgzLwom0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7JCneFGD9UXILQ6WYZoKE8COUTyXqSo9QCqGqWndEjxjkn/m8jqzCiaJLUXE5liUgrkXo1l2hQ1IgIM8ogWMdcl/sRwaqVGm37FpT0NUD5Mwu9lKqu9A2IPrvjTI7TV4qE529JoQeibW33KzFUwishyVM4d6ym3h4Ehqnubfkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvQVdr+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvQVdr+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1BFC32786;
	Thu, 13 Jun 2024 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282722;
	bh=0IGOi/jqgsD99IAaitNM95LJIh+yw1RVSTFHgzLwom0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvQVdr+Jrp7JZCr3UjxJWCc+g5G3p1Cc1388bH4TIeg7QPbxyQBtfwpPzNEbkz73e
	 yRSD1h8FnQXu2i1RSwRPhk9ayo76/WehTKUWd1Q2sX3zU9TMPKSg/maenJyLd/hvPa
	 RwWoEMsUnZRCdZg7eD7ufgKKxuM3QgmvPxU5Lc08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 373/402] mmc: sdhci-acpi: Disable write protect detection on Toshiba WT10-A
Date: Thu, 13 Jun 2024 13:35:30 +0200
Message-ID: <20240613113316.687008722@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit ef3eab75e17191e5665f52e64e85bc29d5705a7b upstream.

On the Toshiba WT10-A the microSD slot always reports the card being
write-protected, just like on the Toshiba WT8-B.

Add a DMI quirk to work around this.

Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240410191639.526324-6-hdegoede@redhat.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-acpi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -855,6 +855,17 @@ static const struct dmi_system_id sdhci_
 		},
 		.driver_data = (void *)DMI_QUIRK_SD_NO_WRITE_PROTECT,
 	},
+	{
+		/*
+		 * The Toshiba WT10-A's microSD slot always reports the card being
+		 * write-protected.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TOSHIBA WT10-A"),
+		},
+		.driver_data = (void *)DMI_QUIRK_SD_NO_WRITE_PROTECT,
+	},
 	{} /* Terminating entry */
 };
 


