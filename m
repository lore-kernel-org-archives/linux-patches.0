Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573CB1DE2D8;
	Wed, 19 Feb 2025 08:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954315; cv=none; b=jnW5Xcx3Lfk0cLlVygQS4ixH84cTMYAffYBvjr17dM5G8+tK35mXX2NQy2Y7Uh1JWDvQjQCxv71Oveqsxyy6vcTIfWVRWXxHL3p9SdOssdbPxc/lzSmYWMdARNoTGD1DQPtNZh17MuZEFdzrTOfCmGdwqo5E3KHmN/L23apK9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954315; c=relaxed/simple;
	bh=QTJsXJdcXcI0AFsOuM41yeGQWVVidgWWP7bGAIJmOK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooJQcRYt268bH90EUfpm33wzl4jxAIu7wyCY11yIsjc8a2lz0vb4YvDWQW/b1b9Z203BVJpLoujrEu1mcwMp9C31cI7A5/M1kfWMT3dO97Fk19aOWeifxh1LJsgWBmZu3Exq6y6yHOO5LicBHIWQba7Dpv9N6j3GAio2MJS30jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGIyTNKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGIyTNKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F2DC4CEE6;
	Wed, 19 Feb 2025 08:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954315;
	bh=QTJsXJdcXcI0AFsOuM41yeGQWVVidgWWP7bGAIJmOK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGIyTNKozz+qvLgVrpvEN/zrNiHzl4zir2ti69QKYBWgT9QQGCFvXFcmFZc+NvD2f
	 bOqC6pOOBTBVq1YG/luZdei0deyqQTRcmLT6Vdds+phaUFEz33boIdiDTPyGs00mRG
	 iHrdTgxuvZzVpn45klMkJm4LzvQVZRorb3dTuuEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.13 165/274] serial: port: Assign ->iotype correctly when ->iobase is set
Date: Wed, 19 Feb 2025 09:26:59 +0100
Message-ID: <20250219082616.052648145@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -173,6 +173,7 @@ EXPORT_SYMBOL(uart_remove_one_port);
  * The caller is responsible to initialize the following fields of the @port
  *   ->dev (must be valid)
  *   ->flags
+ *   ->iobase
  *   ->mapbase
  *   ->mapsize
  *   ->regshift (if @use_defaults is false)
@@ -214,7 +215,7 @@ static int __uart_read_properties(struct
 	/* Read the registers I/O access type (default: MMIO 8-bit) */
 	ret = device_property_read_u32(dev, "reg-io-width", &value);
 	if (ret) {
-		port->iotype = UPIO_MEM;
+		port->iotype = port->iobase ? UPIO_PORT : UPIO_MEM;
 	} else {
 		switch (value) {
 		case 1:


