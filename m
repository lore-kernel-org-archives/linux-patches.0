Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F0238C21;
	Tue, 29 Apr 2025 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948362; cv=none; b=pBu76jg7jFFYTmM1tz44PoWjTvU7rveZYb+MXGnMv0DHmNlHAy0K9e3mNI9GfsWp3dTMcHBQSRCQI6/Suh4F7CCNyvd+1Xe2NZikODJE7u8ZhNxuV1VNTIQxbfXrjJEkFmmGfUgEC9X7VAKNsccWfOFEz1iUKi2eZwaHXVE30/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948362; c=relaxed/simple;
	bh=z7XG9Klcbx+Jq76PYaWixOBzy6FnV+KQtcUk613vAE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8RApWM/GOaxTxY/FA4/YsIcYStdUmJYrot9JqVRUYnSaY/j5cH4yd2HgcvWFYDLUoOp2LPSWgJddnFwVBXgrRnp5nUGSMnBzIMUVGHCoVSliz0F/xF2s1nuOLYlr81NRf9B9Qve3GfOpD/kNxP1wysnRGAi/NeB8B++QWvG2bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zg+/HX8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zg+/HX8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AF9C4CEE3;
	Tue, 29 Apr 2025 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948362;
	bh=z7XG9Klcbx+Jq76PYaWixOBzy6FnV+KQtcUk613vAE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zg+/HX8srcpI6sNTJFXAfmSo+8suxKtdQWUhmsKhLEZZspOwCwniyVBFcTEbBU3J5
	 YmArHDyEqRQAGzf0sXeEmhSWbQPLDg6i0QgWB0VO56If4pKklkcMrduLQlVLY0cHCF
	 5X1IG3zOln4cJofQ3eNIiqjvwX7rGXbFcbJqCeDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.12 263/280] usb: typec: class: Invalidate USB device pointers on partner unregistration
Date: Tue, 29 Apr 2025 18:43:24 +0200
Message-ID: <20250429161125.893911755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 66e1a887273c6b89f09bc11a40d0a71d5a081a8e upstream.

To avoid using invalid USB device pointers after a Type-C partner
disconnects, this patch clears the pointers upon partner unregistration.
This ensures a clean state for future connections.

Cc: stable@vger.kernel.org
Fixes: 59de2a56d127 ("usb: typec: Link enumerated USB devices with Type-C partner")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250321143728.4092417-3-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -966,10 +966,14 @@ void typec_unregister_partner(struct typ
 	port = to_typec_port(partner->dev.parent);
 
 	mutex_lock(&port->partner_link_lock);
-	if (port->usb2_dev)
+	if (port->usb2_dev) {
 		typec_partner_unlink_device(partner, port->usb2_dev);
-	if (port->usb3_dev)
+		port->usb2_dev = NULL;
+	}
+	if (port->usb3_dev) {
 		typec_partner_unlink_device(partner, port->usb3_dev);
+		port->usb3_dev = NULL;
+	}
 
 	device_unregister(&partner->dev);
 	mutex_unlock(&port->partner_link_lock);


