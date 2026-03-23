Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF4238C1B;
	Mon, 23 Mar 2026 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277138; cv=none; b=axQJkztfbAYl1tvdocLkyTwe5l6wh/rt/7O3oqI/7MdYtNlWhBGeo6EHeIzmVJWzJeb3rq15tOYN82Ne0lLYzfmc+m8+UaZpBxpwyrEqIUrXF2st6wbStnBqbD8B5puPjvw82CO7KaUZA+GcJrAqo+A+d8nApYmywiO833K3rJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277138; c=relaxed/simple;
	bh=qaqlNXyd6Gddc+oQ+3Ju4tu2ac8AqsIer93luaawRAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXdTcNxUgC6I2NfaxnurraJWU8TgjgFAr5EAz/fUwoEgpay91lPT7CKLgW+0V3g7t9rIaFGj4qKhBYaU0WA9gGqKhCmS8hyQRVHkOwjFdiUs8p5ivyZlbSaDoxVWNXx66/61wP7USAQWTkzGewio15jdR26m1W1jiBZ9reg5eX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgqk5NZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgqk5NZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7316C4CEF7;
	Mon, 23 Mar 2026 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277138;
	bh=qaqlNXyd6Gddc+oQ+3Ju4tu2ac8AqsIer93luaawRAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgqk5NZ1AAOF9hI5xxMwCXxdohLo6jZOVypH9E0zxd9DQ4GWm6/qkZPl7twxKgOCv
	 /4Imx97fpoaAi24zlGWN9L5WgvHiLl58ySBdTBmnasgSzwFxIDQfepavP8G0dBEw9O
	 PkyyaCGaS9FfhFJT6oY+am8+z9FdjIBri5kjpvbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.12 331/460] batman-adv: avoid OGM aggregation when skb tailroom is insufficient
Date: Mon, 23 Mar 2026 14:45:27 +0100
Message-ID: <20260323134534.659499526@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Yang Yang <n05ec@lzu.edu.cn>

commit 0d4aef630be9d5f9c1227d07669c26c4383b5ad0 upstream.

When OGM aggregation state is toggled at runtime, an existing forwarded
packet may have been allocated with only packet_len bytes, while a later
packet can still be selected for aggregation. Appending in this case can
hit skb_put overflow conditions.

Reject aggregation when the target skb tailroom cannot accommodate the new
packet. The caller then falls back to creating a new forward packet
instead of appending.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ao Zhou <n05ec@lzu.edu.cn>
Signed-off-by: Yang Yang <n05ec@lzu.edu.cn>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ Adjust context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -464,6 +464,9 @@ batadv_iv_ogm_can_aggregate(const struct
 	    !time_after_eq(aggregation_end_time, forw_packet->send_time))
 		return false;
 
+	if (skb_tailroom(forw_packet->skb) < packet_len)
+		return false;
+
 	if (aggregated_bytes > BATADV_MAX_AGGREGATION_BYTES)
 		return false;
 


