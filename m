Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970594F7989;
	Tue, 21 Jul 2026 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647772; cv=none; b=uykx6+P/dvjB2zJsEOZGrzS2WYSHtTqUm/5MuJbhJhVeqeEWBy371vGZBqWvN9Z24OQMepEDMjBGKdCyKQAs6Kmh7GcEsQAsFYt0abahedQrRElhkIG4xEWIUHYfSkE/aHnLUxSvwbG1pL3jmGfQtar4zkOJDT9HXpYXR5sNbpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647772; c=relaxed/simple;
	bh=hKMfy2NpAvXm/qchK5n/IsCh4FMGhp9YIkoCURAbCuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtJuOnboMkZt+mjh03g/xPYZdvr0Bedzx6bvVrpy6iazZ/MK6LTWYYlkqHmYuqP7qkPYWKkKcRV/US9FbfTodDHMOT5Kr+KSMNJN536Z6EoV2E7fBMJZukgcbcunp7XS9Vau5Zw1aKO61VGJ5ua5SCqCQEDfLsYeUw32ESWxnfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHMqlY92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHMqlY92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEB81F000E9;
	Tue, 21 Jul 2026 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647771;
	bh=lU5TybJAkPn3CqiAKpI3fsCEXH9EnEqqn1NXuUdSqS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHMqlY92Rx3AZwrjsDYA/xN/lmayRHajyjsXx8j6n6mjqjAchkMwjPTkwz2GSwLks
	 Ndbzz6UhoQXsxHHOOCc4KdI0FL7tdjnvZ9i3/Eabv0TXJ44gjRmSUnD9Do3BFQ697S
	 Wsaq3uP43m5GbhaDZfr49XMF6KA1e2rA7OgwkwbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/843] nfc: llcp: protect nfc_llcp_sock_unlink() calls
Date: Tue, 21 Jul 2026 17:13:57 +0200
Message-ID: <20260721152406.008781059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit a06b8044169f6d5c3eb34772c13d2c0c1b205352 ]

nfc_llcp_sock_link() is called in all paths (bind/connect) as a last
action, still protected with lock_sock().  When cleaning up in
llcp_sock_release(), call nfc_llcp_sock_unlink() in a mirrored way:
earlier and still under the lock_sock().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 54af85d939c6b9..57dea580c02912 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -626,6 +626,13 @@ static int llcp_sock_release(struct socket *sock)
 		}
 	}
 
+	if (sock->type == SOCK_RAW)
+		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
+	else if (sk->sk_state == LLCP_CONNECTING)
+		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
+	else
+		nfc_llcp_sock_unlink(&local->sockets, sk);
+
 	if (llcp_sock->reserved_ssap < LLCP_SAP_MAX)
 		nfc_llcp_put_ssap(llcp_sock->local, llcp_sock->ssap);
 
@@ -638,13 +645,6 @@ static int llcp_sock_release(struct socket *sock)
 	if (sk->sk_state == LLCP_DISCONNECTING)
 		return err;
 
-	if (sock->type == SOCK_RAW)
-		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
-	else if (sk->sk_state == LLCP_CONNECTING)
-		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
-	else
-		nfc_llcp_sock_unlink(&local->sockets, sk);
-
 out:
 	sock_orphan(sk);
 	sock_put(sk);
-- 
2.53.0



