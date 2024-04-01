Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F01C0DE7;
	Mon,  1 Apr 2024 16:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989184; cv=none; b=gJuyvNxmdEmxCsrCSFcvZxlO+cNvbCeSxnaxrDkA4bJK0UDhA+O657B6odpWrm8NFbplgl5RuueZy+1N7QfV8p+sZ3Sj/IyLVxEbujG9eZYroobIQLkW+sAO62vMi5yRbVG6cv+QGANeaJNVfqk6ruUU6z4owBFtPfALWROCmKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989184; c=relaxed/simple;
	bh=5yeyomYaHD6B4lDeR4pJpc4Md2n1Wqcq6NMDa/xKkWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA/5d0yeWXLKcrmtHCXnAq/NT0BMHm3Pk9Zklr7P72yADgjEXyfCbxTTg4Cz/vFSO84ueYYH+zm61wHx8X0Uue9wgAkryRh3yCKYb4xaawU4vUx7ckV3WYK42lB9sMjoK4PYGr8scUnCfhS1eLcAJvz6eJa5Ye0VpexvDGlM0xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krKYHWDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krKYHWDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AF5C433F1;
	Mon,  1 Apr 2024 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989183;
	bh=5yeyomYaHD6B4lDeR4pJpc4Md2n1Wqcq6NMDa/xKkWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krKYHWDB7LzIh1uD1OFDqHyY8Nt+Yp//1jmAltWx2lKKZNR1BxoDZMBj86+F4vkct
	 RYqpaaOw5a9A74s0HcvniKqCkkg9WWnSTMMuOsGiQDjxVwxMY2xd9U8e5ra2dpwMFp
	 nNvAo0EJLFK8SytwdrE4+40RZxez3ZNziX/jNcow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.7 406/432] usb: typec: Return size of buffer if pd_set operation succeeds
Date: Mon,  1 Apr 2024 17:46:33 +0200
Message-ID: <20240401152605.496544360@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1310,6 +1310,7 @@ static ssize_t select_usb_power_delivery
 {
 	struct typec_port *port = to_typec_port(dev);
 	struct usb_power_delivery *pd;
+	int ret;
 
 	if (!port->ops || !port->ops->pd_set)
 		return -EOPNOTSUPP;
@@ -1318,7 +1319,11 @@ static ssize_t select_usb_power_delivery
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


