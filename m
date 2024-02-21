Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5827EF1F;
	Wed, 21 Feb 2024 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524817; cv=none; b=OEWP0sT0bbRFBiOVGV4viqmDTruUl8i/oQiaQ0uMRRDRZhGTNlKyEy3WFPTmZU3VPHdtlJgHtAr7Ufhe0V5uNZjWi8l0YhHdpKy4pb4rDHeKIJ+3dtGJl9TGAmmZEKkR7xp4p+NlKkBAKz8EBy7uuB49/Azxv5RB5FpBWmhxrNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524817; c=relaxed/simple;
	bh=tFdjhN1HTSLKUWqHtPM+TzgyswL/prCKAaBjEI+kj7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IGaoB4FDRKFwtp/lhLN63fqPk8L2983a9hAJSZjTgoZZkqDqAbv8PbY32K0Ef+9MUV/D4X9E65cnz3NC0FLlkjpSuEJU+8+qdDfsYx5HOM2Vl4slqfSkGaUPjDuKU/uB234klx5koQOp14wB8FtRHxf+DgOHJDdh0I3Um5JRHuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0pjtA+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0pjtA+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9CDC433C7;
	Wed, 21 Feb 2024 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524817;
	bh=tFdjhN1HTSLKUWqHtPM+TzgyswL/prCKAaBjEI+kj7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0pjtA+peIgxp64lw0hmG8tLbpzaiAaU8rJZzItAwoZ3Ca9yZ4gvDffReBTyqtzjW
	 euT29aEjUiaMNzcmIS4zvoVajlQYztG4T+7q9rDtt90nr+Y315rGf3mP1dsilEZ29r
	 ST4/H3GA9scOr7eNeN8ldRVIgZ+hCW76xhDNy/kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/379] serial: Add rs485_supported to uart_port
Date: Wed, 21 Feb 2024 14:08:57 +0100
Message-ID: <20240221130005.649188296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 8925c31c1ac2f1e05da988581f2a70a2a8c4d638 ]

Preparing to move serial_rs485 struct sanitization into serial core,
each driver has to provide what fields/flags it supports. This
information is pointed into by rs485_supported.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220606100433.13793-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0c2a5f471ce5 ("serial: 8250_exar: Set missing rs485_supported flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 1 +
 include/linux/serial_core.h         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 43f2eed6df78..355ee338d752 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1026,6 +1026,7 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->port.throttle	= up->port.throttle;
 		uart->port.unthrottle	= up->port.unthrottle;
 		uart->port.rs485_config	= up->port.rs485_config;
+		uart->port.rs485_supported = up->port.rs485_supported;
 		uart->port.rs485	= up->port.rs485;
 		uart->rs485_start_tx	= up->rs485_start_tx;
 		uart->rs485_stop_tx	= up->rs485_stop_tx;
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 6df4c3356ae6..46a21984c0b2 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -254,6 +254,7 @@ struct uart_port {
 	struct attribute_group	*attr_group;		/* port specific attributes */
 	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */
 	struct serial_rs485     rs485;
+	const struct serial_rs485	*rs485_supported;	/* Supported mask for serial_rs485 */
 	struct gpio_desc	*rs485_term_gpio;	/* enable RS485 bus termination */
 	struct serial_iso7816   iso7816;
 	void			*private_data;		/* generic platform data pointer */
-- 
2.43.0



