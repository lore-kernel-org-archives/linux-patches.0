Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6EA233952;
	Sat, 30 May 2026 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167059; cv=none; b=ikte4Se2UaPdpALJjQJi0D6CWPA2qZaIHjbLfABOsfEU57/bjRq8aihgXAa9xY/wopTpDYxRsaQ/78NKX2iVlpx8nsV+Hatjw2+S2HZ7IgeAaB+ldJWI1Lxndz3wjOI/4BmpbMnWidio1+Whino3H6jM4U4CuF1RWlZ/9bNHda0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167059; c=relaxed/simple;
	bh=x6OU6Q+XuteVbYkpei0dpuU8Da11Hw2qRhnx4TvYdp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTUDfSgUvQr/vcEnb/nCQC14BHgPKT+E4uxXqS+v6hBQgUqDLyNXjrxVweJnY8NND+YjH5AbXMLejoRV5eGtHgGa8Yn4BaYsEA9RL0gPDjYIUFS9RmMSbBKcvC1KpYdBMpR4uyl/Rf6ue2vNWrEBiLxiJyVYP4jk8rjV5tEd8FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/4oUJxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/4oUJxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8ED1F00893;
	Sat, 30 May 2026 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167057;
	bh=eur3NQ/Gf41OgTTCFUJOwlkmQevgv/FU29dYbrsttQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r/4oUJxViuJPzvIgr2GvX3EWi4ENd2ziQFHYouGf+HYpV1wfq5h/gZffWlCT13OrN
	 yfG/4G72hY54yqn+PC5a9PR16HCORLGEf1iHbRjE1fciMUcg4WS1L/k2q77+KeEXXc
	 dLdjSsgCF+IgFCoNa5KrhQ6IAqE45Kh8LtjFAbaA=
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
Subject: [PATCH 5.10 552/589] batman-adv: dat: handle forward allocation error
Date: Sat, 30 May 2026 18:07:13 +0200
Message-ID: <20260530160239.170877241@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 2d8826a2d3657cea66fb0370f9e521575a673871 upstream.

batadv_dat_forward_data() calls pskb_copy_for_clone() to duplicate an skb
for each DHT candidate, but does not check the return value before passing
it to batadv_send_skb_prepare_unicast_4addr(). That function dereferences
the skb unconditionally, so a failed allocation triggers a NULL pointer
dereference.

Skip forwarding to the current DHT candidate on allocation failure.

Cc: stable@kernel.org
Fixes: 785ea1144182 ("batman-adv: Distributed ARP Table - create DHT helper functions")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reviewed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -701,6 +701,9 @@ static bool batadv_dat_forward_data(stru
 			goto free_orig;
 
 		tmp_skb = pskb_copy_for_clone(skb, GFP_ATOMIC);
+		if (!tmp_skb)
+			goto free_neigh;
+
 		if (!batadv_send_skb_prepare_unicast_4addr(bat_priv, tmp_skb,
 							   cand[i].orig_node,
 							   packet_subtype)) {


