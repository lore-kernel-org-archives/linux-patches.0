Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216785;
	b=ybsxVjuo3ZNYhUuRI2SNj87jPieJgudSawCaJLoQL7rs/mryJ4zIbIoPkTJABxtVCCJ+
	 2SAm9OWBCkcmgN094j7+gmDTgw+ZRkMwt/f3/aNPW42wVWFa9mpKThTzeeEXIVBEnb0QK
	 GkwdQKEhvK+Vzgvx0p8TP5jA6qcXGvf4Y2L9LdsAeY1NwfcG32vZpFs1VufetVHD6HjMp
	 g/6AKpKLaXSxoUFrQXVBFLKoscnpVLgj82Vm5UTcbg1fE8wbSCoymdVWfRsY1b9JhmrKX
	 RPOXxgLy7h5iDnUK8+M0njB60f6KhaRW6Ze4ra8/mBlD6HB+dZ1bBO72t64SPcblx4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QhW3TqWPvQthN6yDIj54MQsTwG4p20Euk7Cqmm7eH2Q=;
	b=sU62M9lIclg5rTt8Rq0xaCe9z+9As0zdKRKgxOOcoH2SvsdSCh4kuB8ZRwnTA8xjmu76
	 DcJXTG6g64dGdaTXgLpcrYVSq+YiKZDwLyqyVEK0rxPT1i0sgx0o7qP8BIyELT4wFZZmg
	 wXZlzWstlNIP5mzo8LFbSZpuIv8TizJ2Fq+nDLKkVsbjI021An6exEInUNpTyGhho/EgQ
	 /7M0QSu11/rKgRf5lTPc+GxU2lAJGpfhDfRDrAyHd/qm7r6WKkCB23yHkaOlccZccDQ7s
	 PlZc8zMEn5Q3FPDEywB1dqLE24x1pVKO4GXKYIy/gQXVgu7PpQkYSBp7oh3kWqYuIVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObVC377Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCA0606A31A;
	Wed, 28 Oct 2026 19:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObVC377Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95241F01825;
	Wed, 28 Oct 2026 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216785;
	bh=QhW3TqWPvQthN6yDIj54MQsTwG4p20Euk7Cqmm7eH2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObVC377ZtlliashP0/rGCl00T95SXYLEDVkbVcwRHSLstBt/tMox3MyMl3ViiMHU7
	 pMSmHjqoicpoLvlY3B/M06fXkpYJxb+b0ElS10JGp1pxosXgdCc+vUK8SWHWVYMqMA
	 QAjL49920tweaKEqqgx+fqdGkFw8PPEaGBMYc650=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1677/1887] tty: serial: 8250: protect against NULL uart->port.dev in register
Date: Wed, 28 Oct 2026 18:02:53 +0100
Message-ID: <20261028170537.621710701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 81a5dab1a8286..6ba421d97d30f 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1038,7 +1038,7 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 		 * Only call mctrl_gpio_init(), if the device has no ACPI
 		 * companion device
 		 */
-		if (!has_acpi_companion(uart->port.dev)) {
+		if (uart->port.dev && !has_acpi_companion(uart->port.dev)) {
 			gpios = mctrl_gpio_init(&uart->port, 0);
 			if (IS_ERR(gpios)) {
 				ret = PTR_ERR(gpios);
-- 
2.53.0



