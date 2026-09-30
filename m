Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA335501F59;
	Wed, 30 Sep 2026 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782460; cv=none; b=am4fuc/qmP9qvdiTXH9RLFw8HJruEUtM3fK/2jGoI08dUMBNTjuWWJYYIqRJeorzIWQlq3NrqxzTPlIric3VV+ryh03OLKxr8+x4qEf/b2THC2EknRyy/545/hv+4VihBzLEa9Y1vgBG/OIQh97c/2I+g14cCyyfjcY7QVm6B8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782460; c=relaxed/simple;
	bh=aXxyljxQUhvZITvDIFgLZ/VKWoctLraXdjJsUqxKMq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqbz4CiU9GX/D0T1jJyIHUiguNWIMJg3S9D94PrT/im/GJ22mbrTixmDyhBnINok8DAweI+p+9qGgi7V++3lqVGExBLPyd6+9FWgRuAeP1NQhfieaEnpmW/k4F49U15XKT2ppGqPrMdOioyhUUwaWYpxzGfyuoNWNLZwVYUIzt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDErEFt4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDErEFt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FB91F00899;
	Wed, 30 Sep 2026 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782450;
	bh=NW1VY0U/sqEhrYkvMWyxTojl5caJg0ZsDthNw44J1/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDErEFt42esDcS7YmG06/kaUwF4LUKJJObyq4eZBnZayS44dhaeedgLXQEyEvKKvk
	 xApbA+mpNzFEL9r4bQaA8+6ERSgn3TpTfiAh4R5tla7hQV8SlpS+s6WdaNyGH52sY/
	 KbBgAD19MBwTGpnxnzPWyvVfzumEVss1zNCv3rck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Wowk <dev@adrianwowk.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/595] usbip: vhci_hcd: fix NULL deref in status_show_vhci
Date: Wed, 30 Sep 2026 17:19:03 +0200
Message-ID: <20260930152348.807095804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Wowk <dev@adrianwowk.com>

[ Upstream commit bc150783542ba2e7c1257d1299c6f3269bdba270 ]

platform_get_drvdata() can return NULL if a VHCI host controller's
probe failed (e.g. due to USB bus number exhaustion). status_show_vhci()
checked for a NULL pdev but not for a NULL hcd returned by
platform_get_drvdata(). Passing NULL to hcd_to_vhci_hcd() does not
return NULL - it returns a pointer offset of 0x260, causing a NULL
pointer dereference when that value is subsequently dereferenced.

Add a NULL check on hcd before calling hcd_to_vhci_hcd(). Move
status_show_not_ready() above status_show_vhci() to make it callable
from the new error path without a forward declaration.

Signed-off-by: Adrian Wowk <dev@adrianwowk.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://patch.msgid.link/20260414010050.158064-2-dev@adrianwowk.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/vhci_sysfs.c | 52 +++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
index ebc7be1d98207..47768e326896d 100644
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -59,6 +59,29 @@ static void port_show_vhci(char **out, int hub, int port, struct vhci_device *vd
 	*out += sprintf(*out, "\n");
 }
 
+static ssize_t status_show_not_ready(int pdev_nr, char *out)
+{
+	char *s = out;
+	int i = 0;
+
+	for (i = 0; i < VHCI_HC_PORTS; i++) {
+		out += sprintf(out, "hs  %04u %03u ",
+				    (pdev_nr * VHCI_PORTS) + i,
+				    VDEV_ST_NOTASSIGNED);
+		out += sprintf(out, "000 00000000 0000000000000000 0-0");
+		out += sprintf(out, "\n");
+	}
+
+	for (i = 0; i < VHCI_HC_PORTS; i++) {
+		out += sprintf(out, "ss  %04u %03u ",
+				    (pdev_nr * VHCI_PORTS) + VHCI_HC_PORTS + i,
+				    VDEV_ST_NOTASSIGNED);
+		out += sprintf(out, "000 00000000 0000000000000000 0-0");
+		out += sprintf(out, "\n");
+	}
+	return out - s;
+}
+
 /* Sysfs entry to show port status */
 static ssize_t status_show_vhci(int pdev_nr, char *out)
 {
@@ -76,6 +99,12 @@ static ssize_t status_show_vhci(int pdev_nr, char *out)
 	}
 
 	hcd = platform_get_drvdata(pdev);
+
+	if (!hcd) {
+		usbip_dbg_vhci_sysfs("show status error (hcd is NULL)\n");
+		return status_show_not_ready(pdev_nr, out);
+	}
+
 	vhci_hcd = hcd_to_vhci_hcd(hcd);
 	vhci = vhci_hcd->vhci;
 
@@ -104,29 +133,6 @@ static ssize_t status_show_vhci(int pdev_nr, char *out)
 	return out - s;
 }
 
-static ssize_t status_show_not_ready(int pdev_nr, char *out)
-{
-	char *s = out;
-	int i = 0;
-
-	for (i = 0; i < VHCI_HC_PORTS; i++) {
-		out += sprintf(out, "hs  %04u %03u ",
-				    (pdev_nr * VHCI_PORTS) + i,
-				    VDEV_ST_NOTASSIGNED);
-		out += sprintf(out, "000 00000000 0000000000000000 0-0");
-		out += sprintf(out, "\n");
-	}
-
-	for (i = 0; i < VHCI_HC_PORTS; i++) {
-		out += sprintf(out, "ss  %04u %03u ",
-				    (pdev_nr * VHCI_PORTS) + VHCI_HC_PORTS + i,
-				    VDEV_ST_NOTASSIGNED);
-		out += sprintf(out, "000 00000000 0000000000000000 0-0");
-		out += sprintf(out, "\n");
-	}
-	return out - s;
-}
-
 static int status_name_to_id(const char *name)
 {
 	char *c;
-- 
2.53.0



