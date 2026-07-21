Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CBF43B483;
	Tue, 21 Jul 2026 21:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669995; cv=none; b=kb9aEP9Yu+dbNbgX7mbvNWjcQyGJdSAe3hi/O+OPueOC5HAwRctgXQrXxpdXyy5GUWVzC5J2VBSKn3CdR4CWg2eP2UxrnxrbZeUjUneiPrHgM2C+E9rex+ZDF4LJyAAC0crwvgFcZWGtPuP8HXCKq+aRmPyPyLq/+r4w9MrdtNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669995; c=relaxed/simple;
	bh=MMGIRHVRp/xv8Ic9htlLDIjhSERAT5DAdV1F80OdZfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cE+MJEzZTDcliO88ZqwuUVmUp5IG2ZdI3ePAETdN1ys0V/WosEW/AGn2BXFyDWNayt9p+7k+12YQ0KO/pbqHa23BuEdD23YEMuZPJORexurtCUwE3H/w91IiYtEqHSwNz8aZ5nbXE1R5r3bbFkQQwKJ7Ypffv63YJbXPEv/sHxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7nj4WLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7nj4WLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482C31F00A3A;
	Tue, 21 Jul 2026 21:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669994;
	bh=s45RROGmZiBAgjV8iccRS0yXkQlt2YduwW3KV+FcYxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7nj4WLARD+Djo2bcl2prp1LVwnMRLzpEyQb6CmF+QhULpiahzY6E2stFG/VDHTqh
	 cG5ncVVVxgdPDPc+fWK7xNSnjNX6Eb/TYFLZGWj7eBC43rsOWowKWz2WPkrdmWeDWP
	 yHL++CBuPPHyBqxlPev/5D9Zem8O6SbsRuPiBatA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0765/1067] batman-adv: bla: reacquire gw address after skb realloc
Date: Tue, 21 Jul 2026 17:22:46 +0200
Message-ID: <20260721152441.686386937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit cdf3b5af2bc4431e58629e8ad2086b1e9185c761 upstream.

The pskb_may_pull() called by batadv_bla_is_backbone_gw() could reallocate
the buffer behind the skb. Variables which were pointing to the old buffer
need to be reassigned to avoid an use-after-free.

Cc: stable@vger.kernel.org
Fixes: 9e794b6bf4a2 ("batman-adv: drop unicast packets from other backbone gw")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1035,6 +1035,7 @@ int batadv_recv_unicast_packet(struct sk
 							  hdr_size);
 			batadv_orig_node_put(orig_node_gw);
 			if (is_gw) {
+				orig_addr_gw = eth_hdr(skb)->h_source;
 				batadv_dbg(BATADV_DBG_BLA, bat_priv,
 					   "%s(): Dropped unicast pkt received from another backbone gw %pM.\n",
 					   __func__, orig_addr_gw);


