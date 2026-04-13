Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EF9307AC7;
	Mon, 13 Apr 2026 16:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098699; cv=none; b=JBtCWowXMLXSohF3UFq+LZN6ujGIEvJZo8pF7dkdENbz0iIInnhfuzqTMrR3Me2c0jWWhlCfWgAqyVbM6a+8EOo00sIVG7RPO+dwIk8wCjwRIdY2YqKFy20rfxusztxAOe7e91o/m4c6S8HcEYxxe/W8QB+DZhpObYyJUfzdX1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098699; c=relaxed/simple;
	bh=KfQKxqwlE9DEZcSCTt6VdBuiiajmGfTyCQXIQl/lbD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffb71DGgEHGJiyPWlPzd0NNjxdIQNuPah9ySzQiVQGaXp2LNrHEbN5oG5LT3Mq4vYAiZcIubrLq0uudyISa+PdjK2bj/NDuN1Wmh25jB/TpXoDajEN62ZfPn+ZF5lDCEvZy9bKpXubAiOiGSB0lvmLisVNVpQiqyberRTlkxWYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHYPsoS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHYPsoS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEDBC2BCAF;
	Mon, 13 Apr 2026 16:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098699;
	bh=KfQKxqwlE9DEZcSCTt6VdBuiiajmGfTyCQXIQl/lbD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHYPsoS5Huv1hx7s3omiiJ2gsMOx7NvRDfvS74IDX8LHKvblIm+/AItfksor41J6w
	 f345yYmdfRP0ab4EWVAShzavJBUN+zQLt2fpacurxVfLXLTLE5esL8RK5GAhsEr+lw
	 Mrvyszw+05gRVXiY1BXSt4++51yLiBX3dYoBC+Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Mazek <pmazek@outlook.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/491] ACPI: PM: Save NVS memory on Lenovo G70-35
Date: Mon, 13 Apr 2026 17:54:59 +0200
Message-ID: <20260413155821.073845887@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e79c004ca0b24..df03b6ed16fbb 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -372,6 +372,14 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
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



