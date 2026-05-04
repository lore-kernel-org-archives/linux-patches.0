Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA983D6484;
	Mon,  4 May 2026 14:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904249; cv=none; b=ij9tw8ve/JNDvyjz1zVKlrRxYBeqmDnqAppP7St2ccJ2y7pVq+8M/f4/4wfIHUoTNC5A7YiFdrds2XBRFaHVtlmtQPg9YCEu4ZFWKURuVMHFm381geWixYckjgTdc2O0UcvxA5U2VghaBLk4Zu/h+mx206iZcptUDSpErh+8CQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904249; c=relaxed/simple;
	bh=pa2/rqfsIpwMDQTW2fl2c6fT/aUnSmT9TQLQK1a/FY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdP/4oSJTFcgBnuMmPDecy8I34BN2853MQAZmowyQnSvMNxVqCV5WUkw8YPvzXsXfX1pSNZVRY6aMwXlZFf4ZSvTNnb0oln6O2Dqg94DOPLXG6FvvVgQnPXg+OtcHvn21jN+Prpv1/bsVBXJHupsncUUuTI24pV62tF3KDgu3hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6Ocq1Tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6Ocq1Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10575C2BCB8;
	Mon,  4 May 2026 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904249;
	bh=pa2/rqfsIpwMDQTW2fl2c6fT/aUnSmT9TQLQK1a/FY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6Ocq1Tn1Q/PpwDBtexLCIs6GrCpcGB5SDMJLM1pB/HeQrrbx+dTuSJRtBcWm7VMG
	 AIyeTIEEozRQ6TTs1NeZU1I40qOay+xic4+TPD6/JvwRlWobhvFo0vIPrFCmzxBRJN
	 cqktU1ltlsM9GsEXjWLgZjpfddCcDkcbnu3inTuA=
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
Subject: [PATCH 6.18 242/275] rxgk: Fix potential integer overflow in length check
Date: Mon,  4 May 2026 15:53:02 +0200
Message-ID: <20260504135152.032395527@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

commit 6929350080f4da292d111a3b33e53138fee51cec upstream.

Fix potential integer overflow in rxgk_extract_token() when checking the
length of the ticket.  Rather than rounding up the value to be tested
(which might overflow), round down the size of the available data.

Fixes: 2429a1976481 ("rxrpc: Fix untrusted unsigned subtract")
Closes: https://sashiko.dev/#/patchset/20260408121252.2249051-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-6-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk_app.c    | 2 +-
 net/rxrpc/rxgk_common.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/rxgk_app.c b/net/rxrpc/rxgk_app.c
index 30275cb5ba3e..5587639d60c5 100644
--- a/net/rxrpc/rxgk_app.c
+++ b/net/rxrpc/rxgk_app.c
@@ -214,7 +214,7 @@ int rxgk_extract_token(struct rxrpc_connection *conn, struct sk_buff *skb,
 	ticket_len	= ntohl(container.token_len);
 	ticket_offset	= token_offset + sizeof(container);
 
-	if (xdr_round_up(ticket_len) > token_len - sizeof(container))
+	if (ticket_len > xdr_round_down(token_len - sizeof(container)))
 		goto short_packet;
 
 	_debug("KVNO %u", kvno);
diff --git a/net/rxrpc/rxgk_common.h b/net/rxrpc/rxgk_common.h
index 80164d89e19c..1e257d7ab8ec 100644
--- a/net/rxrpc/rxgk_common.h
+++ b/net/rxrpc/rxgk_common.h
@@ -34,6 +34,7 @@ struct rxgk_context {
 };
 
 #define xdr_round_up(x) (round_up((x), sizeof(__be32)))
+#define xdr_round_down(x) (round_down((x), sizeof(__be32)))
 #define xdr_object_len(x) (4 + xdr_round_up(x))
 
 /*
-- 
2.54.0



