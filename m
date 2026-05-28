Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1164134887B;
	Thu, 28 May 2026 20:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000663; cv=none; b=TugDdCh3snhTOYa04UZZojzTkyjpatjGpaYthRVylHc455TQmaio9vH57Lghvol3Hmoww+rc0aaYOlTV0MsSuB4FkizK68ZuOnBLONW4M5vgq/TJEYtPwREx1BwTCoI0ChbX6g7uHuHd9zHaLF1f85w+A0CBXE9I+h6tGJwPA4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000663; c=relaxed/simple;
	bh=ywjBL2Q3kBnorYPOaNRj2BJw8duSnhD/VxFGgZqOC14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdYXDaXFwxgRxL7BMcV3PP0gcEMuc76KsFQXAtdGj3Okv0t7+NsZpVIHgQEAdzNV9AgA6GEnMVSUThBh9vT4RTAHeidNF5jdB5s6YTBOVE6+Rcci61twyOG7mjr78yQ1t3lIZpeONki4EKzfq5YWUGgbV1RLmgs5zma3MydWsek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtPBkoke; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtPBkoke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261A21F000E9;
	Thu, 28 May 2026 20:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000661;
	bh=sgcSvI9Z2Yv+8sOXXLzPkLe8xgkb9un+oRP5CuYLC7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtPBkokeUIEFjoK/hXLNFIcobmbsFr+ftf8hUOXWkI7E0oV2aew3lXt4CNiZcjaIi
	 Cwug6GBX3k14Sg3Lz/Z5Grx124KpTppAjqpevwKXNkx9xWiAGotLLtyhfPTEG/XrYQ
	 hFnhPSl2uyicaQKFUJHzjxYndDw4zUJnvzAfsqPM=
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
Subject: [PATCH 6.12 123/272] batman-adv: dat: handle forward allocation error
Date: Thu, 28 May 2026 21:48:17 +0200
Message-ID: <20260528194632.822848331@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -698,6 +698,9 @@ static bool batadv_dat_forward_data(stru
 			goto free_orig;
 
 		tmp_skb = pskb_copy_for_clone(skb, GFP_ATOMIC);
+		if (!tmp_skb)
+			goto free_neigh;
+
 		if (!batadv_send_skb_prepare_unicast_4addr(bat_priv, tmp_skb,
 							   cand[i].orig_node,
 							   packet_subtype)) {


