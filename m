Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8873626E6F8;
	Mon, 13 Apr 2026 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096398; cv=none; b=HO37mbnrIU89u05UeJPt7N9swyLNzIiLzP0klKb+RlocWyqklgX0LzNgaLrFIiXTmjZIBa5oHrhGeEbiYTPXjKiYv7ujy6mSkT1xNEM4jzg9teY3SMPD2TWKsuKZvB3yTEXgtfpgTpswjh7fDA44bjsA31JG1vBJubLQ93Z7DW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096398; c=relaxed/simple;
	bh=hRrIj5q9saMqCgV11scxZdcDaAckJ/qF9ieaHgaL0Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU8KI+KS1teqAKqXhI55pOUDXDAYFokvII8++fYVCXQy/Me8N8IoKin1F1sP+WL3kFGaY8reCAIuqBQYk2C9Y7D6xfAKq8sZ9tlTeQUQkvzoHlBYbFbnDurhoAPdh0whFahqdQuksQPJm+1zwDHnITViO0R2BWkH99ozbK9NHjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vv46Rjsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vv46Rjsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95FEC2BCAF;
	Mon, 13 Apr 2026 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096398;
	bh=hRrIj5q9saMqCgV11scxZdcDaAckJ/qF9ieaHgaL0Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vv46Rjsuwv8lwaHtV/vxbrGm8Y/ildldbyOikkcj2hhYgv86yRqh9dzM/RGp9RKJX
	 f7BhI9ACjcpJrh1UOWSs0hWfchaovIwyJyZQMoZS2mvBdnZNAYUmxRRc9GqpLqxo3T
	 3vTXyLZ4s3ClxxY/JaSVPb8R8UrtyN2dTyTWYmdo=
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
Subject: [PATCH 6.19 83/86] rxrpc: Fix buffer overread in rxgk_do_verify_authenticator()
Date: Mon, 13 Apr 2026 18:00:30 +0200
Message-ID: <20260413155734.641701403@linuxfoundation.org>
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

commit f564af387c8c28238f8ebc13314c589d7ba8475d upstream.

Fix rxgk_do_verify_authenticator() to check the buffer size before checking
the nonce.

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Closes: https://sashiko.dev/#/patchset/20260401105614.1696001-10-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-20-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -1085,6 +1085,9 @@ static int rxgk_do_verify_authenticator(
 
 	_enter("");
 
+	if ((end - p) * sizeof(__be32) < 24)
+		return rxrpc_abort_conn(conn, skb, RXGK_NOTAUTH, -EPROTO,
+					rxgk_abort_resp_short_auth);
 	if (memcmp(p, conn->rxgk.nonce, 20) != 0)
 		return rxrpc_abort_conn(conn, skb, RXGK_NOTAUTH, -EPROTO,
 					rxgk_abort_resp_bad_nonce);
@@ -1098,7 +1101,7 @@ static int rxgk_do_verify_authenticator(
 	p += xdr_round_up(app_len) / sizeof(__be32);
 	if (end - p < 4)
 		return rxrpc_abort_conn(conn, skb, RXGK_NOTAUTH, -EPROTO,
-					rxgk_abort_resp_short_applen);
+					rxgk_abort_resp_short_auth);
 
 	level	= ntohl(*p++);
 	epoch	= ntohl(*p++);


