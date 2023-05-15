Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8A8171B9
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60C8C4339B;
	Mon, 15 May 2023 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173818;
	bh=OUDdx1/+ndFS8cjN2u1aFYgMWoFLoSoVodw288cEd74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1zLLCGP7PFyewYNWJkKRNcHX1mI84yagrPb77rSsf8SwxNqLPpRH1iC5aNhrcggQ
	 Z53P2SnTqcp3dibc839m1eun6gVR5qwi6kSd7jaVN2zFexloMHOkPhkuLEs5+8wxj7
	 H9zCRdAuJJoR2ibwASiuX5nP6EYS7DboIC0xQc50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Auhagen <sven.auhagen@voleatech.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 217/282] crypto: inside-secure - irq balance
Date: Mon, 15 May 2023 18:29:55 +0200
Message-Id: <20230515161728.741104819@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Auhagen <Sven.Auhagen@voleatech.de>

[ Upstream commit c6720415907f21b9c53efbe679b96c3cc9d06404 ]

Balance the irqs of the inside secure driver over all
available cpus.
Currently all interrupts are handled by the first CPU.

>From my testing with IPSec AES-GCM 256
on my MCbin with 4 Cores I get a 50% speed increase:

Before the patch: 99.73 Kpps
With the patch: 151.25 Kpps

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: ca25c00ccbc5 ("crypto: safexcel - Cleanup ring IRQ workqueues on load failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 13 +++++++++++--
 drivers/crypto/inside-secure/safexcel.h |  3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 9534f52210af0..2d34a3832d8e6 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1090,11 +1090,12 @@ static irqreturn_t safexcel_irq_ring_thread(int irq, void *data)
 
 static int safexcel_request_ring_irq(void *pdev, int irqid,
 				     int is_pci_dev,
+				     int ring_id,
 				     irq_handler_t handler,
 				     irq_handler_t threaded_handler,
 				     struct safexcel_ring_irq_data *ring_irq_priv)
 {
-	int ret, irq;
+	int ret, irq, cpu;
 	struct device *dev;
 
 	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
@@ -1132,6 +1133,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 		return ret;
 	}
 
+	/* Set affinity */
+	cpu = cpumask_local_spread(ring_id, NUMA_NO_NODE);
+	irq_set_affinity_hint(irq, get_cpu_mask(cpu));
+
 	return irq;
 }
 
@@ -1482,6 +1487,7 @@ static int safexcel_probe_generic(void *pdev,
 		irq = safexcel_request_ring_irq(pdev,
 						EIP197_IRQ_NUMBER(i, is_pci_dev),
 						is_pci_dev,
+						i,
 						safexcel_irq_ring,
 						safexcel_irq_ring_thread,
 						ring_irq);
@@ -1490,6 +1496,7 @@ static int safexcel_probe_generic(void *pdev,
 			return irq;
 		}
 
+		priv->ring[i].irq = irq;
 		priv->ring[i].work_data.priv = priv;
 		priv->ring[i].work_data.ring = i;
 		INIT_WORK(&priv->ring[i].work_data.work,
@@ -1627,8 +1634,10 @@ static int safexcel_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(priv->clk);
 
-	for (i = 0; i < priv->config.rings; i++)
+	for (i = 0; i < priv->config.rings; i++) {
+		irq_set_affinity_hint(priv->ring[i].irq, NULL);
 		destroy_workqueue(priv->ring[i].workqueue);
+	}
 
 	return 0;
 }
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 930cc48a6f859..6a4d7f09bca96 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -640,6 +640,9 @@ struct safexcel_ring {
 	 */
 	struct crypto_async_request *req;
 	struct crypto_async_request *backlog;
+
+	/* irq of this ring */
+	int irq;
 };
 
 /* EIP integration context flags */
-- 
2.39.2



