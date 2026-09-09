Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A297F57981A;
	Wed,  9 Sep 2026 14:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963622; cv=none; b=IwBXOiHGe+PU7jC6iyQHSI7Eo+ysF/81NtkEhXW9onsqzDUjOtNi+MeoUgeXQbjhFZpTl2de8/kkWhFh5LTABnnxRgWZq8vOoZPDOsaonwCZWn7sv6aqT9r4jSIxneipYp2EBNe5oLmtxweHngGfHkrI79vBXgNwGOTk8dRSxkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963622; c=relaxed/simple;
	bh=P+AMsul2e6uyHG3VX4Evok3I2jG6EPpjDnmjKJhn0mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chr5cr2Ty7oMiyWG9kPjQWN6+KXMUac5bkxG9SFVSgY4K1zGpIZwjF9yF2iLpCwl5Z3q2Ukz9i7YVB9xzpAshllH/nTv05ZMY66d6wDDXtS1B6PlhPMlo77xs39T3DjuU36dwGzshgwSGnVYWNng6bed/xoERRyAjOXhy7p2uVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQvNk4Sx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQvNk4Sx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA65E1F00A3A;
	Wed,  9 Sep 2026 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963621;
	bh=PaVCGmM5G3mSRbRZ5H1NUGRgeT3OTNJDbi7lmlrpKm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQvNk4SxjioEVHUxgVulizBjE96UN4OPtZHrfYstU1ECxlCnoJWk8c8vlrauiN0Tp
	 YfkhY1wG9l6ROgyLdiCIFVVqJmJNarPcyQENQ42PHf7fKlmRYR0naI2fQ3imzgIDKI
	 1NGrt6Hj0I8GAO2DMGJdj4GgvXNigUkFdHCfrHAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 142/583] batman-adv: mcast: linearize skbuff for packet generation
Date: Wed,  9 Sep 2026 15:37:07 +0200
Message-ID: <20260909134243.078089022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

commit 6a30a59e2660afd03c975f1b8eae6a2301161197 upstream.

batadv_mcast_forw_packet() and batadv_mcast_forw_scrape() is not only
called (indirectly) by the unsharing+linearizing batadv_recv_mcast_packet()
handler. When it is called (indirectly) by batadv_mcast_forw_mcsend() then
it will be unshared but not linearized. The SKB_LINEAR_ASSERT() can
therefore cause a fatal BUG().

The linearization should happen during the expansion of the head because
the scrape function can be hit already during the initial
batadv_mcast_forw_mode() selection code:

* batadv_interface_tx
* batadv_mcast_forw_mode
* batadv_mcast_forw_mode_by_count()
* batadv_mcast_forw_push()
  -> calls batadv_mcast_forw_expand_head() before everything else
* batadv_mcast_forw_push_tvlvs()
* batadv_mcast_forw_push_dests()
* batadv_mcast_forw_push_adjust_padding()
* batadv_mcast_forw_scrape()

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 90039133221e ("batman-adv: mcast: implement multicast packet generation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/multicast_forw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -1103,6 +1103,10 @@ static int batadv_mcast_forw_expand_head
 	if (skb_cow(skb, hdr_size) < 0)
 		return -ENOMEM;
 
+	/* batadv_mcast_forw_scrape() + batadv_mcast_forw_packet() require linearized skb */
+	if (skb_linearize(skb) < 0)
+		return -ENOMEM;
+
 	return 0;
 }
 


