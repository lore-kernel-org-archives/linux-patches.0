Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9001586C5;
	Mon, 29 Jan 2024 17:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548367; cv=none; b=DgNkIEIeudKpNdmI+PfxA7ncDoTpJuGiiivsDsslck16Bxh6aVwwlRI2zNrgO2ZkeCuO2169tHkhM1kHxnpEA1cdDx6b25md+0EGm6gfbChkO0+r7wgzUD5/qNFtLFLQYGW2GuuILP5+QBCey7xKZ289AsjpFqmXgwBifRrvUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548367; c=relaxed/simple;
	bh=8DRFtSPxf636GA2eNgoGWsn6mgFK0rhYAVd98eJhyXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzjhyGP6uUqk3QqUa2go7AWYO4DTMYw64D6Kx2PaN09XzcPZK/mR6vghF7Pz6i9yMgYD9u26ZuTSO+cRoLSy8VTi9ml+LNpUgFkUIVdA4a2ekvtoT7MKWnEEIRWV6WykUis2vTHrLYMJSlRvKvNu+XMexyT91JjVEtNlP972i6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYum8Mld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYum8Mld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3426C43394;
	Mon, 29 Jan 2024 17:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548366;
	bh=8DRFtSPxf636GA2eNgoGWsn6mgFK0rhYAVd98eJhyXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYum8MldUiw88qL1CHNWKChhPiPFscSrHoDawqU2dYEyX0Ab/vrnsBXwcWbyS0ne5
	 nUK6i4RhRLmSQO/Z6hvufIAr/uaLggF23APH60h2aRW5dy5it554cyOww48EthxBXu
	 6dfg009tPKd+9CKpul2ASL38lwJrIaUbf5izF6kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	George Melikov <mail@gmelikov.ru>
Subject: [PATCH 6.1 131/185] gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-04
Date: Mon, 29 Jan 2024 09:05:31 -0800
Message-ID: <20240129170002.793974246@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 805c74eac8cb306dc69b87b6b066ab4da77ceaf1 upstream.

Spurious wakeups are reported on the GPD G1619-04 which
can be absolved by programming the GPIO to ignore wakeups.

Cc: stable@vger.kernel.org
Reported-and-tested-by: George Melikov <mail@gmelikov.ru>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3073
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1626,6 +1626,20 @@ static const struct dmi_system_id gpioli
 			.ignore_wake = "ELAN0415:00@9",
 		},
 	},
+	{
+		/*
+		 * Spurious wakeups from TP_ATTN# pin
+		 * Found in BIOS 0.35
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/3073
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GPD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "G1619-04"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "PNP0C50:00@8",
+		},
+	},
 	{} /* Terminating entry */
 };
 


