Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D78D32FA1B;
	Wed,  3 Dec 2025 16:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779079; cv=none; b=ec0CwZ5KUsna0kOBzUAHmJbqteaFg9cZ7wcQuitzxTOgvk5dbhoPc85tJgidtbd6Kk76i1MvsEyF7in6K6m7Mt6k8Euu4W8FbJBdwnItpEkySwsK4ahJE0/jx29UBQGLjMxTSrTWVhfE2ab6P4QJFqA3AESGcyswjUWyB8SzuFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779079; c=relaxed/simple;
	bh=4dXsj+tBuUwb19PIxn825+arrKo427qhVqSSXZf5dSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VxRGnEt/Rtigr3nLGII+5MviYtsQ5pyWm1HkIU6XCPDvtpA4VrpkQjX8O8MtJ7BUyWlRHaK/fazkid/idFF10JNwPx0JOSNyxV9ntwHLPD1bSP1Pps6W5LYzGAhXbpHEWJIxwiwQNKGOyHqf3FZIiG9QT9hnPYZ/n+SJlHKhBpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJPfSc6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJPfSc6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C25C4CEF5;
	Wed,  3 Dec 2025 16:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779078;
	bh=4dXsj+tBuUwb19PIxn825+arrKo427qhVqSSXZf5dSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJPfSc6gSZxTEMUUdj3Rgi9m5psO4V7aM8F7S3RrCInJGYvQsuHcz/6IN+B3s+y7G
	 vnSnWsjvoBsSGlaxaF0HYO6LqVlNmnNGyh7ufwoXHYpXnSqIN7tdAcQXesWeF3vDo0
	 cTi93gRgsOVOpqOuoZ57glJ/X1bbL3NxJTGAyYVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/568] ice: Dont use %pK through printk or tracepoints
Date: Wed,  3 Dec 2025 16:22:31 +0100
Message-ID: <20251203152446.186095471@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 66ceb45b7d7e9673254116eefe5b6d3a44eba267 ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.
There are still a few users of %pK left, but these use it through seq_file,
for which its usage is safe.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250811-restricted-pointers-net-v5-1-2e2fdc7d3f2c@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c  |  2 +-
 drivers/net/ethernet/intel/ice/ice_trace.h | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9be88820b77c3..9a540b85756f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8609,7 +8609,7 @@ static int ice_create_q_channels(struct ice_vsi *vsi)
 		list_add_tail(&ch->list, &vsi->ch_list);
 		vsi->tc_map_vsi[i] = ch->ch_vsi;
 		dev_dbg(ice_pf_to_dev(pf),
-			"successfully created channel: VSI %pK\n", ch->ch_vsi);
+			"successfully created channel: VSI %p\n", ch->ch_vsi);
 	}
 	return 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_trace.h b/drivers/net/ethernet/intel/ice/ice_trace.h
index ae98d5a8ff60e..ab76d4bb9aea8 100644
--- a/drivers/net/ethernet/intel/ice/ice_trace.h
+++ b/drivers/net/ethernet/intel/ice/ice_trace.h
@@ -129,7 +129,7 @@ DECLARE_EVENT_CLASS(ice_tx_template,
 				   __entry->buf = buf;
 				   __assign_str(devname, ring->netdev->name);),
 
-		    TP_printk("netdev: %s ring: %pK desc: %pK buf %pK", __get_str(devname),
+		    TP_printk("netdev: %s ring: %p desc: %p buf %p", __get_str(devname),
 			      __entry->ring, __entry->desc, __entry->buf)
 );
 
@@ -157,7 +157,7 @@ DECLARE_EVENT_CLASS(ice_rx_template,
 				   __entry->desc = desc;
 				   __assign_str(devname, ring->netdev->name);),
 
-		    TP_printk("netdev: %s ring: %pK desc: %pK", __get_str(devname),
+		    TP_printk("netdev: %s ring: %p desc: %p", __get_str(devname),
 			      __entry->ring, __entry->desc)
 );
 DEFINE_EVENT(ice_rx_template, ice_clean_rx_irq,
@@ -181,7 +181,7 @@ DECLARE_EVENT_CLASS(ice_rx_indicate_template,
 				   __entry->skb = skb;
 				   __assign_str(devname, ring->netdev->name);),
 
-		    TP_printk("netdev: %s ring: %pK desc: %pK skb %pK", __get_str(devname),
+		    TP_printk("netdev: %s ring: %p desc: %p skb %p", __get_str(devname),
 			      __entry->ring, __entry->desc, __entry->skb)
 );
 
@@ -204,7 +204,7 @@ DECLARE_EVENT_CLASS(ice_xmit_template,
 				   __entry->skb = skb;
 				   __assign_str(devname, ring->netdev->name);),
 
-		    TP_printk("netdev: %s skb: %pK ring: %pK", __get_str(devname),
+		    TP_printk("netdev: %s skb: %p ring: %p", __get_str(devname),
 			      __entry->skb, __entry->ring)
 );
 
@@ -227,7 +227,7 @@ DECLARE_EVENT_CLASS(ice_tx_tstamp_template,
 		    TP_fast_assign(__entry->skb = skb;
 				   __entry->idx = idx;),
 
-		    TP_printk("skb %pK idx %d",
+		    TP_printk("skb %p idx %d",
 			      __entry->skb, __entry->idx)
 );
 #define DEFINE_TX_TSTAMP_OP_EVENT(name) \
-- 
2.51.0



