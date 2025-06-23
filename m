Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78B81E3DCD;
	Mon, 23 Jun 2025 22:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717202; cv=none; b=hJTy5hYhpd3GcNiEShTXfSN8auswpmH2dpvH8Q5vkRsLpf5QsGVGc1YkyGsxJ3WQRlaFQOTnZRtM+VhefRj6W858eM+GgKrHExVgnezpTiKue8/OSDLBe0VW5l1NevUBClC0BdcCRuo2aOMhoAZAXXsppPH81X9UcaxoEBZ5Qnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717202; c=relaxed/simple;
	bh=LitO0OxKGtlSkjSXkxY5mnyyGX7Ypgkfr90+7s9JI/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbFvJzy7G4GKbsALApdtKJ/CII2XHlsNtwSHBZuuhuZTz9dx3OzBIJLHYz0hK+xyNEpeZGa+Y6RrW06Pmka6ItU07SS8JTqxyXEgA3QSGM0TMhz0srQESX7IgZlnjuJ12B42MtDEYdQdAz+xM+fhOmI9Pv4oCPOGDDT/3aBA16c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8lBP+CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8lBP+CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1167C4CEED;
	Mon, 23 Jun 2025 22:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717202;
	bh=LitO0OxKGtlSkjSXkxY5mnyyGX7Ypgkfr90+7s9JI/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8lBP+CBDas9T6ws5WZb7s6EYEUfJPNz7CB462LgMfSV1cSzuMBlFCZcIVa2uO5kD
	 a8kKCymgVBD0yjfIVBCPlNntN057a7dllunEXZ+Zx6G7sojVQmSLuABqKim1TYGcZf
	 qSH9nqruMTl12N+oS9vGscKv5SYct6BWakqV2MOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 380/508] ACPI: bus: Bail out if acpi_kobj registration fails
Date: Mon, 23 Jun 2025 15:07:05 +0200
Message-ID: <20250623130654.659919095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a16b7de73d164..fafa15507b141 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1389,8 +1389,10 @@ static int __init acpi_init(void)
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



