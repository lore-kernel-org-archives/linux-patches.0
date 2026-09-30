Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876863749EB;
	Wed, 30 Sep 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788584; cv=none; b=Cgdcpv9gZWpeobLTJkZl4Pq2sVTmJ3KMYorgRkdkilMBfbwmS4wTVAYyW+PCqcMFO7LhMewe67aqpCVGTQ5LBnWd3cYpGPSYs4zIGbH3XJkrhLQJ3CeyA6mP23MeMb4pZro8B8mGN7L20MWIfXMKXb4+OWIsnZ4+OeEsIZxCLwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788584; c=relaxed/simple;
	bh=3M9iXope4jrpWB+GWR3i8Fikt+LsCeQAje58AmeOa8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYuKEZ31AiqMQ/ROZM32pG33o5xWOcbygzshwI96NR6d5GXm8tfSEqRqxks9waBl62II48Csz2CObTFCWBNYnh7kX5htvyo1HlnKCwMcGwCnxnNgVWa6MA/uKHv6fpmCkRm3mpT/jxL6HQOvilVK9u8tB+B5KA6btAQjj8ngE5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mp/rk77M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mp/rk77M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E801F000FF;
	Wed, 30 Sep 2026 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788583;
	bh=0KbY86g1crQjS5R/Yxrt2ECPsRveajP2r/HHUPyeEnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mp/rk77M/iIVnEOhv1GhsEkzv5EXXH6Ad+I1LyKU9H6F5B5aCuOD5ukFI6D35rSfx
	 hdXADLcr9dva8Yn0ANOhRteGx9dnK4r1JTtH09tJrMiYVGPPkHe0BNbTuNdVhvB/BY
	 IG/8mP2tTiDPQGSJJeTrajW2H/KWiRTqMQqX0zsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Wyatt Feng <wf.kernel.dev@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 177/877] net: xfrm: reject unrepresentable espintcp transport headers
Date: Wed, 30 Sep 2026 17:18:08 +0200
Message-ID: <20260930152418.548589302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Wyatt Feng <wf.kernel.dev@gmail.com>

commit 96f01b53c2d05e003b040892256de54a586e8529 upstream.

ESP-in-TCP can hand xfrm packets whose transport header offset no longer
fits after the stream parser trims the TCP envelope. The plain transport
header reset truncates that offset and triggers the skb warning path.

Use the careful transport-header helper and drop the skb through the
existing XFRM error path when the offset cannot be represented.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <wf.kernel.dev@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/espintcp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -33,7 +33,11 @@ static void handle_esp(struct sk_buff *s
 {
 	struct tcp_skb_cb *tcp_cb = (struct tcp_skb_cb *)skb->cb;
 
-	skb_reset_transport_header(skb);
+	if (!skb_reset_transport_header_careful(skb)) {
+		XFRM_INC_STATS(sock_net(sk), LINUX_MIB_XFRMINERROR);
+		kfree_skb(skb);
+		return;
+	}
 
 	/* restore IP CB, we need at least IP6CB->nhoff */
 	memmove(skb->cb, &tcp_cb->header, sizeof(tcp_cb->header));


