Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27CE30C60F;
	Sat, 12 Sep 2026 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229858; cv=none; b=ucjgizPMbvK4vB8bjvcTkNoE4vIAJu1j+p/iizQbiheMU5QfoPMED37x7/jWRm1xWZXoROk5H5x92t9+HLHh543FJ7DoOJAzEl2tWF62PmqzXx0eqQLmmF1AvXs1DsiCt0WN3IAISycDqUfcgQ05aUPwWxDYBAmLFLFZDxwtvPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229858; c=relaxed/simple;
	bh=l5QuSA5Dll/Dmbhy2DesAXhkqfS+Xccim6Ua1RegJuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gI66d6AtijtzoUTJSl11itJFS5kmIL3Rz24UnAYlxlPETDoCQ38pqa9lMCI2lHomO25sUUsVLSFsWwRm6pDwxvY0D1NsrxPxRnnJ+Eb4qGdtZJcF/ym6QsIvzDfRcIj1nTyiRLZ2/SdQ4y7UBSce+B7knEAOSZgy5BoTLAfKHmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6+WO3xV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6+WO3xV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD381F0089C;
	Sat, 12 Sep 2026 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229855;
	bh=viTMpdbxIX+wb91q4eh0b5gHdIvRix69aHhlq/YgjWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6+WO3xVg21U7mz11GxSuzUaGqaYgtq6bMdmVeN/ybl26fuX5Po0EBZqk+Y6Y/ty0
	 xszzh6WqQ+CzBX4E7ISTuX4LNDSyfAbzTojUrvdwl/eBQHuGoG2eO3+q9oNlHwjqHY
	 UyR+XdTLA2exCeIa/seJb8/NjM314DJVNL2UTPGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ling <zhuling2709@phytium.com.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0674/1191] ACPI: EC: Avoid _REG disconnect on GPIO IRQ defer
Date: Sat, 12 Sep 2026 08:56:42 +0200
Message-ID: <20260912065603.396604465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Ling <zhuling2709@phytium.com.cn>

[ Upstream commit e71bdbce27dcaa7f467a3a198cbe723924f05569 ]

EC event delivery uses either a GPE or, on ACPI reduced hardware
platforms, a GpioInt resource.  The GPE path does not have a provider
lookup that can defer, but acpi_dev_gpio_irq_get() can return
-EPROBE_DEFER for the GpioInt path.

ec_install_handlers() currently installs the EC address space handler and
executes _REG before looking up the GPIO IRQ.  If the GPIO lookup then
defers, acpi_ec_setup() tears the handlers down again.  Removing the EC
address space handler causes ACPICA to execute _REG for disconnect, so
firmware may observe an EC OpRegion connected -> disconnected transition
during one failed probe attempt.

This is observable when the namespace EC reuses a boot EC that has already
installed the EC address space handler.  A deferred namespace EC probe can
disconnect the already usable boot EC OpRegion until a later reprobe
connects it again.  AML that gates EC field accesses on _REG state can
then return fallback values to other drivers during that window.

Prepare the GPIOInt IRQ before publishing EC OpRegion availability to AML.
This leaves the GPE path unchanged, keeps non-deferred GPIO lookup errors
non-fatal as before, and still lets the existing acpi_ec_setup() error
path clean up real handler installation failures.

Fixes: f6484cadbcaf ("ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()")
Signed-off-by: Zhu Ling <zhuling2709@phytium.com.cn>
[ rjw: Added an empty code line after a conditional ]
Link: https://patch.msgid.link/20260715012556.12043-1-zhuling2709@phytium.com.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index d00fd26c274f2..f25fe2b073e3d 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1492,6 +1492,24 @@ static bool install_gpio_irq_event_handler(struct acpi_ec *ec)
 			   "ACPI EC", ec) >= 0;
 }
 
+static int ec_prepare_gpio_irq(struct acpi_ec *ec, struct acpi_device *device)
+{
+	int irq;
+
+	if (!device || ec->gpe >= 0 || ec->irq >= 0)
+		return 0;
+
+	/* ACPI reduced hardware platforms use a GpioInt from _CRS. */
+	irq = acpi_dev_gpio_irq_get(device, 0);
+	if (irq == -EPROBE_DEFER)
+		return irq;
+
+	if (irq >= 0)
+		ec->irq = irq;
+
+	return 0;
+}
+
 /**
  * ec_install_handlers - Install service callbacks and register query methods.
  * @ec: Target EC.
@@ -1506,7 +1524,6 @@ static bool install_gpio_irq_event_handler(struct acpi_ec *ec)
  * Return:
  * -ENODEV if the address space handler cannot be installed, which means
  *  "unable to handle transactions",
- * -EPROBE_DEFER if GPIO IRQ acquisition needs to be deferred,
  * or 0 (success) otherwise.
  */
 static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device,
@@ -1539,19 +1556,6 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device,
 	if (!device)
 		return 0;
 
-	if (ec->gpe < 0) {
-		/* ACPI reduced hardware platforms use a GpioInt from _CRS. */
-		int irq = acpi_dev_gpio_irq_get(device, 0);
-		/*
-		 * Bail out right away for deferred probing or complete the
-		 * initialization regardless of any other errors.
-		 */
-		if (irq == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		else if (irq >= 0)
-			ec->irq = irq;
-	}
-
 	if (!test_bit(EC_FLAGS_QUERY_METHODS_INSTALLED, &ec->flags)) {
 		/* Find and register all query methods */
 		acpi_walk_namespace(ACPI_TYPE_METHOD, ec->handle, 1,
@@ -1629,6 +1633,14 @@ static int acpi_ec_setup(struct acpi_ec *ec, struct acpi_device *device, bool ca
 {
 	int ret;
 
+	/*
+	 * GPIO IRQ lookup can defer.  Do it before publishing the EC
+	 * OpRegion to AML to avoid a spurious _REG(disconnect).
+	 */
+	ret = ec_prepare_gpio_irq(ec, device);
+	if (ret)
+		return ret;
+
 	/* First EC capable of handling transactions */
 	if (!first_ec)
 		first_ec = ec;
-- 
2.53.0



