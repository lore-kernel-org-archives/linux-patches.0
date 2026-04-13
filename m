Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CD6225788;
	Mon, 13 Apr 2026 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096630; cv=none; b=cpJzjBvqVoOYIHNr05qkudgvooDJXH3nSsmCYJrxDn+7ScOzEe3ZvPpxSteD0VKwrknn9KDlanHARucgMfcA3XykiO1xVfUnAXD4gTFAoWg4KOBfi+vMtKjZXqbbpK3snvJGtCMXTjiGbxu2NpyG2layqXa0DALN5YXOZW2qbv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096630; c=relaxed/simple;
	bh=F4TJEA/3ZlyV8gqh23JdrzpGaDW8Ddfd579WqB8bHAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5M8sQkTM2udxr5S9n9SC6wmsjNl5Eqi7X5iJFz0hTVTQvT0Yz7DtoZ9ZYroNS18JrhAkRVgG+oPzQ49Qmj45nuGooZIwe3vdtt4U7A1kzYM/LwSw3Mlx+6gY9nSMrK79B7Q8qkVKHsjHB8jlAuWwU8grMpDBx2yieIjDQHvYEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qt099mIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qt099mIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A02C2BCAF;
	Mon, 13 Apr 2026 16:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096630;
	bh=F4TJEA/3ZlyV8gqh23JdrzpGaDW8Ddfd579WqB8bHAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qt099mINL4hO+4reSsW+NgJJaAHDB3jPlBQGVVk1M5RLcdrRR1Beu6wy4iKip0PEQ
	 T5OYEyYnxiz6KZyYrkzwi78XWh+uhjrP+d3+1fhRp4uIscbiA5fg+gxCmAIPbEiaot
	 tCG3VbUKuCss5xbvfWaWyYIPt5a+hIYB6DIdTatk=
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
Subject: [PATCH 6.18 78/83] rxrpc: Fix integer overflow in rxgk_verify_response()
Date: Mon, 13 Apr 2026 18:00:46 +0200
Message-ID: <20260413155733.906676015@linuxfoundation.org>
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


