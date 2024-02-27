Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200FD13B2B4;
	Tue, 27 Feb 2024 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043680; cv=none; b=ap3E1GSQgcrmN/tfMHSFCb132rC7htiW0pDuqjJ7c/99S8z4jer26MM7Y3/0cA0Zdih5vxVIrqsbYdaAhN891UOCkrOBiFCc7BcLded7LC3ZWAmI6Amw8nn5BjGnk9i2kv+bmww2HGhNUuxLny1farRFAT14h+5N/srPtP6wB8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043680; c=relaxed/simple;
	bh=xVAOF8cuXwG3iUc6jZ32KHzQHhbfT+RmFXoAZIVkmDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txHMe1QNCl3KlK24G2DZT4evwTRnhVkZEF38QKMnKlpny37Zw1jGgR+ngJKmySscz8ebYKlHbhNNZmpMk8HUWOjnl2fZf5Nx6/+2bK1LpHaQ8YzM5Ziybk/G3a1VzXoZYjLqbcW7xlFvjIhn0Xy628miKbZWC+onwXFs++pyqus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1gQfnaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1gQfnaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2E9C433F1;
	Tue, 27 Feb 2024 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043680;
	bh=xVAOF8cuXwG3iUc6jZ32KHzQHhbfT+RmFXoAZIVkmDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1gQfnajkUuDS/tT5vZ3YkVNS6Q7DIAJBZXcRHWe+AXX9cT3/2jfXd6b+DLaQcZ6t
	 bMc1cN2NJYG8LPmpzLR0TsnmUlDvZS32SKkwQcZao3oJUB06WKR3yFk1zPJlViJDXs
	 DTRs/miDB8GPlhPgMc1Vx1BoBajUNFhjhjpeDkSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/195] tls: stop recv() if initial process_rx_list gave us non-DATA
Date: Tue, 27 Feb 2024 14:27:08 +0100
Message-ID: <20240227131615.924910161@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit fdfbaec5923d9359698cbb286bc0deadbb717504 ]

If we have a non-DATA record on the rx_list and another record of the
same type still on the queue, we will end up merging them:
 - process_rx_list copies the non-DATA record
 - we start the loop and process the first available record since it's
   of the same type
 - we break out of the loop since the record was not DATA

Just check the record type and jump to the end in case process_rx_list
did some work.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/bd31449e43bd4b6ff546f5c51cf958c31c511deb.1708007371.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index cd86c271c1348..20d2877bf22ad 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2044,7 +2044,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		goto end;
 
 	copied = err;
-	if (len <= copied)
+	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA))
 		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-- 
2.43.0



