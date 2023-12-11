Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D85251C38;
	Mon, 11 Dec 2023 18:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpV4/62V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A64C433C8;
	Mon, 11 Dec 2023 18:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320841;
	bh=/DYXyaYFoR3TWwM60afqrCIE4sQcQaDvpGtpbHtLP2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpV4/62VfR6JsQX7RPSNAKEcJlrYoCKm6TvM/wtah6PE05K7Y6d22Ov4P5lgDjaHT
	 /lHXwaOURgeK+RYQzXshoSzuiCNGdwfWFBVfRpi9ORGV1q0ZF61WiftbvM1fZe4Mgi
	 sVYTquxAVxD5VthZxizlZG2AuNpNGISyKdUyQ5rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis Belmonte <alexbelm48@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/141] platform/x86: wmi: Skip blocks with zero instances
Date: Mon, 11 Dec 2023 19:21:15 +0100
Message-ID: <20231211182027.212454118@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit cbf54f37600e874d82886aa3b2f471778cae01ce ]

Some machines like the HP Omen 17 ck2000nf contain WMI blocks
with zero instances, so any WMI driver which tries to handle the
associated WMI device will fail.
Skip such WMI blocks to avoid confusing any WMI drivers.

Reported-by: Alexis Belmonte <alexbelm48@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218188
Fixes: bff431e49ff5 ("ACPI: WMI: Add ACPI-WMI mapping driver")
Tested-by: Alexis Belmonte <alexbelm48@gmail.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20231129181654.5800-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index ce3380f09a472..7bb849aaa99e1 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -1213,6 +1213,11 @@ static int parse_wdg(struct device *wmi_bus_dev, struct acpi_device *device)
 		if (debug_dump_wdg)
 			wmi_dump_wdg(&gblock[i]);
 
+		if (!gblock[i].instance_count) {
+			dev_info(wmi_bus_dev, FW_INFO "%pUL has zero instances\n", &gblock[i].guid);
+			continue;
+		}
+
 		if (guid_already_parsed_for_legacy(device, &gblock[i].guid))
 			continue;
 
-- 
2.42.0



