Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E242C181;
	Mon, 23 Mar 2026 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275665; cv=none; b=ZwqQ/XDZe8GQ1aygS3QVuwYjlCfEOCA1Jde4o58DBRLn8kUBsea5pHbKLm80jlD0JxVeexDMBhS0g7jdO1ADHlaYq/TUNQ74Li9suYts1sDYb6Kp48XEC+I9TdxmOG3eyT3eYN75DL1WY9PQdMp5qa4Az/WpAdw10jtyYHlO9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275665; c=relaxed/simple;
	bh=JAlSIjyoYsnQYbDylN8wPoOU7Gr5+inuKzIdeUMG3HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGVqKc8kiXUT4CdQVxGceCaCOvofrbz1l/kLKfuhu3uYVRuGTzaiwuDbMznfkCmIcLO3PQ/GW+ubb2F/KQyhA7RvKiCiR01/msB9Eq8GeBE/eO3Tj97mnGILwlMhKVYxwpzsYzZ2oi+QkOeIHbnmxWPcKT0Qc1QCcgDhzBB4DZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQQdMmqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQQdMmqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B5CC4CEF7;
	Mon, 23 Mar 2026 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275665;
	bh=JAlSIjyoYsnQYbDylN8wPoOU7Gr5+inuKzIdeUMG3HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQQdMmqZZzHxmWuCQwY4PyW9u/3QjL6m7s6MuhTF8zZEd1gYEd85NGX8jKhTrZpbK
	 MPTNIX2JTrefx8TGPbkKuSpf2Uz585f93uKOZaYpMgo2LMkKEfmZGgc4beBMVYxabR
	 5BOSCB3TlZtcLpDuMoqswuXvftE4iqKElNCNhw4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 176/460] net: dsa: microchip: Fix error path in PTP IRQ setup
Date: Mon, 23 Mar 2026 14:42:52 +0100
Message-ID: <20260323134530.867346444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>

commit 99c8c16a4aad0b37293cae213e15957c573cf79b upstream.

If request_threaded_irq() fails during the PTP message IRQ setup, the
newly created IRQ mapping is never disposed. Indeed, the
ksz_ptp_irq_setup()'s error path only frees the mappings that were
successfully set up.

Dispose the newly created mapping if the associated
request_threaded_irq() fails at setup.

Cc: stable@vger.kernel.org
Fixes: d0b8fec8ae505 ("net: dsa: microchip: Fix symetry in ksz_ptp_msg_irq_{setup/free}()")
Signed-off-by: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260309-ksz-ptp-irq-fix-v1-1-757b3b985955@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_ptp.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -1101,6 +1101,7 @@ static int ksz_ptp_msg_irq_setup(struct
 	const struct ksz_dev_ops *ops = port->ksz_dev->dev_ops;
 	struct ksz_irq *ptpirq = &port->ptpirq;
 	struct ksz_ptp_irq *ptpmsg_irq;
+	int ret;
 
 	ptpmsg_irq = &port->ptpmsg_irq[n];
 	ptpmsg_irq->num = irq_create_mapping(ptpirq->domain, n);
@@ -1112,9 +1113,13 @@ static int ksz_ptp_msg_irq_setup(struct
 
 	snprintf(ptpmsg_irq->name, sizeof(ptpmsg_irq->name), name[n]);
 
-	return request_threaded_irq(ptpmsg_irq->num, NULL,
-				    ksz_ptp_msg_thread_fn, IRQF_ONESHOT,
-				    ptpmsg_irq->name, ptpmsg_irq);
+	ret = request_threaded_irq(ptpmsg_irq->num, NULL,
+				   ksz_ptp_msg_thread_fn, IRQF_ONESHOT,
+				   ptpmsg_irq->name, ptpmsg_irq);
+	if (ret)
+		irq_dispose_mapping(ptpmsg_irq->num);
+
+	return ret;
 }
 
 int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)


