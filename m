Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CF63ADBA4;
	Sat, 17 Oct 2026 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255346; cv=none; b=s5XgCV1P0pW6mdW+SI6AMgk/sm094/SAfCZvfymPlbvqHxGGDzXm8L59XLCkOJGJGpEEvgxTw5OTXt0jftv45155YUuQhfaJOeJfvvKQH6I2zc5XUPBIVwbxAENzmnMOASsCjkNv7su2H4qN9rrwK+mXtfSl6rZBcd/oE6qlS6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255346; c=relaxed/simple;
	bh=YNHhclPAvAY4kF0PRUIgmN1QyUXZNPTqecKPnNITMVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CicDWCH9qLAek2JFDmiI6tMfWv1+FxItyjMZutJEDJMI96JCUc4F8ByuO+wyG+G2QBWqaBSF1qiSLZjltZPU0bT4MB91ZDH44GACT3yjjx+JrNGgb21C2PVBLr5fjuTT1CrnrAW1GcwxMwBydZ2pedtB35541+tmQVqLfff29Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZPJmXCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZPJmXCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727AB1F000C4;
	Sat, 17 Oct 2026 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255345;
	bh=7gK9erOlhPzzX7dqoL3EJTPC25zx50bTKsMDfD6uVBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZPJmXCfEDTTHoFt2O9oxBZ0Neu81wlXMYceZ+cZwNkgPYyEu9yb0EPSHv1uRBBMv
	 PKeu9vE7RWTmzdwEYr90KPNJQMlznrxtwni8kN+EpabTgVTnFOXBJ3R6fYLW8IYI9g
	 ffGIfNwL+RqBCiV9W0YsPW003FwtIlamZmPtynhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 743/869] tty: serial: 8250: protect against NULL uart->port.dev in register
Date: Sat, 17 Oct 2026 17:59:44 +0200
Message-ID: <20261017160055.989833550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 941c9f84c9b6310f7aaa1c8c785dcc634ee33050 ]

serial8250_register_8250_port() conditionally copies uart->port.dev
from up->port.dev only when up->port.dev is non-NULL:

	if (up->port.dev) {
		uart->port.dev = up->port.dev;
		...
	}

So if both the existing uart slot and up have a NULL ->dev,
uart->port.dev remains NULL. The very next ACPI companion check
then dereferences it unconditionally:

	if (!has_acpi_companion(uart->port.dev)) {

has_acpi_companion() reads dev->fwnode without a NULL guard
(include/linux/acpi.h), so this NULL-derefs the kernel for the
remaining no-dev case rather than just skipping the
mctrl_gpio_init() initialisation as intended.

smatch flags the inconsistency:

  drivers/tty/serial/8250/8250_core.c:767
  serial8250_register_8250_port() error: 'uart->port.dev' could be
  null (see line 719)

Guard the call with a NULL check so register continues to work
for callers that legitimately have no parent device (legacy
non-OF/non-ACPI registrations).

No functional change for callers that pass a non-NULL ->dev.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260508181237.11146-1-sozdayvek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index d7034f305c7b2..f35a060a73a74 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -768,7 +768,7 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 	 * Only call mctrl_gpio_init(), if the device has no ACPI
 	 * companion device
 	 */
-	if (!has_acpi_companion(uart->port.dev)) {
+	if (uart->port.dev && !has_acpi_companion(uart->port.dev)) {
 		struct mctrl_gpios *gpios = mctrl_gpio_init(&uart->port, 0);
 		if (IS_ERR(gpios)) {
 			ret = PTR_ERR(gpios);
-- 
2.53.0



