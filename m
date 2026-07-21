Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021B524A078;
	Tue, 21 Jul 2026 20:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664980; cv=none; b=VluPmLzKD2vbxEB6qz6E0KdC7oYRWLlVUrmHjsMSAKJoSDaAXG5Qi6J0g1z1CSU9VjDVRCfLTK7g+BPv91vtoYQBa9xdjDeuUqy3eedF5YFcDhLXc3tV0mkMwT+BgNkem4xg+hcTBfv6/nB9I4w0KAYNHsXT0Mn6FHohE1e/tMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664980; c=relaxed/simple;
	bh=isA3Bx6Fmd/QNVCXgUJGXHDhDZef2Ys1gyJDQ65WnW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRFyUvzxevTuqtTJY8UXBSylVrIpUcJaq3rFVIIVRC26zIovDPSF2oYI9CuvOdBxZI6Sowt1/nJm28vLC5nWBCcfbpV0WIySOX9zh90icf/UKpcXlbgo2UYCSDHQp6e84TVFULsIuQRW60MR+oy6C0gMQgdIFX8YCHhEBOnmIMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8wRU4lv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8wRU4lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6721E1F00A3A;
	Tue, 21 Jul 2026 20:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664978;
	bh=5oA8i9yaiTV6UHUw2TGhWOIpE/653frwjyknjMLZylc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8wRU4lv8Q+RBTLUGKO39PJwuZe2yysF8ArkrhhOGe++o7WM/J8bRc/IM+1YLPApO
	 LWz3qBf86Zj/8wZhHrE5hxsEbil05HIvF5B4xkjAdtyl2OEujZpg8bORtul7pBTu3P
	 e0jyZWS+mxsZyicqi8ckyj/GID7glU1uW1Uo4X+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.6 0129/1266] usb: typec: tcpci_rt1711h: unregister TCPCI port with devres
Date: Tue, 21 Jul 2026 17:09:26 +0200
Message-ID: <20260721152444.691819399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit e8da46d99d3710106e7c44db14566bf9b57386b5 upstream.

rt1711h_probe() registers the TCPCI port before requesting the interrupt
and enabling alert interrupts. If either of those later steps fails, the
probe function returns without unregistering the TCPCI port. The explicit
unregister currently only happens from the remove callback.

Register a devres action immediately after tcpci_register_port() succeeds,
so tcpci_unregister_port() runs on later probe failures and on driver
detach. Drop the remove callback to avoid unregistering the same port
twice.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 302c570bf36e ("usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260706145312.37260-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci_rt1711h.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpci_rt1711h.c
+++ b/drivers/usb/typec/tcpm/tcpci_rt1711h.c
@@ -327,6 +327,8 @@ static int rt1711h_check_revision(struct
 	return ret;
 }
 
+static void rt1711h_unregister_tcpci_port(void *tcpci);
+
 static int rt1711h_probe(struct i2c_client *client)
 {
 	int ret;
@@ -378,6 +380,10 @@ static int rt1711h_probe(struct i2c_clie
 	if (IS_ERR_OR_NULL(chip->tcpci))
 		return PTR_ERR(chip->tcpci);
 
+	ret = devm_add_action_or_reset(chip->dev, rt1711h_unregister_tcpci_port, chip->tcpci);
+	if (ret)
+		return ret;
+
 	ret = devm_request_threaded_irq(chip->dev, client->irq, NULL,
 					rt1711h_irq,
 					IRQF_ONESHOT | IRQF_TRIGGER_LOW,
@@ -395,11 +401,9 @@ static int rt1711h_probe(struct i2c_clie
 	return 0;
 }
 
-static void rt1711h_remove(struct i2c_client *client)
+static void rt1711h_unregister_tcpci_port(void *tcpci)
 {
-	struct rt1711h_chip *chip = i2c_get_clientdata(client);
-
-	tcpci_unregister_port(chip->tcpci);
+	tcpci_unregister_port(tcpci);
 }
 
 static const struct i2c_device_id rt1711h_id[] = {
@@ -424,7 +428,6 @@ static struct i2c_driver rt1711h_i2c_dri
 		.of_match_table = of_match_ptr(rt1711h_of_match),
 	},
 	.probe = rt1711h_probe,
-	.remove = rt1711h_remove,
 	.id_table = rt1711h_id,
 };
 module_i2c_driver(rt1711h_i2c_driver);


