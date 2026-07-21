Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B843471436;
	Tue, 21 Jul 2026 17:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656583; cv=none; b=XtK48YwATOLJXu8JU8Zell5shyJq7kNUpGnz84KHp4jEnYY4lsD3Xo3nJICIM9PY9ANpCDPQYN+pyVEf8zbVZDXBs3HdlqqzTvlNLAOhhKZFA5ShoIr/x0dpR7w2+MzWyLqYxOPFIbQ3B1Vsv/a9fe6ibzLdnDzIC5rFdnqLdP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656583; c=relaxed/simple;
	bh=EX95jPQktjhbFd3V3qq8WPeZLU2CqY6cV4k5643Sx2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apl+2PUuUB63b8cQtKNjlcXjSrv4IUi0yBEGA+1dhKCqHHK/ydtk60CPWWMbS4F12TdVw2PgKXe7cibhgj4i2MKd7Q7DdsZs3nr7WPnP75MzqTMfkkhglwL8o4KDxhnSaHub+HJg/EARmNPrY8yJGOylHNK+CofOdfau982tM6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRd9+rf+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRd9+rf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13A31F000E9;
	Tue, 21 Jul 2026 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656582;
	bh=VGFi57zkkD65dqJ6owo6KdWXffPKtooF78bveq5HsnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRd9+rf+FeT6OuGlmCjqi4U/sFatkPD1jScftmYnP4VyqGOk3dIB/f+q457HEyV/Q
	 VgDPCBYVwCY18+cYkPIws94Fl8TlMO6FiSesFqajzBmAGBZMIfT4Gov96klGXXxJBx
	 gOiZ2Ld5irWxsmCwNm2MTk3iQvRPeVM9ObX4BfKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0442/1611] vdpa/octeon_ep: fix IRQ-to-ring mapping in interrupt handler
Date: Tue, 21 Jul 2026 17:09:18 +0200
Message-ID: <20260721152525.232575048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



