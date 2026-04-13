Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783221A275;
	Mon, 13 Apr 2026 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098012; cv=none; b=ZvGi9e60jF5tOceW/9qP31oRAYyxf9KocJ7g2ic2AGYd9/inLoGctOv0bgZN/VBI+CtHOsiemdDmP2o+Ls3b5ztKR46CgPk4gQofccEwi9CZVRltfd4xZwet8vHGPsuWUxXXO//pDixQYWzbzWIRApVc359SPkznqknjbCjfDII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098012; c=relaxed/simple;
	bh=JOA3sEKpXlQsZG3Zq5M62TBX8XfQJc/r4FP9PBprpOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alPnKb62CZAkh9vzg/QKmNAYTnjvVuW5GoB5QPerZyGXzW7ZB2RpCURGmW8SoinzW6BwcnDFTEUo3v29QuKv1mclc4DXWK2vmvckwrJSkpnYdLpOgc6CUKJDl0LwLNzN9IZuSxAxpfTVSFBKpN/lqDABUH2ZHRTOfHAhQAp6WZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFLJn0DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFLJn0DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE801C2BCAF;
	Mon, 13 Apr 2026 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098012;
	bh=JOA3sEKpXlQsZG3Zq5M62TBX8XfQJc/r4FP9PBprpOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFLJn0DS01fpUP7U8wLe9WGOzKnDnnSI5a5+vgK/mBnr4X7a9KTJFwAKwX84DBXJB
	 Le1Bi3X7wyXTL88yP5YvlunQXWKumdJvsFgZHCQ74UeIxvsOYfTukWTWK4giAPJFDY
	 sgEMDUsxHoas0ZPsOkySIwnpBcWNBUvI5o2vfBss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/570] ACPI: EC: Fix EC address space handler unregistration
Date: Mon, 13 Apr 2026 17:58:10 +0200
Message-ID: <20260413155843.930897141@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a5072078dbfaa9d70130805766dfa34bbb7bf2a7 ]

When an ECDT table is present the EC address space handler gets registered
on the root node. So to unregister it properly the unregister call also
must be done on the root node.

Store the ACPI handle used for the acpi_install_address_space_handler()
call and use te same handle for the acpi_remove_address_space_handler()
call.

Reported-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f6484cadbcaf ("ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c       | 4 +++-
 drivers/acpi/internal.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index ddc5b3a3d9b38..4d38a00dbf50a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1513,6 +1513,7 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device)
 			return -ENODEV;
 		}
 		set_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags);
+		ec->address_space_handler_holder = ec->handle;
 	}
 
 	if (!device)
@@ -1564,7 +1565,8 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device)
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
 	if (test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
-		if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
+		if (ACPI_FAILURE(acpi_remove_address_space_handler(
+					ec->address_space_handler_holder,
 					ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
 			pr_err("failed to remove space handler\n");
 		clear_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags);
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 54b2be94d23dc..33cf3f38f8530 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -168,6 +168,7 @@ static inline void acpi_early_processor_osc(void) {}
    -------------------------------------------------------------------------- */
 struct acpi_ec {
 	acpi_handle handle;
+	acpi_handle address_space_handler_holder;
 	int gpe;
 	int irq;
 	unsigned long command_addr;
-- 
2.53.0



