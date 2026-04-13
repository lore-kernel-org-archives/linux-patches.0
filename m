Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB9428505E;
	Mon, 13 Apr 2026 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097404; cv=none; b=M5xXbXkqbHwWmHUuS3dSx41Ly/yhPyI4qu8gjkal1u7ZxeyEgl+/ibg5XroRum0zXiwlHwl0Jhxg1CD5GkUSC1mwR9AcEheKKQYlszx0U3EczXcdjI+AKq8Ojlhc0T87M2kal29Exnp9dufeAO012jRTZuHZVc6evpg4tyuvJ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097404; c=relaxed/simple;
	bh=jJS7i6lFnN+EFnwXsAQhI1TBPPnwvbwbpB4f0RikSM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YV5hQdR0fDmN6JVuNnIzLdcorQtd/OFv744qjkjM/QUO5qyyPPBx7Vbj5JKwaRNKXx0YOuZiTshyXQsao6Vn5IP+dVu6mmTKhhCcdLL1Oyt0su9JRWsxyWmuj7+zMGyLx1E98gqipvOrQrVwCEq8b3FBHOtDzddUo2xzKBvF3Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0toVhfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0toVhfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4995C2BCAF;
	Mon, 13 Apr 2026 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097404;
	bh=jJS7i6lFnN+EFnwXsAQhI1TBPPnwvbwbpB4f0RikSM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0toVhflIeA0LPEjKCRadvKV7/HBtY4mUsGScpAXbZHpsvJst4zaESBehw7P0i8MW
	 urfzajPfmdlKRp2Gq6J2SlOyD7aTVjKZUmm0FxQ9x/QTvhyDpxyzKd/OHglGxtG802
	 AwffEaOqHLnZs+akA1ehBgV5QdvIKuqzGYALwekI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Mazek <pmazek@outlook.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/570] ACPI: PM: Save NVS memory on Lenovo G70-35
Date: Mon, 13 Apr 2026 17:53:42 +0200
Message-ID: <20260413155833.852879042@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Piotr Mazek <pmazek@outlook.com>

[ Upstream commit 023cd6d90f8aa2ef7b72d84be84a18e61ecebd64 ]

[821d6f0359b0614792ab8e2fb93b503e25a65079] prevented machines
produced later than 2012 from saving NVS region to accelerate S3.

Despite being made after 2012, Lenovo G70-35 still needs NVS memory
saving during S3. A quirk is introduced for this platform.

Signed-off-by: Piotr Mazek <pmazek@outlook.com>
[ rjw: Subject adjustment ]
Link: https://patch.msgid.link/GV2PPF3CD5B63CC2442EE3F76F8443EAD90D499A@GV2PPF3CD5B63CC.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sleep.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 95deb55fb9a8c..11e21be2ff31d 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -369,6 +369,14 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "80E1"),
 		},
 	},
+	{
+	.callback = init_nvs_save_s3,
+	.ident = "Lenovo G70-35",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "80Q5"),
+		},
+	},
 	/*
 	 * ThinkPad X1 Tablet(2016) cannot do suspend-to-idle using
 	 * the Low Power S0 Idle firmware interface (see
-- 
2.51.0



