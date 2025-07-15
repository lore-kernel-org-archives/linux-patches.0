Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79BD2C327B;
	Tue, 15 Jul 2025 13:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585754; cv=none; b=WePRjmsx9l6r4Tlk8JMIn5lNTQFdORNBpCwU0wMhQXuMkVp9bhc53LVfj7PJejDpw45Sk3E/ZXbT/TS8baWhdJb8YfqjWxLDYbb921v+HMeUUQzhgykRHpgzjMuLJkyjZTaX22BNp8li8xL0ZxRAyC7KZk0Dc3OwrWhsOcGBvqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585754; c=relaxed/simple;
	bh=Y3OTkROKAE0tSuJyIAD+5RPjbQJQxGudLHQjy1lV0YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtKrEbgu6f1TaZ7MvDg8RAk/PpLQlMZ5l98ozOpt5XHsUR6IryMf2wZ1IYJ25VEnkVjJ7W+FzBD1utM1MVZp5veff7ELyynNJvO7+/iijREt8eLWFOUp8x4lmVE1mFsR3LZO2/wVR0IZyZjgMQFtJfGDUsrkFlDee6nGCrz2mxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwl+bC8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwl+bC8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ECAC4CEE3;
	Tue, 15 Jul 2025 13:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585754;
	bh=Y3OTkROKAE0tSuJyIAD+5RPjbQJQxGudLHQjy1lV0YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwl+bC8RmwOk0Ro+HT7QkXtRCsU+PnNVuAVWAnI30x+W05Bl3WDkNHs85YBtJ3wR9
	 f5BA3SJxS+wlvesSXM01IoEvlM2eLXTFHi4ktA8fqfS4DhugPttxeeghBxI+STL56c
	 mnpGND32A1qqNAPM5Qzx1/Fag/HAPHObcY1sPtbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 160/163] net: wangxun: revert the adjustment of the IRQ vector sequence
Date: Tue, 15 Jul 2025 15:13:48 +0200
Message-ID: <20250715130815.251969582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit e37546ad1f9b2c777d3a21d7e50ce265ee3dece8 upstream.

Due to hardware limitations of NGBE, queue IRQs can only be requested
on vector 0 to 7. When the number of queues is set to the maximum 8,
the PCI IRQ vectors are allocated from 0 to 8. The vector 0 is used by
MISC interrupt, and althrough the vector 8 is used by queue interrupt,
it is unable to receive packets. This will cause some packets to be
dropped when RSS is enabled and they are assigned to queue 8.

So revert the adjustment of the MISC IRQ location, to make it be the
last one in IRQ vectors.

