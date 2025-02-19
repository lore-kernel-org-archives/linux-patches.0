Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274BD1E22FA;
	Wed, 19 Feb 2025 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955692; cv=none; b=F0/fWdAVi7ys+eHu2yGHMWYuItcUQZ+08htzxBNJmG0h0BbEyGEKg7LsOg6ZqlsrwRd0syFa6MgtNhCaPUomTyIB6pkfarV1eQnfCGfFZMZkUORCJ3olNu2FSE6ZSIFazGxVDIpsexfMG4QowhYn3vB4q5PuwSXqezLaraywD+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955692; c=relaxed/simple;
	bh=muns2If083iHFzvBqnjB1MiDyWFwGMcDF87qweNP89w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c56QH/jgC/80rjXFwwt4QiRQp6kcpJo9IJ3LZCnnZlod89oabz+Pqxqbp+KdCMpO9+upFLeX8ivEgGvI5XHUnM4gh2hX/dZhCFKDYWFgC/PIEEDDxgqF1Ksyh2ovVcVxtBHzrnNlBffP/I6ndi09uoH3Ys9+z98ADVBqDd9hcMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O65PswGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O65PswGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF59C4CED1;
	Wed, 19 Feb 2025 09:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955691;
	bh=muns2If083iHFzvBqnjB1MiDyWFwGMcDF87qweNP89w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O65PswGhzT0xGqQNfvQEbI/wABiJcHwcN87vOiLX+XTtRyjW/mTFvL9rmiVESKMOl
	 6nN509JxNIpeGnYa70rYSbFhW16KXdFeIYXN1EcgGlIHSRhNZW0YTidgkZDVbfkoJM
	 asqThlKDauBbxaKvoPYFkiytdSXlTXAVpDzJ7bhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 084/152] serial: port: Always update ->iotype in __uart_read_properties()
Date: Wed, 19 Feb 2025 09:28:17 +0100
Message-ID: <20250219082553.375978794@linuxfoundation.org>
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
@@ -227,11 +227,11 @@ static int __uart_read_properties(struct
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


