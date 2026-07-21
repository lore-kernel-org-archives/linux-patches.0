Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0213C449B0B;
	Tue, 21 Jul 2026 15:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649600; cv=none; b=jCMqhtWnNTd4561koCoEe4zi0JP3JzNse3FKF1/llCdaavY9XDatf5VyYb/m9tpqByvW9/F8WQxqsJNGTgkiML0WWCUHomGzkMIR0tkuTnLVbf0wqQ6qg1gBolOAAQLXG6Re0uoKY5UpycI9SmGiLFe/suOMrBUH2YN8NVH78os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649600; c=relaxed/simple;
	bh=axYp4v0jf9DTHF0/aXHqo/6C3XjXypP7/nqZ+e55fNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJjsbP2kUSt3w6LdcCP8K2LZI6qR/mU3PNh4rg+28O8eKtIs0kWQLfCO0meCt4PoPbMeAEiipoweGyFWaOuqI0CQYT7z/+j4oad9GKU+ZXhBUOI0rszPK3YAxpbw0IK4kGbjxqbOw0ljtLOaslkSQK6IkTJnR5EtWbVc824OxbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ol0939eC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ol0939eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9351F000E9;
	Tue, 21 Jul 2026 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649598;
	bh=WRpYNKSwA2aUTTij0gjASiAa0JyOWXQ2z6XiC1F9aZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ol0939eC1NCYtHauZMdEJcTz1xo79uySgJmGNlgCVTmxxj10jc5dcuIuIJ1jrZt2f
	 REenSoBNtfTC9oKNlSb7yccBBmPMWFHkYhD88pGQSB1Bm/TWHRb6QrG5OBx+QmR4Ar
	 xg3nWrUk2qbTh3Q1L8LVFqo8tpLc3d9BvuiLPTAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0637/2077] vdpa/octeon_ep: fix IRQ-to-ring mapping in interrupt handler
Date: Tue, 21 Jul 2026 17:05:10 +0200
Message-ID: <20260721152607.832534741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 0d21a1d6375a05274291e32c1ab7cd57dbb69513 ]

Look up the IRQ index in oct_hw->irqs instead of assuming
irq - irqs[0]. This supports non-contiguous IRQ numbers and
avoids incorrect ring indexing when irqs[0] is not the base.

Fixes: 26f8ce06af64 ("vdpa/octeon_ep: enable support for multiple interrupts per device")
Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260224095226.1001151-5-schalla@marvell.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/octeon_ep/octep_vdpa_main.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/octeon_ep/octep_vdpa_main.c b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
index 9946480ee70460..df8af6c1454cce 100644
--- a/drivers/vdpa/octeon_ep/octep_vdpa_main.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
@@ -48,7 +48,7 @@ static struct octep_hw *vdpa_to_octep_hw(struct vdpa_device *vdpa_dev)
 static irqreturn_t octep_vdpa_intr_handler(int irq, void *data)
 {
 	struct octep_hw *oct_hw = data;
-	int i;
+	int i, start_ring_idx = -1;
 
 	/* Each device has multiple interrupts (nb_irqs) shared among rings
 	 * (nr_vring). Device interrupts are mapped to the rings in a
@@ -61,7 +61,16 @@ static irqreturn_t octep_vdpa_intr_handler(int irq, void *data)
 	 * 7 -> 7, 15, 23, 31, 39, 47, 55, 63;
 	 */
 
-	for (i = irq - oct_hw->irqs[0]; i < oct_hw->nr_vring; i += oct_hw->nb_irqs) {
+	for (i = 0; i < oct_hw->nb_irqs; i++) {
+		if (oct_hw->irqs[i] == irq) {
+			start_ring_idx = i;
+			break;
+		}
+	}
+	if (start_ring_idx == -1)
+		return IRQ_NONE;
+
+	for (i = start_ring_idx; i < oct_hw->nr_vring; i += oct_hw->nb_irqs) {
 		if (ioread8(oct_hw->vqs[i].cb_notify_addr)) {
 			/* Acknowledge the per ring notification to the device */
 			iowrite8(0, oct_hw->vqs[i].cb_notify_addr);
-- 
2.53.0



