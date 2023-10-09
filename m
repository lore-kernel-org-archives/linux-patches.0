Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD79341AC
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09b8+/uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563C2C433C7;
	Mon,  9 Oct 2023 13:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859324;
	bh=V8rnOBwfeUqimfT+xKmOS4KHl5KjwyawWAc79BVPPPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09b8+/uumKK13yKUqrUce5U1F8mKlvxml9zAw5ZJhbga2ICM2hzHpHASMr/pha4XM
	 5LfjrFkIQR5ckO7nPKyfiqizk1qhVFbO4iMo4gPH1SSa5zbhxxHeN6y9/T8qSDdUO/
	 AYKpPlHk8qxAQMT//MDdlpS96dy4wPlG30gWlwmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 41/55] drivers/net: process the result of hdlc_open() and add call of hdlc_close() in uhdlc_close()
Date: Mon,  9 Oct 2023 15:06:40 +0200
Message-ID: <20231009130109.265036332@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Diupina <adiupina@astralinux.ru>

[ Upstream commit a59addacf899b1b21a7b7449a1c52c98704c2472 ]

Process the result of hdlc_open() and call uhdlc_close()
in case of an error. It is necessary to pass the error
code up the control flow, similar to a possible
error in request_irq().
Also add a hdlc_close() call to the uhdlc_close()
because the comment to hdlc_close() says it must be called
by the hardware driver when the HDLC device is being closed

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c19b6d246a35 ("drivers/net: support hdlc function for QE-UCC")
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 978f642dacedd..00cc9b755a852 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -37,6 +37,8 @@
 
 #define TDM_PPPOHT_SLIC_MAXIN
 
+static int uhdlc_close(struct net_device *dev);
+
 static struct ucc_tdm_info utdm_primary_info = {
 	.uf_info = {
 		.tsa = 0,
@@ -662,6 +664,7 @@ static int uhdlc_open(struct net_device *dev)
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	struct ucc_hdlc_private *priv = hdlc->priv;
 	struct ucc_tdm *utdm = priv->utdm;
+	int rc = 0;
 
 	if (priv->hdlc_busy != 1) {
 		if (request_irq(priv->ut_info->uf_info.irq,
@@ -684,10 +687,13 @@ static int uhdlc_open(struct net_device *dev)
 		netif_device_attach(priv->ndev);
 		napi_enable(&priv->napi);
 		netif_start_queue(dev);
-		hdlc_open(dev);
+
+		rc = hdlc_open(dev);
+		if (rc)
+			uhdlc_close(dev);
 	}
 
-	return 0;
+	return rc;
 }
 
 static void uhdlc_memclean(struct ucc_hdlc_private *priv)
@@ -776,6 +782,8 @@ static int uhdlc_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	priv->hdlc_busy = 0;
 
+	hdlc_close(dev);
+
 	return 0;
 }
 
-- 
2.40.1



