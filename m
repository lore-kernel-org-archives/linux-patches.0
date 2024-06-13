Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943751448FD;
	Thu, 13 Jun 2024 12:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280432; cv=none; b=ecXOiQg+TapLC8BTKLjJZSB34dypw88FfyQxyOsff6l08gAYBCeOnLRAuyBJZiHwcX0i5mJJK761qWzo4BkteCwFvcCDDTF7rYnLH6BM0BDLVSjqf9od8kXpn9g7x+x/e+5RDGhrgPiRaHP6/TdDbDOipw6XdY4Tf1bS8pAbpj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280432; c=relaxed/simple;
	bh=kZSrTHFwIqdXnrap1SOs2Ov6ywi5av3fi1NwXvfbkK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZuBze6mem1Xf97fiAGN7s5dnFaoyOW0Lph4zM1vLHwzW6BiCQO2A7VCkgNU4lZN+b1hK/SThTP+Ros/d+dc2MY55KZPnl1+NtYErVsu+LUaG4EbirytNDWR+Vnowgn4PG0/ZJPyrreJd9ej8eQoiObonU2EV1/7/k1X/3Yq/sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3wzpntb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3wzpntb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A0AC2BBFC;
	Thu, 13 Jun 2024 12:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280432;
	bh=kZSrTHFwIqdXnrap1SOs2Ov6ywi5av3fi1NwXvfbkK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3wzpntbtCcnflUUZAmasZhnSRQLB7lbhC22jyUDr93iCqaG5RnKqsY1pbwUeGmKG
	 2HXUzllXMuSUT0yQ2m4amZnea1buGpfLX2YKpZdwrAdTPT41+H864vBpPywIOr7684
	 gfmfN5UT2hn1f5SWHH80wfwy7JIy2qyEJJXgu7EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 052/137] mmc: sdhci-acpi: Disable write protect detection on Toshiba WT10-A
Date: Thu, 13 Jun 2024 13:33:52 +0200
Message-ID: <20240613113225.312035523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -779,6 +779,17 @@ static const struct dmi_system_id sdhci_
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
 


