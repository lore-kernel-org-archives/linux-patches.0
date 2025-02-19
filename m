Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C567B1E130F;
	Wed, 19 Feb 2025 09:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955688; cv=none; b=R7qjBRuJBjygiL5T4njiEJEUt971pCd5YpmlE5Kktxfb3yrfTaMrMdz0OpoyPd8Jaowuf328ww0wzarBER/Q0KCZ4Obg5G6fJ1JeG3cYR+louylJP4dNWqwXdYVSZaARwugGWfOM9Udy4Q0u0QqJz6EqNxbb8HEKCxMjPF4EwGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955688; c=relaxed/simple;
	bh=sQAf/mghGp/p2CV6kXZtt2j+W8XOmF27S+0gJYlimQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAxSLBI+zVPDmCm0F6mUnMXRcFQoVicBF54QiZAlZLHUfKl3fK0kjKPXQeioFUeZjiMDTEvGJxQsgnJA2gsT0/0SYvptFtzv1jpc+YOdWgTWAt2V61m1jm0WLG76gPOhhyUNrrEoXfpQboaE38+qet3eqEOqPU4BVftskgItw2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COsPWJZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COsPWJZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45130C4CED1;
	Wed, 19 Feb 2025 09:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955688;
	bh=sQAf/mghGp/p2CV6kXZtt2j+W8XOmF27S+0gJYlimQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COsPWJZ3yDWJpZXmvPzbh6eSKgJaMyHSi5YSM+qJv+JTlk0vltSQWFxkFrp5Hfekl
	 T9VzRMhBGw3Ponsz+bRZULOmLO8PKFk8subA1JEEldKTFNnXOHHZmqvZJQqmhB7tQg
	 rUF1yjAFhXHKFLSEbaQNBkR0H6fQKi4H/dsdzoPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 083/152] serial: port: Assign ->iotype correctly when ->iobase is set
Date: Wed, 19 Feb 2025 09:28:16 +0100
Message-ID: <20250219082553.334301625@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 166ac2bba167d575e7146beaa66093bc7c072f43 upstream.

Currently the ->iotype is always assigned to the UPIO_MEM when
the respective property is not found. However, this will not
support the cases when user wants to have UPIO_PORT to be set
or preserved.  Support this scenario by checking ->iobase value
and default the ->iotype respectively.

Fixes: 1117a6fdc7c1 ("serial: 8250_of: Switch to use uart_read_port_properties()")
Fixes: e894b6005dce ("serial: port: Introduce a common helper to read properties")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250124161530.398361-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_port.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -172,6 +172,7 @@ EXPORT_SYMBOL(uart_remove_one_port);
  * The caller is responsible to initialize the following fields of the @port
  *   ->dev (must be valid)
  *   ->flags
+ *   ->iobase
  *   ->mapbase
  *   ->mapsize
  *   ->regshift (if @use_defaults is false)
@@ -213,7 +214,7 @@ static int __uart_read_properties(struct
 	/* Read the registers I/O access type (default: MMIO 8-bit) */
 	ret = device_property_read_u32(dev, "reg-io-width", &value);
 	if (ret) {
-		port->iotype = UPIO_MEM;
+		port->iotype = port->iobase ? UPIO_PORT : UPIO_MEM;
 	} else {
 		switch (value) {
 		case 1:


