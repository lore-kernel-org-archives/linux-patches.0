Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535B724DCF6;
	Mon, 13 Apr 2026 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096277; cv=none; b=I5UFxN0S6KR6Qq8FYowVjWjp+Dzu/mFagigzud22igaem75FVED1FRQhH0tZrEpWjIQY+lNincfKZd200vSv8OQd7DlBun2W0nY+ZHWmVig2tiIUopoQrAczqBJ3wkDrrEK5gOXx7OeklWutgvI9bMStS98P/oV656p++Y/NL9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096277; c=relaxed/simple;
	bh=vkGmgRx9ZIctwGKk9vLJlSiwTrV/zVi+JVjukK63i3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1Dfr1okKQBU5T12GrBC/DCpE28XgUDeTid8eWt/2RtQXARiTMV+Ad2OMMhN2OfSZ1v+ZlC+Aj6j7XwnsxQunS5KENwhUbbzLZpTFJBUg6Lt5At3iNaqb7NFWkYhQ7aKGQ6EccsM5wy7c+5whOZ9bCkZEAYEIaPzBjNo17Tx83A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP8JzWsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP8JzWsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FF2C2BCAF;
	Mon, 13 Apr 2026 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096277;
	bh=vkGmgRx9ZIctwGKk9vLJlSiwTrV/zVi+JVjukK63i3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SP8JzWslMklITpo0SvHONF/IuQuzyjG7ETbx7nGGULKqbZY9k+GD+KZzMxK30Syzl
	 YrU0W8A+O6U0JLRzwPXGlY+L4WA39mcBPyBMgVUNUIzX9+rl90qPHbU/ymo2BzhkFC
	 5sPaM3nRxRLHKJXb9QjH+WCZDFtEBcQi85bZ4RwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 09/86] seg6: separate dst_cache for input and output paths in seg6 lwtunnel
Date: Mon, 13 Apr 2026 17:59:16 +0200
Message-ID: <20260413155731.921610738@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

From: Andrea Mayer <andrea.mayer@uniroma2.it>

commit c3812651b522fe8437ebb7063b75ddb95b571643 upstream.

The seg6 lwtunnel uses a single dst_cache per encap route, shared
between seg6_input_core() and seg6_output_core(). These two paths
can perform the post-encap SID lookup in different routing contexts
(e.g., ip rules matching on the ingress interface, or VRF table
separation). Whichever path runs first populates the cache, and the
other reuses it blindly, bypassing its own lookup.

Fix this by splitting the cache into cache_input and cache_output,
so each path maintains its own cached dst independently.

Fixes: 6c8702c60b88 ("ipv6: sr: add support for SRH encapsulation and injection with lwtunnels")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260404004405.4057-2-andrea.mayer@uniroma2.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_iptunnel.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -48,7 +48,8 @@ static size_t seg6_lwt_headroom(struct s
 }
 
 struct seg6_lwt {
-	struct dst_cache cache;
+	struct dst_cache cache_input;
+	struct dst_cache cache_output;
 	struct seg6_iptunnel_encap tuninfo[];
 };
 
@@ -488,7 +489,7 @@ static int seg6_input_core(struct net *n
 	slwt = seg6_lwt_lwtunnel(lwtst);
 
 	local_bh_disable();
-	dst = dst_cache_get(&slwt->cache);
+	dst = dst_cache_get(&slwt->cache_input);
 	local_bh_enable();
 
 	err = seg6_do_srh(skb, dst);
@@ -504,7 +505,7 @@ static int seg6_input_core(struct net *n
 		/* cache only if we don't create a dst reference loop */
 		if (!dst->error && lwtst != dst->lwtstate) {
 			local_bh_disable();
-			dst_cache_set_ip6(&slwt->cache, dst,
+			dst_cache_set_ip6(&slwt->cache_input, dst,
 					  &ipv6_hdr(skb)->saddr);
 			local_bh_enable();
 		}
@@ -564,7 +565,7 @@ static int seg6_output_core(struct net *
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
 	local_bh_disable();
-	dst = dst_cache_get(&slwt->cache);
+	dst = dst_cache_get(&slwt->cache_output);
 	local_bh_enable();
 
 	err = seg6_do_srh(skb, dst);
@@ -591,7 +592,7 @@ static int seg6_output_core(struct net *
 		/* cache only if we don't create a dst reference loop */
 		if (orig_dst->lwtstate != dst->lwtstate) {
 			local_bh_disable();
-			dst_cache_set_ip6(&slwt->cache, dst, &fl6.saddr);
+			dst_cache_set_ip6(&slwt->cache_output, dst, &fl6.saddr);
 			local_bh_enable();
 		}
 
@@ -701,11 +702,13 @@ static int seg6_build_state(struct net *
 
 	slwt = seg6_lwt_lwtunnel(newts);
 
-	err = dst_cache_init(&slwt->cache, GFP_ATOMIC);
-	if (err) {
-		kfree(newts);
-		return err;
-	}
+	err = dst_cache_init(&slwt->cache_input, GFP_ATOMIC);
+	if (err)
+		goto err_free_newts;
+
+	err = dst_cache_init(&slwt->cache_output, GFP_ATOMIC);
+	if (err)
+		goto err_destroy_input;
 
 	memcpy(&slwt->tuninfo, tuninfo, tuninfo_len);
 
@@ -720,11 +723,20 @@ static int seg6_build_state(struct net *
 	*ts = newts;
 
 	return 0;
+
+err_destroy_input:
+	dst_cache_destroy(&slwt->cache_input);
+err_free_newts:
+	kfree(newts);
+	return err;
 }
 
 static void seg6_destroy_state(struct lwtunnel_state *lwt)
 {
-	dst_cache_destroy(&seg6_lwt_lwtunnel(lwt)->cache);
+	struct seg6_lwt *slwt = seg6_lwt_lwtunnel(lwt);
+
+	dst_cache_destroy(&slwt->cache_input);
+	dst_cache_destroy(&slwt->cache_output);
 }
 
 static int seg6_fill_encap_info(struct sk_buff *skb,