Fixes: 937d46ecc5f9 ("net: wangxun: add ethtool_ops for channel number")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20250701063030.59340-3-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c     |   16 ++++++++--------
 drivers/net/ethernet/wangxun/libwx/wx_type.h    |    2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c   |    2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h   |    2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c  |    4 ++--
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h |    4 ++--
 6 files changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1624,7 +1624,7 @@ static void wx_set_num_queues(struct wx
  */
 static int wx_acquire_msix_vectors(struct wx *wx)
 {
-	struct irq_affinity affd = { .pre_vectors = 1 };
+	struct irq_affinity affd = { .post_vectors = 1 };
 	int nvecs, i;
 
 	/* We start by asking for one vector per queue pair */
@@ -1661,16 +1661,17 @@ static int wx_acquire_msix_vectors(struc
 		return nvecs;
 	}
 
-	wx->msix_entry->entry = 0;
-	wx->msix_entry->vector = pci_irq_vector(wx->pdev, 0);
 	nvecs -= 1;
 	for (i = 0; i < nvecs; i++) {
 		wx->msix_q_entries[i].entry = i;
-		wx->msix_q_entries[i].vector = pci_irq_vector(wx->pdev, i + 1);
+		wx->msix_q_entries[i].vector = pci_irq_vector(wx->pdev, i);
 	}
 
 	wx->num_q_vectors = nvecs;
 
+	wx->msix_entry->entry = nvecs;
+	wx->msix_entry->vector = pci_irq_vector(wx->pdev, nvecs);
+
 	return 0;
 }
 
@@ -2120,7 +2121,6 @@ static void wx_set_ivar(struct wx *wx, s
 		wr32(wx, WX_PX_MISC_IVAR, ivar);
 	} else {
 		/* tx or rx causes */
-		msix_vector += 1; /* offset for queue vectors */
 		msix_vector |= WX_PX_IVAR_ALLOC_VAL;
 		index = ((16 * (queue & 1)) + (8 * direction));
 		ivar = rd32(wx, WX_PX_IVAR(queue >> 1));
@@ -2151,7 +2151,7 @@ void wx_write_eitr(struct wx_q_vector *q
 
 	itr_reg |= WX_PX_ITR_CNT_WDIS;
 
-	wr32(wx, WX_PX_ITR(v_idx + 1), itr_reg);
+	wr32(wx, WX_PX_ITR(v_idx), itr_reg);
 }
 
 /**
@@ -2197,9 +2197,9 @@ void wx_configure_vectors(struct wx *wx)
 		wx_write_eitr(q_vector);
 	}
 
-	wx_set_ivar(wx, -1, 0, 0);
+	wx_set_ivar(wx, -1, 0, v_idx);
 	if (pdev->msix_enabled)
-		wr32(wx, WX_PX_ITR(0), 1950);
+		wr32(wx, WX_PX_ITR(v_idx), 1950);
 }
 EXPORT_SYMBOL(wx_configure_vectors);
 
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1136,7 +1136,7 @@ struct wx {
 };
 
 #define WX_INTR_ALL (~0ULL)
-#define WX_INTR_Q(i) BIT((i) + 1)
+#define WX_INTR_Q(i) BIT((i))
 
 /* register operations */
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -154,7 +154,7 @@ static void ngbe_irq_enable(struct wx *w
 	if (queues)
 		wx_intr_enable(wx, NGBE_INTR_ALL);
 	else
-		wx_intr_enable(wx, NGBE_INTR_MISC);
+		wx_intr_enable(wx, NGBE_INTR_MISC(wx));
 }
 
 /**
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -80,7 +80,7 @@
 				NGBE_PX_MISC_IEN_GPIO)
 
 #define NGBE_INTR_ALL				0x1FF
-#define NGBE_INTR_MISC				BIT(0)
+#define NGBE_INTR_MISC(A)			BIT((A)->num_q_vectors)
 
 #define NGBE_PHY_CONFIG(reg_offset)		(0x14000 + ((reg_offset) * 4))
 #define NGBE_CFG_LAN_SPEED			0x14440
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
@@ -21,7 +21,7 @@ void txgbe_irq_enable(struct wx *wx, boo
 	wr32(wx, WX_PX_MISC_IEN, TXGBE_PX_MISC_IEN_MASK);
 
 	/* unmask interrupt */
-	wx_intr_enable(wx, TXGBE_INTR_MISC);
+	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
 	if (queues)
 		wx_intr_enable(wx, TXGBE_INTR_QALL(wx));
 }
@@ -147,7 +147,7 @@ static irqreturn_t txgbe_misc_irq_thread
 		nhandled++;
 	}
 
-	wx_intr_enable(wx, TXGBE_INTR_MISC);
+	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
 	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
 }
 
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -264,8 +264,8 @@ struct txgbe_fdir_filter {
 #define TXGBE_DEFAULT_RX_WORK           128
 #endif
 
-#define TXGBE_INTR_MISC       BIT(0)
-#define TXGBE_INTR_QALL(A)    GENMASK((A)->num_q_vectors, 1)
+#define TXGBE_INTR_MISC(A)    BIT((A)->num_q_vectors)
+#define TXGBE_INTR_QALL(A)    (TXGBE_INTR_MISC(A) - 1)
 
 #define TXGBE_MAX_EITR        GENMASK(11, 3)
 


