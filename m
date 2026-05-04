Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B353A7F4C;
	Mon,  4 May 2026 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903918; cv=none; b=mfMfGTT82JyVNk+pR5+hkeXz2ZRwiFVwqvjBLz2Vu5trqovlAQSc8sUXyvy9cK0gqKP5IBgXc9vkGbGm9cHic5gv4fhz8DF/39LHuJ0TONVAXAAPQSXWDHWd+iRBFXSjqp+lCX3BjFyzFABj8ni93sxtsgTKy9boZ2nZlHHjdWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903918; c=relaxed/simple;
	bh=AzTvZLzKIA3Jst6Z0w/V3s6OkUuixCCNLeT2O+QWQkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLyYnCK9mSjpT4NzqEyoux4r9LDaQIEglISfdL3tKn/GkBaJE3KSCIJFHqUPy+BKDEeXj4eY/04akJN01jIgWlo7R/fLzjzjDAxKx5CgwHglPBj80mrsxYMwQm11SWIMv6AWuV0YiHfYdrJFxQdnG5+1b8YH5sR5yFHkr1+KLEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVuK3abD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVuK3abD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9EFC2BCB8;
	Mon,  4 May 2026 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903918;
	bh=AzTvZLzKIA3Jst6Z0w/V3s6OkUuixCCNLeT2O+QWQkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVuK3abDNyVwTwIrMJGfh0J0oPYflXdXqypOU1mBYLtiAfuYdc1Nfo8uFneMSuFba
	 DH3b9ckXS1CEHukwrvzbiPFRzfDF3xjD+TrJ51PPweCtQDU31JjwSEuVGSQP4tLyrY
	 8ZeEnmId1kr2gX6dLIso1HquwKe9MdAwLeaurev4=
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
Subject: [PATCH 6.18 112/275] rxrpc: Fix error handling in rxgk_extract_token()
Date: Mon,  4 May 2026 15:50:52 +0200
Message-ID: <20260504135147.070962713@linuxfoundation.org>
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

commit 3476c8bb960f48e49355d6f93fb7673211e0163f upstream.

Fix a missing bit of error handling in rxgk_extract_token(): in the event
that rxgk_decrypt_skb() returns -ENOMEM, it should just return that rather
than continuing on (for anything else, it generates an abort).

Fixes: 64863f4ca494 ("rxrpc: Fix unhandled errors in rxgk_verify_packet_integrity()")
Closes: https://sashiko.dev/#/patchset/20260422161438.2593376-4-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260423200909.3049438-4-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk_app.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/rxgk_app.c b/net/rxrpc/rxgk_app.c
index 5587639d60c5..0ef2a29eb695 100644
--- a/net/rxrpc/rxgk_app.c
+++ b/net/rxrpc/rxgk_app.c
@@ -245,6 +245,7 @@ int rxgk_extract_token(struct rxrpc_connection *conn, struct sk_buff *skb,
 		if (ret != -ENOMEM)
 			return rxrpc_abort_conn(conn, skb, ec, ret,
 						rxgk_abort_resp_tok_dec);
+		return ret;
 	}
 
 	ret = conn->security->default_decode_ticket(conn, skb, ticket_offset,
-- 
2.54.0



