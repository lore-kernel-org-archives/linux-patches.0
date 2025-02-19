Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016A11C548C;
	Wed, 19 Feb 2025 08:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955136; cv=none; b=n2PhDu7eNq9wQ2AGjvcJ05x056GhIv1/FX2cKnGjD0rq18CygENWxCIZmkqvBiwXTOUSVXKaM9hwaj1eVTIIO7BgFyF1KQRc3Nybmy9EIRovii5B6v2tb7RyOAOaTRY2KVyZPAlKsCVu2e2Y2rDlSIaHgn707lJITl4d/OFx6MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955136; c=relaxed/simple;
	bh=NhnjVWrCz/sGCy99vgY8AObCm0YwG4DAk3m/oN/emmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz/PBIq+XSKdQb838mSfjO+nc4OYySo/OEjhP86td8MHLvQv8BQuWaNpMdrtbkfgHNEQPYLq87NZ9XBA/Q5I3crhGDHv+QhioOr4HPrrA2kkZzdTiedaddJYm3eJ7M97MsDXuBW2HueOMXJrqQFIWlXGtCbUTh4lU1Ui264sIvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW7dnNe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW7dnNe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731B6C4CEE6;
	Wed, 19 Feb 2025 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955135;
	bh=NhnjVWrCz/sGCy99vgY8AObCm0YwG4DAk3m/oN/emmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wW7dnNe2SeBDttGXpVtU70znHW6CdDgPeJPegSLenDdWmPhoOMkE6Zt9OKwEo1joJ
	 8jqJB/m4aq9EigDhswm49mDxd4BjfuCqvQdFrR4UgrFh4vbkK8GlIMST0xTVpS3e7W
	 cS7OoKeS0Zub0fTEPe8uk0q3Q02N/QGDzHJPGAxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.12 144/230] serial: port: Always update ->iotype in __uart_read_properties()
Date: Wed, 19 Feb 2025 09:27:41 +0100
Message-ID: <20250219082607.321615126@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e8486bd50ecf63c9a1e25271f258a8d959f2672f upstream.

The documentation of the __uart_read_properties() states that
->iotype member is always altered after the function call, but
the code doesn't do that in the case when use_defaults == false
and the value of reg-io-width is unsupported. Make sure the code
follows the documentation.

Note, the current users of the uart_read_and_validate_port_properties()
will fail and the change doesn't affect their behaviour, neither
users of uart_read_port_properties() will be affected since the
alteration happens there even in the current code flow.

Fixes: e894b6005dce ("serial: port: Introduce a common helper to read properties")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250124161530.398361-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -228,11 +228,11 @@ static int __uart_read_properties(struct
 			port->iotype = device_is_big_endian(dev) ? UPIO_MEM32BE : UPIO_MEM32;
 			break;
 		default:
+			port->iotype = UPIO_UNKNOWN;
 			if (!use_defaults) {
 				dev_err(dev, "Unsupported reg-io-width (%u)\n", value);
 				return -EINVAL;
 			}
-			port->iotype = UPIO_UNKNOWN;
 			break;
 		}
 	}


