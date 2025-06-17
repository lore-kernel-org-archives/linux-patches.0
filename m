Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879AA1DF244;
	Tue, 17 Jun 2025 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177415; cv=none; b=EY37Q0wK+WCKaWma3Pw5Lu6eDuPA0mok2u1PSejq1KwV0XVJTWPCgsz/PVxJSZ10hh5QwO1qEblM6eG4spOpvM8T44EEda7Gdyj1xzYc7UBNnLfzbwpEUj+BtOaarwIOhV0QFFlh408P3nVVDxaF/oMuihQ6rnz7xLzIdbDzMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177415; c=relaxed/simple;
	bh=88RHkx3mJl/Ihge9GblCLJMmmlVJohvM5iqTEtwJXK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/RlG2/lFVuDgGY8+iAkxt75Z25TgJwMFQfGbGVtSbbo+fcvBQlLqLBHG6UxTPVes7vY4eDl6qHBIeNo7yv8irUoqJG7clioHvnTMkh0U0hW6ENKhCHemdpnk7ixyAwJCap99FelCQ3q+qG5nV8+J3P3FzlkXPX2znMlgiReVgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7dzU5Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7dzU5Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A66C4CEE7;
	Tue, 17 Jun 2025 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177415;
	bh=88RHkx3mJl/Ihge9GblCLJMmmlVJohvM5iqTEtwJXK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7dzU5YlOPOyZDelf0cimIl59MFdlIRH7eF64cfa4TmFbS2pWBaF1kvbk6SlMHNBJ
	 l/Tyj+rVnnIAHMxQ5pxZ631qy1PJb1XUD1gBSHy6r81NNABzxy2sNvhV8dVuK7mo4D
	 2NH5lem/8NewEPNQNnPR2VdqkHVeaJ4eSMZfdiQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/512] USB: serial: bus: fix const issue in usb_serial_device_match()
Date: Tue, 17 Jun 2025 17:25:06 +0200
Message-ID: <20250617152433.381377867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 92cd405b648605db4da866f3b9818b271ae84ef0 ]

usb_serial_device_match() takes a const pointer, and then decides to
cast it away into a non-const one, which is not a good thing to do
overall.  Fix this up by properly setting the pointers to be const to
preserve that attribute.

Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/bus.c b/drivers/usb/serial/bus.c
index d200e2c29a8ff..45cb78864c96d 100644
--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -17,7 +17,7 @@ static int usb_serial_device_match(struct device *dev,
 				   const struct device_driver *drv)
 {
 	const struct usb_serial_port *port = to_usb_serial_port(dev);
-	struct usb_serial_driver *driver = to_usb_serial_driver(drv);
+	const struct usb_serial_driver *driver = to_usb_serial_driver(drv);
 
 	/*
 	 * drivers are already assigned to ports in serial_probe so it's
-- 
2.39.5



