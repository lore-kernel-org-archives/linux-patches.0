Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0870397928;
	Thu, 17 Sep 2026 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663905; cv=none; b=iznMY/BQY8i2cX8jXdMma3seyZaTgc8ylMvm39tvNb2KstzCgrIE9BNgbJ9XV24fEGww13HC65IK3bRaVJ4ylqyh0JSzeMUcyQDp0LXu2TOTQg/Mb4IP3TEba7ALmWciCmYgzoHsDmQZJuXm34zCL5xca4EZPBnXuvPu+dONgoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663905; c=relaxed/simple;
	bh=lQdszUdPUXd84tiIq7xMO9aFHZlkn9yMF3mc7QC+zSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7FL1hJFpUqxor2+pebi6Fvxh9xs9fRLp4apgQEeAlRRvkW/DsYBu/1W+vLOIcb1yND1MQvBtawCHgzWbHiHEeaL0cNza0Uj97YdEB/x++uZkzqUqBugpCEAizlGuGJKJSzZEzYlt7PMYhQWHaww87dNgPlfVEGFDCDVxQ+HIds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVeQk69H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVeQk69H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392E71F000FF;
	Thu, 17 Sep 2026 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663903;
	bh=Ktcxlpkfam7Z+WW/A1hJGs/j3//irdZQij0CVsEWm6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVeQk69Hq1rgLRkfjDlKI8gF3Zt6wEgHg3ypuKAbasTuRBKxkxXEh9m+TxyvMoU3h
	 h9b8GCI6lbEF/HYQf30xb4CXKd8GJcmAv5hkQCxELwJL6IN0jhytMMN8c8y0MqXFXM
	 Twiw50Sn6sS9PtSXb3cJmCXt8mngWbBxz8FdaJto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0193/1250] tty: serial: 8250: protect against NULL uart->port.dev in register
Date: Thu, 17 Sep 2026 15:59:48 +0100
Message-ID: <20260917151557.347442208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ccd5a18f53356..e8363c8e0f612 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -766,7 +766,7 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
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



