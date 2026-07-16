Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AD042CB16;
	Thu, 16 Jul 2026 14:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211938; cv=none; b=rPdnoEMMRpdvcL2x79PVBuETP7+mKw1GghL3IhcO+MDJMskg8G+R52IwQd4J9+V6WVudc8BFc7Q6PQTRr7+mxR7WyZqzDvNfZjE/Foj7pg6LSm4EWr1BpVYgGS99hdHzoosjzM6VQ1+Wjvi9jAOWK0dQHOQAbXlNzfEO/1yj9Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211938; c=relaxed/simple;
	bh=WyFAJneXmAG3HN+7s3ZTo9LMLoQzlM0YvvZOoXjVruI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzvzjcdO6nJ6mZqIyMz8+WI+6iFcJrqAxFYei5LBFIfb1BYMn/ZX/nOrffsYF2ad3Rv3GzPlZQ5i4+KoQZRVt5oNuHjKTY8l6PS6dRX+FjbieHis+EEovw+DVkmOf5VTt1kBLQcCSRDpdqjrkWlzxf9CZIqtajPjcObIHluml18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGRBzn9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGRBzn9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B93D1F000E9;
	Thu, 16 Jul 2026 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211937;
	bh=USI+3zEQoydquzKOnVwX2McZ6krZ2kjZATqDNKQSpmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGRBzn9mHPt/FhF2RHxJK1lhSAH8BDezJd9cR2oz/yXOaSLOlIRSM/m7f+s4bsrEU
	 AIGPTup4sXzMF7nytJnbX/LiEkBCEeFmVqrVJFWXPcKsRc6Ye7rj2aM0IRiDtQ5VGA
	 KtkwvuVKdXXxsKiSr+/+wXxVSX+sICfYX85vjLao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.12 100/349] usb: typec: tcpci_rt1711h: unregister TCPCI port with devres
Date: Thu, 16 Jul 2026 15:30:34 +0200
Message-ID: <20260716133035.552374591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,6 +330,8 @@ static int rt1711h_check_revision(struct
 	return ret;
 }
 
+static void rt1711h_unregister_tcpci_port(void *tcpci);
+
 static int rt1711h_probe(struct i2c_client *client)
 {
 	int ret;
@@ -381,6 +383,10 @@ static int rt1711h_probe(struct i2c_clie
 	if (IS_ERR_OR_NULL(chip->tcpci))
 		return PTR_ERR(chip->tcpci);
 
+	ret = devm_add_action_or_reset(chip->dev, rt1711h_unregister_tcpci_port, chip->tcpci);
+	if (ret)
+		return ret;
+
 	ret = devm_request_threaded_irq(chip->dev, client->irq, NULL,
 					rt1711h_irq,
 					IRQF_ONESHOT | IRQF_TRIGGER_LOW,
@@ -398,11 +404,9 @@ static int rt1711h_probe(struct i2c_clie
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
 
 static const struct rt1711h_chip_info rt1711h = {
@@ -435,7 +439,6 @@ static struct i2c_driver rt1711h_i2c_dri
 		.of_match_table = rt1711h_of_match,
 	},
 	.probe = rt1711h_probe,
-	.remove = rt1711h_remove,
 	.id_table = rt1711h_id,
 };
 module_i2c_driver(rt1711h_i2c_driver);


