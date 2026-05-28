Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9799A282F17;
	Thu, 28 May 2026 20:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999656; cv=none; b=pNFUYcxPSIld/Hi+I6epZ5Ppawkn7NrWcr52SDPBWeV+1TnUHbly3Hmfait6VVJ0qvcF4uKWW3ZH/YLptZ4U/FY+Jd33SgUmsG51jcSfJ3pNYc3I+xx1VNehZ/HlMpxxGS9Q+rpFdzC+Vymn1pCF3MqgM5YoZ+oDsr4egsmf8lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999656; c=relaxed/simple;
	bh=1agjIXgix8wf5lw5X2lJV9DTVSTN5R7H5IZh5R0kyPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioGBlStg3cjfTi1EKjlyye6Fb9SpOVyFvh61y2d4R55OzNNnTd49Ajz5rC7oMKRG+l+RnSI+AS0ViV86/eHmHF0vzgF93kSgzuKa1MPJZ/wuskwLesO7qjKx+5D752QbQEXPvh65QoEQtyS+YaWPTTRe6og24zTYc6f2SJoBHPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNqdjpb4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNqdjpb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087B71F000E9;
	Thu, 28 May 2026 20:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999655;
	bh=m4hDkoxlnVbB4FYzyGS+1NHLsvEgUN/UZW/IOjuG5QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNqdjpb4GM3RVdMG5OYYnQBxgLyk4BEcjS6AAkeqLvLJTDqT/9QlFhpCdIo201UiQ
	 hdUg2vW/IEcKk2I+VzohPgG6peQv81y+VN8cgvpGgTmkGZCUb8A5rAKFwCptyfJUdv
	 nrZAqvSuR/0o5oRAe/6WpmG+GozYYy+YxlktiXp4=
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
Subject: [PATCH 6.18 143/377] batman-adv: dat: handle forward allocation error
Date: Thu, 28 May 2026 21:46:21 +0200
Message-ID: <20260528194642.515607876@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -697,6 +697,9 @@ static bool batadv_dat_forward_data(stru
 			goto free_orig;
 
 		tmp_skb = pskb_copy_for_clone(skb, GFP_ATOMIC);
+		if (!tmp_skb)
+			goto free_neigh;
+
 		if (!batadv_send_skb_prepare_unicast_4addr(bat_priv, tmp_skb,
 							   cand[i].orig_node,
 							   packet_subtype)) {


