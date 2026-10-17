Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5A5356A12;
	Sat, 17 Oct 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260417; cv=none; b=o67g6j8WBwwm9fe5ixiqAZduQKmrOv/613yGSiRK5Uz6OWU74LNX9npthLlKKdGDnF1kMECCuoYjB6aggMOkc2jkEYUwwXNzDsp1Jw2k3J+rYGh+uc+n8LaZ41oFDhCmrtJyW0NUnGn7ClSfcSC1PmIk23RJC6d6MqehAcdaC2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260417; c=relaxed/simple;
	bh=fLfjZ0MuwBs3hBMQ9Re4HNVAXgYnzpB1fECRajPSh+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpK0P6K5MXB2Y0MIoHG5c7+oasutkp7L1mA2H15zHdnFtbrT8PRWN7T/xqKKNlHVjA3vLyqbsSamEGpFNq+JEuPYOzKmT2qyZSh+h7FaipP1tuvvb5WDvB/3IwDsMwMW0UrLreynsaUVwKwZgWEhEidWnTmykYNYHYPHEiSTNUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7o8/4Dk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7o8/4Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E601F000C4;
	Sat, 17 Oct 2026 18:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260416;
	bh=tbSarxvH3w2iUS38QfBskDoSw8FwHukQqENYh3amWt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7o8/4DktRl2WmtWiWpX8BH8qGKW03QT4l9Ka149P97nMn9cypuZnuCBlRe4y/pz5
	 HG7Hy3CM3a3ZHTemHCZrapd0+GfJIPr/OcpzzG8s+e91KMlNaK7jd1YpkD74UdUKFP
	 b7f0+ESx7EezlK1UTsa4BIfKy8XO/CX5b1JXPsw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1536/1674] tty: serial: 8250: protect against NULL uart->port.dev in register
Date: Sat, 17 Oct 2026 18:03:28 +0200
Message-ID: <20261017160510.542121594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b7fe3056b57fd..cc28943254b3d 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1087,7 +1087,7 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
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



