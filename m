Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8501C5799;
	Sat, 30 May 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162504; cv=none; b=NcLLx6iKWpN7CR/rFerEx66X1BNhmmeo6pk48f+awt0kZD5tceTXuQyBwLRSvAnZXZZRbSHXlf5wtNzo++uhOkFuQig8sj6Pxh/wbwSuFHe2kz1/9rNMEDpOImuF7Ih3vE3cdr8tyzYua39Nz2hBMV+XrXriqDCXTIyOjT9m18c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162504; c=relaxed/simple;
	bh=EV2vt5u2M//kULiYPzqNBRyZDU2fjuoDiHalPFrCcB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDGBp7PXOZZEuW0YDsADKjSY4s44IjN8+pL1EAoxARNfkWYPDBrApAL1oT4I5aoaCgJR5trBloXzV0WeOwi/ljXfFJ2auWD19mzQ6fIs34hxpo0ynSMy8QNbhPMZiv5Vhxl7KlGNrOXuiMv2oKhSgqpKkvcQ1svhJ6c83y1DT28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sq+b2ovs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sq+b2ovs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323971F00893;
	Sat, 30 May 2026 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162503;
	bh=3DpKCEEGxMNpKwj124pQH8ersXQqE2XevZxi7ew0oj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sq+b2ovsTV1Q1efKQgkx1SczFZIvExi3zAKqATYaxiUoGv/ByY4FQzhoKTOYYXRU8
	 oibEGGEA390VMQ9zLqaV1sCU0VWQImjRIuGbqp2dm9LUj7F7fNA6xv7/1Tq8ar6YIo
	 uDLdybIBd6FaXlEw/6qWfkXP5mT1X4rqPJgRFIAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 939/969] net: tls: prevent chain-after-chain in plain text SG
Date: Sat, 30 May 2026 18:07:43 +0200
Message-ID: <20260530160326.683038280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ff26a0e8377dec07e4a7230db7675bed1b9a6d03 ]

Sashiko points out that if end = 0 (start != 0) the current
code will create a chain link to content type right after
the wrap link:

  This would create a chain where the wrap link points directly
  to another chain link. The scatterlist API sg_next iterator
  does not recursively resolve consecutive chain links.

meaning this is illegal input to crypto.

The wrapping link is unnecessary if end = 0. end is the entry after
the last one used so end = 0 means there's nothing pushed after
the wrap:

   end         start            i
    v            v              v
  [   ]...[   ][ d ][ d ][ d ][ d ][rsv for wrap]

Skip the wrapping in this case.

TLS 1.3 can use the "wrapping slot" for it's chaining if end = 0.
This avoids the chain-after-chain.

Move the wrap chaining before marking END and chaining off content
type, that feels like more logical ordering to me, but should not
matter from functional perspective.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 9aaaa56845a0 ("bpf: Sockmap/tls, skmsg can have wrapped skmsg that needs extra chaining")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260511174920.433155-3-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index a46f3cc4b3f14..de85e26d9675d 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -790,21 +790,33 @@ static int tls_push_record(struct sock *sk, int flags,
 	i = msg_pl->sg.end;
 	sk_msg_iter_var_prev(i);
 
+	/* msg_pl->sg.data is a ring; data[MAX+1] is reserved for the wrap
+	 * link (frags won't use it). 'i' is now the last filled entry:
+	 *
+	 *         i   end              start
+	 *         v    v                 v            [ rsv ]
+	 *  [ d ][ d ][   ][   ]...[   ][ d ][ d ][ d ][chain]
+	 *    ^   END                                     v
+	 *     `-----------------------------------------'
+	 *
+	 * Note that SGL does not allow chain-after-chain, so for TLS 1.3,
+	 * we must make sure we don't create the wrap entry and then chain
+	 * link to content_type immediately at index 0.
+	 */
+	if (i < msg_pl->sg.start)
+		sg_chain(msg_pl->sg.data, ARRAY_SIZE(msg_pl->sg.data),
+			 msg_pl->sg.data);
+
 	rec->content_type = record_type;
 	if (prot->version == TLS_1_3_VERSION) {
 		/* Add content type to end of message.  No padding added */
 		sg_set_buf(&rec->sg_content_type, &rec->content_type, 1);
 		sg_mark_end(&rec->sg_content_type);
-		sg_chain(msg_pl->sg.data, msg_pl->sg.end + 1,
-			 &rec->sg_content_type);
+		sg_chain(msg_pl->sg.data, i + 2, &rec->sg_content_type);
 	} else {
 		sg_mark_end(sk_msg_elem(msg_pl, i));
 	}
 
-	if (msg_pl->sg.end < msg_pl->sg.start)
-		sg_chain(msg_pl->sg.data, ARRAY_SIZE(msg_pl->sg.data),
-			 msg_pl->sg.data);
-
 	i = msg_pl->sg.start;
 	sg_chain(rec->sg_aead_in, 2, &msg_pl->sg.data[i]);
 
-- 
2.53.0



