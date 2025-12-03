Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F08633C539;
	Wed,  3 Dec 2025 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777290; cv=none; b=f4iIWhFe77MmqSUJQxFBm8DV8qjCsUIaa6x0UK85gJGs4Vz9P33XuhlSTY1EPbABrj8GVouNgf3q5/ZSoGnUVFSm7V21j4gYtuwW25iChgRqhT+5UQRw8/9GPZIUz1Z8wCGIZVbr33v+0lu8WgL7XznQymPxuAkLuEW0IqYiZpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777290; c=relaxed/simple;
	bh=bSdO3J8R/Mj6uLKJzrAOIHmwcRB+Hd2839nsTGTKTJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGcpUSUN9Rx1bvqpTYPUhKeSHkglJUEbk3waTllA54rcKpeih4+NhGm5tJr1y5na1WY6KEPABDjRLJ2nNlez+Ku78Jv6ogMAB3lfbcppVM9L1n2y6gjpCCJJ91bHxjKrfI8V4esZcQBwJ17TIniCdgAM2ii7GjjXkiStmbBBfX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9OqQimv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9OqQimv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025C0C4CEF5;
	Wed,  3 Dec 2025 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777290;
	bh=bSdO3J8R/Mj6uLKJzrAOIHmwcRB+Hd2839nsTGTKTJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9OqQimveuYoiiHz212O72RUoivo3CT4dYBLNHigQbzlqLKzJu0XhSjjYZkCCL1Ik
	 RjZ67g2BD/e3eH6CCIOtZag/Y6a9zRsHuqGk7suQUM7SHWRvjLR6gjJeti4j85q6Lb
	 I04ImqeSQs4zoOCYZ5pDMa5ln79fa1CDbA/1xAl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.17 138/146] net: dsa: microchip: Fix symetry in ksz_ptp_msg_irq_{setup/free}()
Date: Wed,  3 Dec 2025 16:28:36 +0100
Message-ID: <20251203152351.523524303@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>

commit d0b8fec8ae50525b57139393d0bb1f446e82ff7e upstream.

The IRQ numbers created through irq_create_mapping() are only assigned
to ptpmsg_irq[n].num at the end of the IRQ setup. So if an error occurs
between their creation and their assignment (for instance during the
request_threaded_irq() step), we enter the error path and fail to
release the newly created virtual IRQs because they aren't yet assigned
to ptpmsg_irq[n].num.

Move the mapping creation to ksz_ptp_msg_irq_setup() to ensure symetry
with what's released by ksz_ptp_msg_irq_free().
In the error path, move the irq_dispose_mapping to the out_ptp_msg label
so it will be called only on created IRQs.

Cc: stable@vger.kernel.org
Fixes: cc13ab18b201 ("net: dsa: microchip: ptp: enable interrupt for timestamping")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Link: https://patch.msgid.link/20251120-ksz-fix-v6-5-891f80ae7f8f@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_ptp.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -1093,19 +1093,19 @@ static int ksz_ptp_msg_irq_setup(struct
 	static const char * const name[] = {"pdresp-msg", "xdreq-msg",
 					    "sync-msg"};
 	const struct ksz_dev_ops *ops = port->ksz_dev->dev_ops;
+	struct ksz_irq *ptpirq = &port->ptpirq;
 	struct ksz_ptp_irq *ptpmsg_irq;
 
 	ptpmsg_irq = &port->ptpmsg_irq[n];
+	ptpmsg_irq->num = irq_create_mapping(ptpirq->domain, n);
+	if (!ptpmsg_irq->num)
+		return -EINVAL;
 
 	ptpmsg_irq->port = port;
 	ptpmsg_irq->ts_reg = ops->get_port_addr(port->num, ts_reg[n]);
 
 	strscpy(ptpmsg_irq->name, name[n]);
 
-	ptpmsg_irq->num = irq_find_mapping(port->ptpirq.domain, n);
-	if (ptpmsg_irq->num < 0)
-		return ptpmsg_irq->num;
-
 	return request_threaded_irq(ptpmsg_irq->num, NULL,
 				    ksz_ptp_msg_thread_fn, IRQF_ONESHOT,
 				    ptpmsg_irq->name, ptpmsg_irq);
@@ -1135,9 +1135,6 @@ int ksz_ptp_irq_setup(struct dsa_switch
 	if (!ptpirq->domain)
 		return -ENOMEM;
 
-	for (irq = 0; irq < ptpirq->nirqs; irq++)
-		irq_create_mapping(ptpirq->domain, irq);
-
 	ptpirq->irq_num = irq_find_mapping(port->pirq.domain, PORT_SRC_PTP_INT);
 	if (!ptpirq->irq_num) {
 		ret = -EINVAL;
@@ -1159,12 +1156,11 @@ int ksz_ptp_irq_setup(struct dsa_switch
 
 out_ptp_msg:
 	free_irq(ptpirq->irq_num, ptpirq);
-	while (irq--)
+	while (irq--) {
 		free_irq(port->ptpmsg_irq[irq].num, &port->ptpmsg_irq[irq]);
-out:
-	for (irq = 0; irq < ptpirq->nirqs; irq++)
 		irq_dispose_mapping(port->ptpmsg_irq[irq].num);
-
+	}
+out:
 	irq_domain_remove(ptpirq->domain);
 
 	return ret;


