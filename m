Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492B333E9;
	Fri, 24 Nov 2023 18:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uObAUoGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7BBC433C8;
	Fri, 24 Nov 2023 18:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850753;
	bh=QFZvCDmsTpKnAHPAzjhycSxoBEtEQjFxE3YlEBS7Srg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uObAUoGEBy/3SK6h2xfrtKZl6Ldg3peYeBpKp0Uo0O6TyKF0dVtiXNKkOUJii4G9L
	 QTaEjqfkK8LR4AG3auhpMPzaQD1nniuVGMZB1iINwo38qhr9GnWVB8F8f2uzxuppKE
	 +6RXLBtfxAuiEFBaU0qIzRV5jjUDAiwU7kHOhHOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 176/491] xen/events: avoid using info_for_irq() in xen_send_IPI_one()
Date: Fri, 24 Nov 2023 17:46:52 +0000
Message-ID: <20231124172029.762698456@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit e64e7c74b99ec9e439abca75f522f4b98f220bd1 ]

xen_send_IPI_one() is being used by cpuhp_report_idle_dead() after
it calls rcu_report_dead(), meaning that any RCU usage by
xen_send_IPI_one() is a bad idea.

Unfortunately xen_send_IPI_one() is using notify_remote_via_irq()
today, which is using irq_get_chip_data() via info_for_irq(). And
irq_get_chip_data() in turn is using a maple-tree lookup requiring
RCU.

Avoid this problem by caching the ipi event channels in another
percpu variable, allowing the use notify_remote_via_evtchn() in
xen_send_IPI_one().

Fixes: 721255b9826b ("genirq: Use a maple tree for interrupt descriptor management")
Reported-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index c803714d0f0d1..5de10d291a1cb 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -164,6 +164,8 @@ static DEFINE_PER_CPU(int [NR_VIRQS], virq_to_irq) = {[0 ... NR_VIRQS-1] = -1};
 
 /* IRQ <-> IPI mapping */
 static DEFINE_PER_CPU(int [XEN_NR_IPIS], ipi_to_irq) = {[0 ... XEN_NR_IPIS-1] = -1};
+/* Cache for IPI event channels - needed for hot cpu unplug (avoid RCU usage). */
+static DEFINE_PER_CPU(evtchn_port_t [XEN_NR_IPIS], ipi_to_evtchn) = {[0 ... XEN_NR_IPIS-1] = 0};
 
 /* Event channel distribution data */
 static atomic_t channels_on_cpu[NR_CPUS];
@@ -366,6 +368,7 @@ static int xen_irq_info_ipi_setup(unsigned cpu,
 	info->u.ipi = ipi;
 
 	per_cpu(ipi_to_irq, cpu)[ipi] = irq;
+	per_cpu(ipi_to_evtchn, cpu)[ipi] = evtchn;
 
 	return xen_irq_info_common_setup(info, irq, IRQT_IPI, evtchn, 0);
 }
@@ -981,6 +984,7 @@ static void __unbind_from_irq(unsigned int irq)
 			break;
 		case IRQT_IPI:
 			per_cpu(ipi_to_irq, cpu)[ipi_from_irq(irq)] = -1;
+			per_cpu(ipi_to_evtchn, cpu)[ipi_from_irq(irq)] = 0;
 			break;
 		case IRQT_EVTCHN:
 			dev = info->u.interdomain;
@@ -1631,7 +1635,7 @@ EXPORT_SYMBOL_GPL(evtchn_put);
 
 void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
 {
-	int irq;
+	evtchn_port_t evtchn;
 
 #ifdef CONFIG_X86
 	if (unlikely(vector == XEN_NMI_VECTOR)) {
@@ -1642,9 +1646,9 @@ void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
 		return;
 	}
 #endif
-	irq = per_cpu(ipi_to_irq, cpu)[vector];
-	BUG_ON(irq < 0);
-	notify_remote_via_irq(irq);
+	evtchn = per_cpu(ipi_to_evtchn, cpu)[vector];
+	BUG_ON(evtchn == 0);
+	notify_remote_via_evtchn(evtchn);
 }
 
 struct evtchn_loop_ctrl {
-- 
2.42.0



