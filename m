Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B4C4E4C41;
	Fri,  9 Oct 2026 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557353; cv=none; b=q9TItoyWJ+GsUbKRe4dCF93mKaP9/ROKWfYeblnmItXELcH43+8nEP3/5uX+4upihqi4GHiD99nO4YlOlfzhyKAA+QPuqVJ4PaqI3lY0XM7ym53ExoFaOYdl9pqbfvGlqQeGKU7f3vbAjU+cqGNUd6Fplr27f/9ZBlAqGVQRDJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557353; c=relaxed/simple;
	bh=TQ28CC5aoO6TJIzLnRFYo9oOLwLEwN6Ts9VqZvByslQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltuqb1tDc0cl0GosPj7+rDdbfWpsKd222MXXIV1aoxmTW4RMtmUCUT/pfpLNrxjCLd1RVTsvg7mX6oU9Or0ItqCx9qiiy4Lu2Pnwyv36Ip3t/E3WlZs6w3/OKQb7G9JHAm+VxQ3WtFjIvJ9wUt7aBkTw8YH75S2mpnxzPUsP7k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izQ/jaVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izQ/jaVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B181F000FF;
	Fri,  9 Oct 2026 14:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557352;
	bh=t9anknfTllrTlj/u9CTU+MGj47Czbroo235XL4id2I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izQ/jaVSEhec0V/CN6yQVn9hhb35y1+w17SayOt8WNR6NgjJc/Bs9/nS7WBcEJpcJ
	 gb76likgLsul7sKLDq6gs2caUvAst3FUaEGv2QX+Ss0To9ov9UJ5DHROPATWtzUErD
	 v/4QRgSA7GUrL3ygeUTdrs67Z7w4heC9bXqfUdPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 342/428] USB: serial: fix dynamic id driver deregistration race
Date: Fri,  9 Oct 2026 16:11:19 +0200
Message-ID: <20261009140953.666240392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 63594e8ffe097bc0b7639936f33799a7653dded2 upstream.

Only free the dynamic ids after having deregistered the driver and
removed the "new_id" attribute to avoid leaking any id added by a racing
write to the attribute.

Fixes: 93bacefc4cc0 ("USB serial: add dynamic id support to usb-serial core")
Cc: stable@vger.kernel.org	# 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -165,7 +165,7 @@ int usb_serial_bus_register(struct usb_s
 
 void usb_serial_bus_deregister(struct usb_serial_driver *driver)
 {
-	free_dynids(driver);
 	driver_unregister(&driver->driver);
+	free_dynids(driver);
 }
 


