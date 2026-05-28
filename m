Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2875318B9D;
	Thu, 28 May 2026 20:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001305; cv=none; b=dC6BIpBJdhEuR15tFxKtDGUHhL39VHepqKbF3SI5CJiC9uhLun4+cDqFmJlGXyUPElkb+OPd7IFuj41MMjwt8b+7faG/dbGahBW1MAzEC3Gtw6BHBojK2gTTr4XPOQmGqEQXVbYQetQv9pJMCP2vhHIKrnkrAQ8WM5Xky6rxmJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001305; c=relaxed/simple;
	bh=dEssjDNbkCeRm/B3EyukvGqDXRmWw5t359IMcPIEzWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFaLcUurLedzNxhYagvcaAdyfVb3GXyC/9I/eG4kJpCpez2fb1kxipTg5BRxv4pVyHOxvPOcHnVZ6rB8TKeD+cUUzSiKPpCvF/w0RG4QLTXi6KwgIwjEG55/P3lRGNR/49Z/oxWuATFgA0pv6MEA9NfniICBVOcEnkke2ZtEt9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNiRrJq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNiRrJq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1CA1F00A3A;
	Thu, 28 May 2026 20:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001304;
	bh=pEzYoGEbi/6z9rrsm1ER/oaOuu1Pwd/vUYv+WDwvM/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNiRrJq+ZsRzu+exc4MjXab+iIexKMyzkgsgiDPBx0YyeX3uZyWW6TKIlvlvl2VVn
	 8VGgk3M6D+AvEh4MyupBoVZ2XsHIt97o1oHPYuLRIsgVWfZ4f4GiGkZOn7xBfSIiKH
	 PsmcODxhpDQ9Q65J28cLm6Lw6eCACDgC7DxqZMNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 081/186] batman-adv: frag: disallow unicast fragment in fragment
Date: Thu, 28 May 2026 21:49:21 +0200
Message-ID: <20260528194931.123663030@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit bc62216dc8e221e3781afa14430f45208bfa9af9 upstream.

batadv_frag_skb_buffer() is called by batadv_batman_skb_recv() when a
BATADV_UNICAST_FRAG packet is received. Once all fragments are collected
and the packet is reassembled, batadv_recv_frag_packet() calls
batadv_batman_skb_recv() again to process the defragmented payload.

A malicious sender can craft a BATADV_UNICAST_FRAG packet whose reassembled
payload is itself a BATADV_UNICAST_FRAG packet (matryoshka-style nesting).
Each nesting level recurses through batadv_batman_skb_recv() without bound,
growing the kernel stack until it is exhausted.

Since refragmentation or fragments in fragments are not actually allowed,
discard all packets which are still BATADV_UNICAST_FRAG packets after the
defragmentation process.

Cc: stable@kernel.org
Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reviewed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -306,6 +306,31 @@ free:
 }
 
 /**
+ * batadv_skb_is_frag() - check if newly merged skb is gain a unicast packet
+ * @skb: newly merged skb
+ *
+ * Return: if newly skb is of type BATADV_UNICAST_FRAG
+ */
+static bool batadv_skb_is_frag(struct sk_buff *skb)
+{
+	struct batadv_ogm_packet *batadv_ogm_packet;
+
+	/* packet should hold at least type and version */
+	if (unlikely(!pskb_may_pull(skb, 2)))
+		return false;
+
+	batadv_ogm_packet = (struct batadv_ogm_packet *)skb->data;
+
+	if (batadv_ogm_packet->version != BATADV_COMPAT_VERSION)
+		return false;
+
+	if (batadv_ogm_packet->packet_type != BATADV_UNICAST_FRAG)
+		return false;
+
+	return true;
+}
+
+/**
  * batadv_frag_skb_buffer() - buffer fragment for later merge
  * @skb: skb to buffer
  * @orig_node_src: originator that the skb is received from
@@ -338,6 +363,16 @@ bool batadv_frag_skb_buffer(struct sk_bu
 	if (!skb_out)
 		goto out_err;
 
+	/* fragment in fragment is not allowed. otherwise it is possible
+	 * to exhaust the stack when receiving a matryoshka-style
+	 * "fragments in a fragment packet"
+	 */
+	if (batadv_skb_is_frag(skb_out)) {
+		kfree_skb(skb_out);
+		skb_out = NULL;
+		goto out_err;
+	}
+
 out:
 	ret = true;
 out_err:


