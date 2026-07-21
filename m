Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5DF43E4B9;
	Tue, 21 Jul 2026 22:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672411; cv=none; b=RyZSXFrzyVu3O+0c1hzBR7A+0lZoT4Qj12kDYnQy7t8RDslG+6DE2DIh3S3y3IIooAqt2/HWI6WmG7yenUL84wupTcvnIVjv1GFd3UcDJeX8VhBDSr1o8SSkKFv01po4CEbQGaWlRGcvdVkY3yBQ1CRHUgfUPo3YAbsGD08wOII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672411; c=relaxed/simple;
	bh=a6Zg+4LbRFimSkpfh9R2KlIhXJ94bxvB8nqMBJmMSSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjkaNQn+WANTgtqYZzM4fZjKB9WnJ3fVd8gTs8Ww0W9y4Z0z5fiH8+BEMmlRSMgsnKWnM4dZ+tUil7vR8qc3DP+tYak2RtuFGU4T72dlj7UWvxMNgdSnC3jZvYXMArRBDTLXpWTzV6DvXcEo8aRceVVVGiAsrq9DLWMlx+trJ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=al+QsE59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="al+QsE59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFB11F000E9;
	Tue, 21 Jul 2026 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672409;
	bh=6v1soF250f9YJ6Fp73qENJ2mTnmeXXPNZ8oJ74uTi64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=al+QsE59ucCdzKuTxS0UDAew8NklvP34eGKpfGV7V0OAScyf0OR61RmYp9uku5ojR
	 kpHwA/P2t7yA+4AqTWJxOJ0N6GdsGIyd9a1kRbikr6Hk18JmzpDusaf2HVUK+dcmuo
	 A1kS3EHJmYUtHfesBDHGH+wbqim3o8P/ui0DqHdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 587/843] batman-adv: gw: acquire ethernet header only after skb realloc
Date: Tue, 21 Jul 2026 17:23:42 +0200
Message-ID: <20260721152419.255210495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 77880a3be88d378d60cc1e8f8ec70430e2ed0518 upstream.

The pskb_may_pull() called by batadv_get_vid() could reallocate the buffer
behind the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

Cc: stable@vger.kernel.org
Fixes: 6c413b1c22a2 ("batman-adv: send every DHCP packet as bat-unicast")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/gateway_client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -692,12 +692,13 @@ bool batadv_gw_out_of_range(struct batad
 	struct batadv_gw_node *gw_node = NULL;
 	struct batadv_gw_node *curr_gw = NULL;
 	struct batadv_neigh_ifinfo *curr_ifinfo, *old_ifinfo;
-	struct ethhdr *ethhdr = (struct ethhdr *)skb->data;
+	struct ethhdr *ethhdr;
 	bool out_of_range = false;
 	u8 curr_tq_avg;
 	unsigned short vid;
 
 	vid = batadv_get_vid(skb, 0);
+	ethhdr = (struct ethhdr *)skb->data;
 
 	if (is_multicast_ether_addr(ethhdr->h_dest))
 		goto out;


