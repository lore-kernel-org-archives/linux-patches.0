Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6292E24C060;
	Mon, 23 Jun 2025 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685242; cv=none; b=VAOh439Tptj0QwptoH8VsriTSIEoG7K8nEK2OayZYNnEp7nu6VwGeY9wmEZ8kxzxLjZXJmvbNTE2sBHgWXVvZk6Co/o/xLTl16OT6sf2lU9NhFBRn6jfVaQxxJV2SjleSMXTXPzXlSy7F3z2XBV3D2TFwuVjnmoZVS7XOiUez90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685242; c=relaxed/simple;
	bh=lRgo5hYMJsaoPNHbuuq3MqXMMyNm7QbNzsUcTUsyeZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZAAc/j10Io7QKn8VsbWAHB8Q+uNLnUnInLigQTtww+o9y5mSpdPjMDjYBKxm/elyggE5yH4CzwEJT1dKTW/nAfBclmk5ahnzWwBtdn6Q7Hl3Eji3Yd4YzUn1PSIM+042xy4flyfHGhs2tIrs2QB17WSdBssoW14NPHOIYBkG/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNDyDkG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNDyDkG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BB8C4CEF1;
	Mon, 23 Jun 2025 13:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685241;
	bh=lRgo5hYMJsaoPNHbuuq3MqXMMyNm7QbNzsUcTUsyeZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNDyDkG0V0Oetz2QSgjeEJMWwj4dE/vC4EfUZkMkJYGxo3J+v2/7Pm2CRGjkc4wCb
	 4ZKplatnD6WJeX52N2v2sneJ/Mxvxju2bKeCvMYpQdGpmN8P3c90r0t4dCz4O/6iKc
	 sisA+SjPOx9NOwLtegIdmTp+wEAIuEFVMMifDhaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 217/592] ACPI: bus: Bail out if acpi_kobj registration fails
Date: Mon, 23 Jun 2025 15:02:55 +0200
Message-ID: <20250623130705.447486196@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 94a370fc8def6038dbc02199db9584b0b3690f1a ]

The ACPI sysfs code will fail to initialize if acpi_kobj is NULL,
together with some ACPI drivers.

Follow the other firmware subsystems and bail out if the kobject
cannot be registered.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20250518185111.3560-2-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 058910af82bca..c2ab2783303f2 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1446,8 +1446,10 @@ static int __init acpi_init(void)
 	}
 
 	acpi_kobj = kobject_create_and_add("acpi", firmware_kobj);
-	if (!acpi_kobj)
-		pr_debug("%s: kset create error\n", __func__);
+	if (!acpi_kobj) {
+		pr_err("Failed to register kobject\n");
+		return -ENOMEM;
+	}
 
 	init_prmt();
 	acpi_init_pcc();
-- 
2.39.5



