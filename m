Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3FA350D7F;
	Fri, 21 Nov 2025 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732578; cv=none; b=B4uS58sLNAtwCm6r8UNgIvGxuDALBwkgvJovt1gb+8dOrmS4YMQr9iFmsFyq81hL+t7h9Ve5M81sO0y3OD2Q5B95fD073qfC+4bCxkG3/TiIWisqQ6k1hax6xaBAYt4W6vTkMPoTZtuLp9Wazl6/p2Px1BrOgC0A7yxp/MmU9NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732578; c=relaxed/simple;
	bh=5mm+uI4GfcXZ6dVUp07W8FvZYByKzH1mJfahGyeZTsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fkLv0Jfjq5H/k2QXXDv+Q5lrBOis6IJYAidkNisJw0BhwyGlqpbSUFE+jroGJ9TrN8z7pgcjKP6Mt36MbYJs1+beXPf3jhDM4WTEU+8dtvJ4okWj0HgjKbqCikTDw61AOI9Oc44Ob/pj6NQ1/x8ZkRGsrecXqt6grz1aRYgvf/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLIZ5c6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLIZ5c6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52794C4CEF1;
	Fri, 21 Nov 2025 13:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732578;
	bh=5mm+uI4GfcXZ6dVUp07W8FvZYByKzH1mJfahGyeZTsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLIZ5c6TIOxQ37mxQfbggnm0iJYewWguoaVIiE5EmdrXO1LeZimck5j70/ztd9nXY
	 NdSKKrdG5IEvKsDu0E2nznJD0cADbSO4j4qGvbeYXKUjlgkQpwMDy4XE3yxa9Dx+fy
	 jp0RannQcJbP00zW9YiYVxcpLXTEW1gkZFHhWVEc=
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
Subject: [PATCH 6.6 137/529] ice: Dont use %pK through printk or tracepoints
Date: Fri, 21 Nov 2025 14:07:16 +0100
Message-ID: <20251121130235.893215587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e1a68fb5e9fff..e846246261b94 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8765,7 +8765,7 @@ static int ice_create_q_channels(struct ice_vsi *vsi)
 		list_add_tail(&ch->list, &vsi->ch_list);
 		vsi->tc_map_vsi[i] = ch->ch_vsi;
 		dev_dbg(ice_pf_to_dev(pf),
-			"successfully created channel: VSI %pK\n", ch->ch_vsi);
+			"successfully created channel: VSI %p\n", ch->ch_vsi);
 	}
 	return 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_trace.h b/drivers/net/ethernet/intel/ice/ice_trace.h
index b2f5c9fe01492..a41e210a310d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_trace.h
+++ b/drivers/net/ethernet/intel/ice/ice_trace.h
@@ -130,7 +130,7 @@ DECLARE_EVENT_CLASS(ice_tx_template,
 				   __entry->buf = buf;
 				   __assign_str(devname, ring->netdev->name);),
 
-		    TP_printk("netdev: %s ring: %pK desc: %pK buf %pK", __get_str(devname),
+		    TP_printk("netdev: %s ring: %p desc: %p buf %p", __get_str(devname),
 			      __entry->ring, __entry->desc, __entry->buf)
 );
 
@@ -158,7 +158,7 @@ DECLARE_EVENT_CLASS(ice_rx_template,
 				   __entry->desc = desc;
 				   __assign_str(devname, ring->netdev->name);),
 
-		    TP_printk("netdev: %s ring: %pK desc: %pK", __get_str(devname),
+		    TP_printk("netdev: %s ring: %p desc: %p", __get_str(devname),
 			      __entry->ring, __entry->desc)
 );
 DEFINE_EVENT(ice_rx_template, ice_clean_rx_irq,
@@ -182,7 +182,7 @@ DECLARE_EVENT_CLASS(ice_rx_indicate_template,
 				   __entry->skb = skb;
 				   __assign_str(devname, ring->netdev->name);),
 
-		    TP_printk("netdev: %s ring: %pK desc: %pK skb %pK", __get_str(devname),
+		    TP_printk("netdev: %s ring: %p desc: %p skb %p", __get_str(devname),
 			      __entry->ring, __entry->desc, __entry->skb)
 );
 
@@ -205,7 +205,7 @@ DECLARE_EVENT_CLASS(ice_xmit_template,
 				   __entry->skb = skb;
 				   __assign_str(devname, ring->netdev->name);),
 
-		    TP_printk("netdev: %s skb: %pK ring: %pK", __get_str(devname),
+		    TP_printk("netdev: %s skb: %p ring: %p", __get_str(devname),
 			      __entry->skb, __entry->ring)
 );
 
@@ -228,7 +228,7 @@ DECLARE_EVENT_CLASS(ice_tx_tstamp_template,
 		    TP_fast_assign(__entry->skb = skb;
 				   __entry->idx = idx;),
 
-		    TP_printk("skb %pK idx %d",
+		    TP_printk("skb %p idx %d",
 			      __entry->skb, __entry->idx)
 );
 #define DEFINE_TX_TSTAMP_OP_EVENT(name) \
-- 
2.51.0



