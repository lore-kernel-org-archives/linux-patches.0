Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B9F146A8C;
	Thu, 11 Apr 2024 10:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831081; cv=none; b=IFXSWoa8lThLlIjHUtQj4w/1t23JqkWEDRFEl4xhbUxUftDbdFPmn6XF+KcDTrH4Hp7NsFLnfPNu3BH8ZnW12rmHMbHg6Cf0+xzTvthQID/FtHutvEyrQVsm4oEXNTe/0vl/vAJJEOJxhOPfdvTESNDhfajTl5ewUN4EaLapvD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831081; c=relaxed/simple;
	bh=Kon4OyxxFWpd71aIwO/QjjmE9UloWUaEIdoE9nTVbl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgBqXkIpggaG1mAbo2GjDS4dWtr0ufKvgzgj+zzG8xDjFUPx/IEorFsItR4OLtS5WDvwdzIz3+gHr7XRY5laIt/7okiwDx+WY7v966ehbCWXHC1UBbM6s5zDN7ZVcqeFwZ4fOq7xrNRO1KQcPW//mY5EUGY+JB0UuXaHdj64XTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igsmNndp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igsmNndp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8C7C433C7;
	Thu, 11 Apr 2024 10:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831081;
	bh=Kon4OyxxFWpd71aIwO/QjjmE9UloWUaEIdoE9nTVbl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igsmNndpTRAs66MJIr2GpB2lbvfUfIHPk4aYWpHN9+binySVNxMwq7RWXLp/sFH5J
	 jXp29prKjX4wm0ySw9pc/BRu5FzWt0q1ln5CSgXKPhDOVIwbTlqR6fTIJXECWWks84
	 Bx5CUvI8kpmR8sr9oeAKUCDjM+PYb0tENxRvo638=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Drake <drake@endlessos.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jian-Hong Pan <jhp@endlessos.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/215] Revert "ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default"
Date: Thu, 11 Apr 2024 11:56:41 +0200
Message-ID: <20240411095430.633842897@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <drake@endlessos.org>

[ Upstream commit cb98555fcd8eee98c30165537c7e394f3a66e809 ]

This reverts commit d52848620de00cde4a3a5df908e231b8c8868250, which was
originally put in place to work around a s2idle failure on this platform
where the NVMe device was inaccessible upon resume.

After extended testing, we found that the firmware's implementation of S3
is buggy and intermittently fails to wake up the system. We need to revert
to s2idle mode.

The NVMe issue has now been solved more precisely in the commit titled
"PCI: Disable D3cold on Asus B1400 PCI-NVMe bridge"

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215742
Link: https://lore.kernel.org/r/20240228075316.7404-2-drake@endlessos.org
Signed-off-by: Daniel Drake <drake@endlessos.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jian-Hong Pan <jhp@endlessos.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sleep.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index b9d203569ac1d..5996293f422e3 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -382,18 +382,6 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "20GGA00L00"),
 		},
 	},
-	/*
-	 * ASUS B1400CEAE hangs on resume from suspend (see
-	 * https://bugzilla.kernel.org/show_bug.cgi?id=215742).
-	 */
-	{
-	.callback = init_default_s3,
-	.ident = "ASUS B1400CEAE",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK B1400CEAE"),
-		},
-	},
 	{},
 };
 
-- 
2.43.0



