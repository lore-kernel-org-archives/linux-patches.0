Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA4481B8;
	Mon,  1 Apr 2024 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991479; cv=none; b=inpScIN8b3xTbpIZ9kuUVvtuqkBTEs6wUdSFxUC8A2KmLofr9Oaex3jjtkkhrJycUqvIxXZttvc7HchKrNbwmCqnQKAUt/e+aa5y1J1zK8p1sGWA1PtJ3VoEqsGwNt/msdS1hpW3kRJ3nh4AFTgy0B73PhIekY8nf05MtkLALUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991479; c=relaxed/simple;
	bh=/oSkE1EVP0ycfDQCl4pkwfYmjyS7GZ3bkLmw5vOBWaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8AKbfSoU3zmyEJaUrAuGVuqqLAXVsq4UEE3EAWa1jp344bOik5nrYba8jELau0tAGLMKPF1xAkG1iaOe/HDNumyESZUN2VtiavIAzFainP/gLWm00DvfEwFUrOgx2FJ9C3cWMCx8rTrjcalgM3eKqNJYN7GKivYmtxyJPBQ9z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+Fjgozg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+Fjgozg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA5BC433C7;
	Mon,  1 Apr 2024 17:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991479;
	bh=/oSkE1EVP0ycfDQCl4pkwfYmjyS7GZ3bkLmw5vOBWaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+FjgozggNP6Ay3mCBJcEz+fu4h4/apE4Js4sTZ5m4Z8KEfKglFU3xS06yVQDq9dA
	 0NDx+TgJyMircLB99dlMUuVKwjQ8rkZ/UwY140nTMu9QvoERrnlyBhgAbWTYgonQvr
	 qv/rJkQZ41kjPMEU4KTT7HZY0svK+49JkTOVtiBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 249/272] usb: typec: Return size of buffer if pd_set operation succeeds
Date: Mon,  1 Apr 2024 17:47:19 +0200
Message-ID: <20240401152538.793292559@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kyle Tso <kyletso@google.com>

commit 53f5094fdf5deacd99b8655df692e9278506724d upstream.

The attribute writing should return the number of bytes used from the
buffer on success.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Tso <kyletso@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240319074309.3306579-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1245,6 +1245,7 @@ static ssize_t select_usb_power_delivery
 {
 	struct typec_port *port = to_typec_port(dev);
 	struct usb_power_delivery *pd;
+	int ret;
 
 	if (!port->ops || !port->ops->pd_set)
 		return -EOPNOTSUPP;
@@ -1253,7 +1254,11 @@ static ssize_t select_usb_power_delivery
 	if (!pd)
 		return -EINVAL;
 
-	return port->ops->pd_set(port, pd);
+	ret = port->ops->pd_set(port, pd);
+	if (ret)
+		return ret;
+
+	return size;
 }
 
 static ssize_t select_usb_power_delivery_show(struct device *dev,


