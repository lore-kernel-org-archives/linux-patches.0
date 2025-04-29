Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27747243964;
	Tue, 29 Apr 2025 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949885; cv=none; b=TRRXygBdbZSJeDwAtm0Nc+v4BPBdHHTt8tipTdUpg0bdmEEQC2sl0Fi40pPqlg1qxAfLn8x/yA8iQUOhn2mwr6SCjnLp6Ya1NNeS1SKOKp43p84HX2cPMRyh6gdoWyN90ZCXo76d7MrD91imPJ7wlmS9fm1+Rq4hPWl14viXE1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949885; c=relaxed/simple;
	bh=Efgw9k4aVj6GT2SBZiyN1Z3Lzh9cjhFTMCTUqwICswA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8sxKockkynoFI3NxMi+IWdrYdEyGLeUO4VOSlJlpiVB+P54nHHVxby/0aWh2CKzWfpJhjBDMhxD1MINIrbPofNbeCEU7uTOwVJsbjMHZikkg6q4heyqpBCpEQw5vxTCPP0XoIEQetXTLr7zewOfxw/5YqseytFHQbKCYJG1FTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTUDo0K8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTUDo0K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBEBC4CEE3;
	Tue, 29 Apr 2025 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949884;
	bh=Efgw9k4aVj6GT2SBZiyN1Z3Lzh9cjhFTMCTUqwICswA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTUDo0K8lYKQTL6Dtu1aom3Xn7UTTtdehlTBgiKHz58qhOfbwp6BHyhMLBRKt3Lhk
	 4NEJxev5CJCErrrG5lglatYRCEWNw3ja5KsMnEw9Xax4jSsXzah5nA6/tnUPB99sMl
	 ki6R5c1VKgIc5uUZNpVfm+adEFuDnfNy8Mx/oTK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 060/167] wifi: mac80211: export ieee80211_purge_tx_queue() for drivers
Date: Tue, 29 Apr 2025 18:42:48 +0200
Message-ID: <20250429161054.198648669@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

commit 53bc1b73b67836ac9867f93dee7a443986b4a94f upstream.

Drivers need to purge TX SKB when stopping. Using skb_queue_purge() can't
report TX status to mac80211, causing ieee80211_free_ack_frame() warns
"Have pending ack frames!". Export ieee80211_purge_tx_queue() for drivers
to not have to reimplement it.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240822014255.10211-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/mac80211.h     |   13 +++++++++++++
 net/mac80211/ieee80211_i.h |    2 --
 net/mac80211/status.c      |    1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2957,6 +2957,19 @@ ieee80211_get_alt_retry_rate(const struc
 void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 /**
+ * ieee80211_purge_tx_queue - purge TX skb queue
+ * @hw: the hardware
+ * @skbs: the skbs
+ *
+ * Free a set of transmit skbs. Use this function when device is going to stop
+ * but some transmit skbs without TX status are still queued.
+ * This function does not take the list lock and the caller must hold the
+ * relevant locks to use it.
+ */
+void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
+			      struct sk_buff_head *skbs);
+
+/**
  * DOC: Hardware crypto acceleration
  *
  * mac80211 is capable of taking advantage of many hardware
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1984,8 +1984,6 @@ void __ieee80211_subif_start_xmit(struct
 				  u32 info_flags,
 				  u32 ctrl_flags,
 				  u64 *cookie);
-void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
-			      struct sk_buff_head *skbs);
 struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags);
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1294,3 +1294,4 @@ void ieee80211_purge_tx_queue(struct iee
 	while ((skb = __skb_dequeue(skbs)))
 		ieee80211_free_txskb(hw, skb);
 }
+EXPORT_SYMBOL(ieee80211_purge_tx_queue);


