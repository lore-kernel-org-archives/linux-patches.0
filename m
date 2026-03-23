Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CC93A6B88;
	Mon, 23 Mar 2026 13:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273815; cv=none; b=oSS4khJsQM9jmJFzJMqRlKD6EdK0RzNfiXvfnPrKw+GzbtkS83nLDofU1/+SptMAMBpwVjBocQF7ixCIcuYPbQV0npHQkPSW7MbomZ46+ZKkaJ7m8KbFySjDKoAWIUpsMiUNB1ZoIacj1LlVILfp6T6a5woWzROgnjyeRhQzAwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273815; c=relaxed/simple;
	bh=o3SPENsHpovwIKqg1GMB9J+Ce53eW4VHonOyHQLKxmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egw0pM4SG9c4Hwk8Fiq9PzZiHBwbvD9sHg1F/7XynE+dgoq7vQbc34I2X2pL8DXWBVsf0dfkBkqh19lSGKiZhMoMPERfshPoqrd9nrQZ37HoXZBp3v39XV526z4ZGTbK2lE1rsH8s2FayT64ZDd2i6UE758pLLIVV2F97GH0/kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oI+x+0XV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oI+x+0XV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE874C4CEF7;
	Mon, 23 Mar 2026 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273815;
	bh=o3SPENsHpovwIKqg1GMB9J+Ce53eW4VHonOyHQLKxmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oI+x+0XVHnK/dHmGtku0v5Zar7s+hu45dSDmk/sajhMB/+nMyXPUJ1g/WJ9WoT7Cm
	 SC+mz6nE2cFBS6DZp0qoml3IeUKEeDPLo4xat3JO9rHA8EmKh4954CofIg9Q/0GOSd
	 Ohr9gdzct17GHSBir0m/No4IC/kwOxJ71VnV5liM=
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
Subject: [PATCH 6.19 018/220] batman-adv: avoid OGM aggregation when skb tailroom is insufficient
Date: Mon, 23 Mar 2026 14:43:15 +0100
Message-ID: <20260323134505.155897309@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -473,6 +473,9 @@ batadv_iv_ogm_can_aggregate(const struct
 	if (aggregated_bytes > max_bytes)
 		return false;
 
+	if (skb_tailroom(forw_packet->skb) < packet_len)
+		return false;
+
 	if (packet_num >= BATADV_MAX_AGGREGATION_PACKETS)
 		return false;
 


