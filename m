Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58B8446839;
	Tue, 21 Jul 2026 19:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663712; cv=none; b=DbhtHbdrnve+FNx/P6ukdfbEReDmcuWTCsIiTrYD8QvDJ8tLT0ItSsmFaPW0OIRmBNg2VIoftTf8pyjCywkdaZefGSz2P62uPx9z75xvAU0r9wMMnYs52aOtUyLgyCSy60w/587vbP+L/lmyp/5jwR1VsvE2JevnvrVa7QyZohY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663712; c=relaxed/simple;
	bh=XJ91R25OcFXnGFifzEyXknHxfiJ4W30s0N3Hv88TuGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBri5rX56JSQ+xVLdTmYgkSKiFM3X9Px3Qk/v8cPV5PtkUtW9x2wksZ+BOtM09Cp+LuyrEuElmx+FLCF4oh9si087OWoJ0ku4cMZHqqb4jVJkFVA1ce4DfLXYsR7Bj41fPPfRneRKL+ui21hbOUKjmVKhd6O6jv2beWFV9adCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/Z+uk+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/Z+uk+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B174D1F000E9;
	Tue, 21 Jul 2026 19:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663711;
	bh=WGRF1bxI50fM4+5bhZsYIkX6kEZFyhqLlHcGhYT7F5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/Z+uk+1oQHyuonT7DvBlnVEgSvuKjwHVH5i+Kf5ks3VwPyfTqtKs0HDTjBnG44Z1
	 ixo3fEVJSc3b1NZ8Wm4hVTxn4WzCXyNJW7b3gLd6ggeBwkxcqzmx1mQMVqjXMR93PC
	 QpNIfQKszQQmCammx9WUEp1qLMO0cxDPoUs8fy0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0882/1276] batman-adv: gw: acquire ethernet header only after skb realloc
Date: Tue, 21 Jul 2026 17:22:05 +0200
Message-ID: <20260721152505.788422916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -693,12 +693,13 @@ bool batadv_gw_out_of_range(struct batad
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


