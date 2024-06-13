Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FB7144D3A;
	Thu, 13 Jun 2024 12:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281554; cv=none; b=J3G9ksirLUx4wHYuZAEljNZCswmV0cqJdseq50WXSxPFe55d1GXo4so193Z8XeHyrr3DwT8BVW0ElJYszYVAy8/jbWTQkH+PNLpWhkZfBml5I/NnfrhHf57V2TrUZ6UbWpbrRtqEr1ktCapIwkBwM7R7q59KRiZfE8AfqsxjD50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281554; c=relaxed/simple;
	bh=wNMynpduxNufQmnn6frkFAtYQn5PaDiLxyCkWHD0DZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKcqQjKiImY+WxS0PSVnHCUiG9pupcCgIcBma9DWFqUhLjA7IeANKpI5LryDp3/IqqMd3UJnEc/TY9VvAez7c2Tb/K/qAD6t004uHWKY9odWkhifE+R2WCRE1m6RdZuru24AamSjeRUnZx3aqWQTvQ2PFUni2KU1tZTE/OM8jKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsIqVwfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsIqVwfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EDDC2BBFC;
	Thu, 13 Jun 2024 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281554;
	bh=wNMynpduxNufQmnn6frkFAtYQn5PaDiLxyCkWHD0DZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsIqVwfQ4bM5Gpdhrp9yDAM6UJtNQ8CJuCUb1TjbPRE9Q+GOlgSiZAzZob6eR+yED
	 HQqym5FyV54297GEASH3XefwYklQMu1aNTyAjzHSjS37qlv4m/GTtvu5tNy6bV/Xt6
	 y6+wjbqhVqrRNcvMOauXHiSqGpaJpU7p8Z/f2S9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 293/317] mmc: sdhci-acpi: Disable write protect detection on Toshiba WT10-A
Date: Thu, 13 Jun 2024 13:35:11 +0200
Message-ID: <20240613113258.886069134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -821,6 +821,17 @@ static const struct dmi_system_id sdhci_
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
 


