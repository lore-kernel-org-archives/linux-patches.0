Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC94D2BEFEF;
	Mon, 13 Apr 2026 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096583; cv=none; b=No0vk54EIMZ23+m7OFmfAaHTHLp5MlYcGZ5TuOE87Ph4dILzGQFHFzVZiXgETqUshak7zVUJo4NdgMoaFZznoKXTjcGDPAQBeoJqwgw7pV3fNKDf4nZK5HkwVTUtSb6/Py90sat5tG6Xq7ovZRukGiiZ6vbU6TSOC0HOeIhER88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096583; c=relaxed/simple;
	bh=iHiXNpdlAHgz4o3z9AseyZjCr5irJLb9vkPx1UJR5qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWl65eIL33eJ1juzG9uZOiqbGBNLKOKq9FT+xBDXfBWNS+qkkhMpuWace8KleR+ge0s+fmNiaPLiBoq77ba1ZuNW5OfDktUDnzS8Xjw42R72TlfFhIRfmTCkYeIAyBNFmdW3P2yJaHYlfYyYBaOzKNJuhZcHcqUX4HLku+M3Zlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zL+tLxET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zL+tLxET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AE4C2BCAF;
	Mon, 13 Apr 2026 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096583;
	bh=iHiXNpdlAHgz4o3z9AseyZjCr5irJLb9vkPx1UJR5qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zL+tLxETP6O7Olnf53Ah4gRxJsgXqeWW6oJ9NVzsOIYYI/GenNlRPiRI3bdqT+nvU
	 ohEvHYW5wsX/p598LFT8/ZXUpSXdNCjIgUusV1SDucDAKOm8IqfZnQeqtD9r0uAQ20
	 qpObjlHvh2kL2rfFF05bdKqLLqqMQVhHdWxrL1vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 67/83] rxrpc: Fix use of wrong skb when comparing queued RESP challenge serial
Date: Mon, 13 Apr 2026 18:00:35 +0200
Message-ID: <20260413155733.507896595@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit b33f5741bb187db8ff32e8f5b96def77cc94dfca upstream.

In rxrpc_post_response(), the code should be comparing the challenge serial
number from the cached response before deciding to switch to a newer
response, but looks at the newer packet private data instead, rendering the
comparison always false.

Fix this by switching to look at the older packet.

Fix further[1] to substitute the new packet in place of the old one if
newer and also to release whichever we don't use.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://sashiko.dev/#/patchset/20260319150150.4189381-1-dhowells%40redhat.com [1]
Link: https://patch.msgid.link/20260408121252.2249051-7-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h | 1 +
 net/rxrpc/conn_event.c       | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index a826cd80007b..f7f559204b87 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -185,6 +185,7 @@
 	EM(rxrpc_skb_put_input,			"PUT input    ") \
 	EM(rxrpc_skb_put_jumbo_subpacket,	"PUT jumbo-sub") \
 	EM(rxrpc_skb_put_oob,			"PUT oob      ") \
+	EM(rxrpc_skb_put_old_response,		"PUT old-resp ") \
 	EM(rxrpc_skb_put_purge,			"PUT purge    ") \
 	EM(rxrpc_skb_put_purge_oob,		"PUT purge-oob") \
 	EM(rxrpc_skb_put_response,		"PUT response ") \
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 98ad9b51ca2c..c50cbfc5a313 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -557,11 +557,11 @@ void rxrpc_post_response(struct rxrpc_connection *conn, struct sk_buff *skb)
 	spin_lock_irq(&local->lock);
 	old = conn->tx_response;
 	if (old) {
-		struct rxrpc_skb_priv *osp = rxrpc_skb(skb);
+		struct rxrpc_skb_priv *osp = rxrpc_skb(old);
 
 		/* Always go with the response to the most recent challenge. */
 		if (after(sp->resp.challenge_serial, osp->resp.challenge_serial))
-			conn->tx_response = old;
+			conn->tx_response = skb;
 		else
 			old = skb;
 	} else {
@@ -569,4 +569,5 @@ void rxrpc_post_response(struct rxrpc_connection *conn, struct sk_buff *skb)
 	}
 	spin_unlock_irq(&local->lock);
 	rxrpc_poke_conn(conn, rxrpc_conn_get_poke_response);
+	rxrpc_free_skb(old, rxrpc_skb_put_old_response);
 }
-- 
2.53.0



