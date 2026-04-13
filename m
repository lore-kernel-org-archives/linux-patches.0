Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E1625332E;
	Mon, 13 Apr 2026 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096393; cv=none; b=Yq6m23zUf29/8uRUV5HfXLKbOyuE2T47VSdUjD/rOTEvCzkg6+yYzf2rgP8vAVCrTv8nzliQfFOWasUdX6NIVVw0gd+rjALvYJOnYMiQpD8ZmnCqyJI9Q0+5eNc+pRSZqoxqt/RKd5HBafZkZbe5sSNuSDDQFO2GJEcmmP47tFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096393; c=relaxed/simple;
	bh=Z8fgruLQ7AiexRUlVxkgarPVYb9y52brBQjrwU2jb+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsAP1tbOFyHmlLoXQDPDHEdBrRKByiDxu0e0GCFhnfQ/8qTAq0AFxKKZqcBJhWXifoxR0+f8kc1iw3zdv9LbS3QvSghZ6VQsqJxZ/DHLxmJtLottnhvNuHGdyRSi1Kokmdi+f9bsWu4FCDVfbHGfDc8Y5onrnT38Co+XXedxnSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDL6IqHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDL6IqHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB641C2BCAF;
	Mon, 13 Apr 2026 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096393;
	bh=Z8fgruLQ7AiexRUlVxkgarPVYb9y52brBQjrwU2jb+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDL6IqHd3Q9pC95GLvh6/iDb/NN/YCAaacZp+O+HQ1kWslin8WACR5SD+NCSTyCuc
	 LmS/2e1m+l8JKGs00bIkPc4VcLrAiduDpcwG/OD8cb6MKoGStTV5VIhEMy7KgMNdQe
	 CI2IAe5tcAtrfQXICJlw3uzFw8lQra2PF3AOD1GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 81/86] rxrpc: Fix integer overflow in rxgk_verify_response()
Date: Mon, 13 Apr 2026 18:00:28 +0200
Message-ID: <20260413155734.561688890@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 699e52180f4231c257821c037ed5c99d5eb0edb8 upstream.

In rxgk_verify_response(), there's a potential integer overflow due to
rounding up token_len before checking it, thereby allowing the length check to
be bypassed.

Fix this by checking the unrounded value against len too (len is limited as
the response must fit in a single UDP packet).

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Closes: https://sashiko.dev/#/patchset/20260401105614.1696001-10-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-18-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -1209,7 +1209,8 @@ static int rxgk_verify_response(struct r
 
 	token_offset	= offset;
 	token_len	= ntohl(rhdr.token_len);
-	if (xdr_round_up(token_len) + sizeof(__be32) > len)
+	if (token_len > len ||
+	    xdr_round_up(token_len) + sizeof(__be32) > len)
 		goto short_packet;
 
 	trace_rxrpc_rx_response(conn, sp->hdr.serial, 0, sp->hdr.cksum, token_len);


