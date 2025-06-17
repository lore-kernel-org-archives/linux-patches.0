Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AEA2CCC5;
	Tue, 17 Jun 2025 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178867; cv=none; b=MOj0plUyyYGUuBOO+BZHwHh4yXxNzvwull8odip3AQ4MtOhxA1RE7hvOwVc8V+yOKHEJvE1+JNkK73tTKC7Al6Nd83tOxp+nznzcXYCbJ85jzDMXjZApgriMR2uLoueOxeT0JHolkaBO0RvALfNMHtak5QX5KFq8FSwjEyypngE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178867; c=relaxed/simple;
	bh=s6udxH4+DkYadES94nuy6f9p4OVPIsaiVQN9bIcOdW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhJm/kN4XRc1SMLte5dD+lJ7NrGQLejFUrwZ1GyOoH80qUB/7IJfhDL848PH1IiILjSnzXS690v5EBe+6iCVzdA6gk2K2KTPQBvLEjE57Rt9zhc+jNBWuXl+teIbBfZwafMa93fxqgVC2tAzgw+FyQEVFfXYPWmoNms8geY01cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQKmwSLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQKmwSLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DCDC4CEE3;
	Tue, 17 Jun 2025 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178867;
	bh=s6udxH4+DkYadES94nuy6f9p4OVPIsaiVQN9bIcOdW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQKmwSLNn2nYUSJKy0igZUAjGidOKsnWILfZvgO8ywoXStsukfUpdknItMpBNhm/e
	 cnJwpoTxLh9eo5s1rP+THSeK7mbnI2rxnwVK2z9xb13k1+t9wfAVmEFghuQUvt6mcf
	 RTzSrlkgOWc4aVc71vdkFw3VNxjacMLs59AEAXiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 546/780] USB: serial: bus: fix const issue in usb_serial_device_match()
Date: Tue, 17 Jun 2025 17:24:14 +0200
Message-ID: <20250617152513.744328939@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2fea1b1db4a26..9e2a18c0b2183 100644
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



