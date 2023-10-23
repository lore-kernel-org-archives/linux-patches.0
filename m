Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595EB1C35
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 10:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiIaJA43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD6AC433C8;
	Mon, 23 Oct 2023 10:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058768;
	bh=X6QHhf6Nm4pP+AA0hX30l9DDhIRblW5fETDOWdhbp34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiIaJA43KcIrewZMlT7gI5X21R7RhSHTeNDwF2rGu1PE/DX/6ac+zrA40FVT9JYqe
	 E2MI/hfinJYCk/l+1WlCR33hnYxgBDK0r+mAm1GQfPVvQv7kF0EvQVVaLU2tVflGXl
	 CiWdcOlAAJ4SawPTXweXM+2AnN0aO9qWwsvxeJ7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/66] platform/x86: hp-wmi:: Mark driver struct with __refdata to prevent section mismatch warning
Date: Mon, 23 Oct 2023 12:55:52 +0200
Message-ID: <20231023104810.872267789@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 5b44abbc39ca15df80d0da4756078c98c831090f ]

As described in the added code comment, a reference to .exit.text is ok
for drivers registered via module_platform_driver_probe(). Make this
explicit to prevent a section mismatch warning:

	WARNING: modpost: drivers/platform/x86/hp/hp-wmi: section mismatch in reference: hp_wmi_driver+0x8 (section: .data) -> hp_wmi_bios_remove (section: .exit.text)

Fixes: c165b80cfecc ("hp-wmi: fix handling of platform device")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231004111624.2667753-1-u.kleine-koenig@pengutronix.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -1001,7 +1001,13 @@ static const struct dev_pm_ops hp_wmi_pm
 	.restore  = hp_wmi_resume_handler,
 };
 
-static struct platform_driver hp_wmi_driver = {
+/*
+ * hp_wmi_bios_remove() lives in .exit.text. For drivers registered via
+ * module_platform_driver_probe() this is ok because they cannot get unbound at
+ * runtime. So mark the driver struct with __refdata to prevent modpost
+ * triggering a section mismatch warning.
+ */
+static struct platform_driver hp_wmi_driver __refdata = {
 	.driver = {
 		.name = "hp-wmi",
 		.pm = &hp_wmi_pm_ops,


