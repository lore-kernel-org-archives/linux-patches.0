Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63107317145;
	Sat, 12 Sep 2026 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227426; cv=none; b=BOuOCk+3pE83wTjt6gst3+Bo+jhmhbb+9GRu2OiuqOoqTv8dy86V9Q18LoS3D1XkVS1pscjXvf0epABI6BCgf0DvQEuFi+2GIk2sKYygdOXZtkfrJEtJdgECsSjMA1+arxOzUvn0YsKzTHcoguD9ePPmG4cFjx+t+/SOBeLDwfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227426; c=relaxed/simple;
	bh=vGabyS6zKLKActPhN9C9GTGVUUYkLk1FpXb6P+hVGzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsZGA1qP4j7XXLuxg9fQJZ8zCsQl6LtGcswUeUyKnW6gts5OzvzIG9Qe9FoP7Y2XQqUEOFUordkw8B4g4aP/I+bZLtSE5lSxjxofGt4wLL7DuqsLxEmYwgeOxmB0bqoWGCHnEImlQU8vatqkFlmauY6iKeG4WSS+RSpOHISjv8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLsoHrZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLsoHrZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DC41F000FF;
	Sat, 12 Sep 2026 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227425;
	bh=EjKr7u6TJWaQ5hS6/CZbZXHnlaGchASfw1OMoOK5tEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLsoHrZWPNyPwfgjEpowFQYAGmUJ+ESoH3tpjTNDdSAnkV/mV+wqBkJXvazQxdp+n
	 xRPoHlNcIR9gkd5/LNIGAIQMRB2bGx7bMs2irfev9GI/tyRYUR9y0mACRC7UxNvCg8
	 4xqzorQ+YsuX2cQDJ0RXVFhMyyu4i+UKDlH8Hje0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 0177/1191] power: supply: cros_usbpd: Limit port counts to EC_USB_PD_MAX_PORTS
Date: Sat, 12 Sep 2026 08:48:25 +0200
Message-ID: <20260912065552.190362155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jameson Thies <jthies@google.com>

commit 657cd3a42e937276262c0a8ae6b01a87004309de upstream.

Currently the cros_usbpd-charger driver probe iterates based on raw
charger port count returned by the embedded controller. The only check
is against the number of USB PD ports which the embedded controller
also defines. A malicious embedded controller could return an inaccurate
port count (up to 255) resulting in an out of bounds write and
subsequent memory corruption.

Update helper functions in cros_usbpd-charger to limit port counts to
EC_USB_PD_MAX_PORTS.

Fixes: 3af15cfacd1e ("power: supply: cros: add support for dedicated port")
Cc: stable@vger.kernel.org
Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/20260722195059.1420738-1-jthies@google.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cros_usbpd-charger.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -136,6 +136,11 @@ static int cros_usbpd_charger_get_num_po
 	if (ret < 0)
 		return ret;
 
+	if (resp.port_count > EC_USB_PD_MAX_PORTS) {
+		dev_warn(charger->dev, "Charge port count out of bounds\n");
+		return EC_USB_PD_MAX_PORTS;
+	}
+
 	return resp.port_count;
 }
 
@@ -149,6 +154,11 @@ static int cros_usbpd_charger_get_usbpd_
 	if (ret < 0)
 		return ret;
 
+	if (resp.num_ports > EC_USB_PD_MAX_PORTS) {
+		dev_warn(charger->dev, "USB PD port count out of bounds\n");
+		return EC_USB_PD_MAX_PORTS;
+	}
+
 	return resp.num_ports;
 }
 


