Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C773BED02;
	Mon, 23 Mar 2026 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278942; cv=none; b=jnfklRQ7Y2n+oRaB4xULfoE4SM1e+3qMX77c/lObEUAx4YVrO9Tvevgtk6irIJpxqVJuY2jscDFx/HpWbBc+N4FuUxxMJbaNZRAZOdGMATmmHkiIYwpDPm93p84tM+9dpdCwV8KushtjYQuWuSz/FfF3q5COUHX/9v3nMp7AHbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278942; c=relaxed/simple;
	bh=t+6Vroif82shphfeskDCML8IqVFzP2e4588+H/28YvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pct0O16uA+y11RJQtE1beP6t5vB1L5ahpVu/4P79JkdmJkTa1WokMRJgj75UbbY9olSWCXYOt5lIUf3dT48/8nH2ILoJ6Jsa4MXsfdBqyZBt00tSwmReyFKnxBZQLdZ7Na+3XAxYVoJIpc4Zx6RVKLLkNro2IuA25e8pPoYtrHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajxgOzTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajxgOzTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C02C2BC9E;
	Mon, 23 Mar 2026 15:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278942;
	bh=t+6Vroif82shphfeskDCML8IqVFzP2e4588+H/28YvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajxgOzTr2HMlxoCjSo3hoDHVCar5rjHHUjMXxA/7dheei/6Qun9NT4B7hhJ0h0YA5
	 hrmkwg/lEQ1SJmoS8ksbLbZKd9yLYEwzEOwphPjYyMnavCWy/EYzI/7H+S/m0QuaWl
	 U3ubdeMbgGAlt/QMQ1JnTfkdC2jqSZP5kCRxV6EQ=
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
Subject: [PATCH 6.6 469/567] batman-adv: avoid OGM aggregation when skb tailroom is insufficient
Date: Mon, 23 Mar 2026 14:46:29 +0100
Message-ID: <20260323134545.589783796@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
 


