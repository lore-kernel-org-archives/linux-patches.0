Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CCC85270;
	Wed,  7 Aug 2024 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043202; cv=none; b=BB2ud1wstqzLb0IAPIx+nOsPelfBIeeqCbRfWkVBnqYsvhcxjuUfIxOtKgTgjZgiTAGqm7DF2mJzDRFb6yUgCqUNn7vK84QcY2ww3GsSx0iuaLYjJngLQE288VwBGFMLaZXN5pxPMfkxijaCwnqXvodgzsL609OTTpl9MO1mh1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043202; c=relaxed/simple;
	bh=HTIfLRwfMUWPF8QaG2u8VWLPtJtmaYc26Mzz/DzRNOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BA+lEoaRQFPOkENfdEBGJZDFRH3ylGKGlAkRDQecljWS0BO4tvj4ww82HYIuZ/OvlWkFVxsXKxiaknmO5Ydb3Icg+0NNwKNAYD0Cav3WPK62M1Mg762T98jlZWq558tuhe3bnxegFdAoJOdLZZpHTbPP+v2fB7+tLBHN2qSHzA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJD/KNem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJD/KNem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FD6C32781;
	Wed,  7 Aug 2024 15:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043202;
	bh=HTIfLRwfMUWPF8QaG2u8VWLPtJtmaYc26Mzz/DzRNOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJD/KNemY3hyOO4M4xYETbBi4AE6tB8ZGe+KL1OQ8etKJQpA2L6aznBTfffHvNM4w
	 EIh/Gj/ryONPYLPvJ/Vyd7fYGpLCsl3rqWlMYLcYdeoMsU3e1IvBEpKqMDeYqLafyZ
	 yHubbt53hLt+Wtds34GilJuSmAcytuw1Gp5Ej1uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 109/123] net: wan: fsl_qmc_hdlc: Convert carrier_lock spinlock to a mutex
Date: Wed,  7 Aug 2024 17:00:28 +0200
Message-ID: <20240807150024.388711323@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit c4d6a347ba7babdf9d90a0eb24048c266cae0532 upstream.

The carrier_lock spinlock protects the carrier detection. While it is
held, framer_get_status() is called which in turn takes a mutex.
This is not correct and can lead to a deadlock.

A run with PROVE_LOCKING enabled detected the issue:
  [ BUG: Invalid wait context ]
  ...
  c204ddbc (&framer->mutex){+.+.}-{3:3}, at: framer_get_status+0x40/0x78
  other info that might help us debug this:
  context-{4:4}
  2 locks held by ifconfig/146:
  #0: c0926a38 (rtnl_mutex){+.+.}-{3:3}, at: devinet_ioctl+0x12c/0x664
  #1: c2006a40 (&qmc_hdlc->carrier_lock){....}-{2:2}, at: qmc_hdlc_framer_set_carrier+0x30/0x98

Avoid the spinlock usage and convert carrier_lock to a mutex.

Fixes: 54762918ca85 ("net: wan: fsl_qmc_hdlc: Add framer support")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240730063104.179553-1-herve.codina@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/fsl_qmc_hdlc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/fsl_qmc_hdlc.c b/drivers/net/wan/fsl_qmc_hdlc.c
index c5e7ca793c43..64b4bfa6fea7 100644
--- a/drivers/net/wan/fsl_qmc_hdlc.c
+++ b/drivers/net/wan/fsl_qmc_hdlc.c
@@ -18,6 +18,7 @@
 #include <linux/hdlc.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -37,7 +38,7 @@ struct qmc_hdlc {
 	struct qmc_chan *qmc_chan;
 	struct net_device *netdev;
 	struct framer *framer;
-	spinlock_t carrier_lock; /* Protect carrier detection */
+	struct mutex carrier_lock; /* Protect carrier detection */
 	struct notifier_block nb;
 	bool is_crc32;
 	spinlock_t tx_lock; /* Protect tx descriptors */
@@ -60,7 +61,7 @@ static int qmc_hdlc_framer_set_carrier(struct qmc_hdlc *qmc_hdlc)
 	if (!qmc_hdlc->framer)
 		return 0;
 
-	guard(spinlock_irqsave)(&qmc_hdlc->carrier_lock);
+	guard(mutex)(&qmc_hdlc->carrier_lock);
 
 	ret = framer_get_status(qmc_hdlc->framer, &framer_status);
 	if (ret) {
@@ -706,7 +707,7 @@ static int qmc_hdlc_probe(struct platform_device *pdev)
 
 	qmc_hdlc->dev = dev;
 	spin_lock_init(&qmc_hdlc->tx_lock);
-	spin_lock_init(&qmc_hdlc->carrier_lock);
+	mutex_init(&qmc_hdlc->carrier_lock);
 
 	qmc_hdlc->qmc_chan = devm_qmc_chan_get_bychild(dev, dev->of_node);
 	if (IS_ERR(qmc_hdlc->qmc_chan))
-- 
2.46.0



