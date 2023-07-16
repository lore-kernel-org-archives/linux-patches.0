Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A596D8F75
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235B0C433C9;
	Sun, 16 Jul 2023 20:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538825;
	bh=pdyHXaEZOPRuTeW943UOA04bLrByxqzfVhVhft9KrpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3PqtFVv3V7CVo63OUnG3i7e9hBjHxDg+EH47V4GJdZp6WKx2sjgVd6w/wmUsdCfb
	 jLNd7xfHUEgpPjFxVhTOJyU5zLwnITPqOeSrdhCOCInbM9TBw23Bgaw8Shh650UlWD
	 0eB9zxZ0txvwZAl8ZkWvco4OpxcodAHMyhp4mXtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 589/800] usb: gadget: u_serial: Add null pointer check in gserial_suspend
Date: Sun, 16 Jul 2023 21:47:22 +0200
Message-ID: <20230716195002.780007376@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prashanth K <quic_prashk@quicinc.com>

[ Upstream commit 2f6ecb89fe8feb2b60a53325b0eeb9866d88909a ]

Consider a case where gserial_disconnect has already cleared
gser->ioport. And if gserial_suspend gets called afterwards,
it will lead to accessing of gser->ioport and thus causing
null pointer dereference.

Avoid this by adding a null pointer check. Added a static
spinlock to prevent gser->ioport from becoming null after
the newly added null pointer check.

Fixes: aba3a8d01d62 ("usb: gadget: u_serial: add suspend resume callbacks")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/1683278317-11774-1-git-send-email-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_serial.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index a0ca47fbff0fc..e5d522d54f6a3 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -1420,10 +1420,19 @@ EXPORT_SYMBOL_GPL(gserial_disconnect);
 
 void gserial_suspend(struct gserial *gser)
 {
-	struct gs_port	*port = gser->ioport;
+	struct gs_port	*port;
 	unsigned long	flags;
 
-	spin_lock_irqsave(&port->port_lock, flags);
+	spin_lock_irqsave(&serial_port_lock, flags);
+	port = gser->ioport;
+
+	if (!port) {
+		spin_unlock_irqrestore(&serial_port_lock, flags);
+		return;
+	}
+
+	spin_lock(&port->port_lock);
+	spin_unlock(&serial_port_lock);
 	port->suspended = true;
 	spin_unlock_irqrestore(&port->port_lock, flags);
 }
-- 
2.39.2



