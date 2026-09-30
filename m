Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0F53DDAFC;
	Wed, 30 Sep 2026 19:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796251; cv=none; b=mC7EnZ36JqDVi9Vlzqw1DjG9kZ17qvdwqr6z2Rjx9/OY0QUF+Gp5YU20hR6Y93LtLjVUmTOEGXlsgW1K6LrEpmaa5dD6d8LGADRe8q472FTGgAlDnV6MW58SVilktI94FLGcwZ6YVrOpUDVuKm3hyuN5hPJU8py2gNvaxuPdX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796251; c=relaxed/simple;
	bh=8oInQk3JYt7QxPm4XJPqxlSi7z2gYip9h1ymqCy8bdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYpx5l6t78mQEV4XJzbKWo1pxkGz55ajZRATkSJO07DHfo0BsvcA1wL3+wkzzZYlagSVfGQueTKOeGrWvxZxuf4/D8/cyysZZr3zJFEZquQDGuiOgmcC/O8i/Nkc3eeUczbnyrTTP+4CJT3L1CT6LPfM1tewSgmoo6Z6thb/Yi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mx64fqUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mx64fqUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D7C1F000FF;
	Wed, 30 Sep 2026 19:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796250;
	bh=JjisYUIaiVAKVU81F9zZWP10AIj1DqSf2BWDQWwnKBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mx64fqUOTDdHDWpXWD6L3c+WtoINkMVu9hM1T33W3gdarveuqHesL/VtaM8amOMaY
	 4RMfc65wxzRSJrZtM59aRZZ///Bq4zn9/W+kqsLiAL1sO2SORJL2yMOf+Y0rlpa5Je
	 F6t2cm4VTmASdhAFX9VjMv5Z82H4LzMJbBTrGFM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Wyatt Feng <wf.kernel.dev@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.6 0845/1193] net: xfrm: reject unrepresentable espintcp transport headers
Date: Wed, 30 Sep 2026 17:25:29 +0200
Message-ID: <20260930152453.013029414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -32,7 +32,11 @@ static void handle_esp(struct sk_buff *s
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


