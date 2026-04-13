Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE64225788;
	Mon, 13 Apr 2026 16:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096632; cv=none; b=jOYJTZtjs33Mh2GZ5CP3EhRfAnL4svZK2HNUAjRVrIxaDeAtPeuJ3L7D8Mh7bbNPeFGR9+N6bf8S21xksuLTR5Q6ELFYGxPfJWi8Dc9bCmkHGZIri/YtRP3kjqHggsB2C7ugwsy/ntWGBRJxcg3fuU19MPbQQpi9UkZVD68noNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096632; c=relaxed/simple;
	bh=5S86sVjNH2zlS9XM4Svv5TbmF/a3ZA040X/9D85LDBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTy4GJ0UjuFiUj6bPPH9q2T8dqQh3TNUOCgzs+oYlSnihvXj4M9648ng4zbk0iSOeADKzP+yWQu2StSpjbkKX7YPe78nBG717NIR2mmmBjVXd402zlknmMCdOAGFfY9lctjMRcZBZW3kLTGedOlNF1tqHiJTcpKz7G47olL6eYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJYU+3Qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJYU+3Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B6EC2BCAF;
	Mon, 13 Apr 2026 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096632;
	bh=5S86sVjNH2zlS9XM4Svv5TbmF/a3ZA040X/9D85LDBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJYU+3QunXUaSQyKn9rc0vfPsjjKsfdwkipa81bCJBi/xelYNDHmhEHqYy8eLQOXl
	 rF/h1S49QATKKCCm2OkS2vI7De6nJrocJamWGhqA9MfsZq6RGydb6lCg0P/ckHcH8B
	 oSSbiPkcYCS4tD56sUjgSp5pFrTP+3Bkx1wER7L4=
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
Subject: [PATCH 6.18 79/83] rxrpc: Fix leak of rxgk context in rxgk_verify_response()
Date: Mon, 13 Apr 2026 18:00:47 +0200
Message-ID: <20260413155733.942890266@linuxfoundation.org>
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

commit 7e1876caa8363056f58a21d3b31b82c2daf7e608 upstream.

Fix rxgk_verify_response() to clean up the rxgk context it creates.

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Closes: https://sashiko.dev/#/patchset/20260401105614.1696001-10-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-19-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -1270,16 +1270,18 @@ static int rxgk_verify_response(struct r
 	if (ret < 0) {
 		rxrpc_abort_conn(conn, skb, RXGK_SEALEDINCON, ret,
 				 rxgk_abort_resp_auth_dec);
-		goto out;
+		goto out_gk;
 	}
 
 	ret = rxgk_verify_authenticator(conn, krb5, skb, auth_offset, auth_len);
 	if (ret < 0)
-		goto out;
+		goto out_gk;
 
 	conn->key = key;
 	key = NULL;
 	ret = 0;
+out_gk:
+	rxgk_put(gk);
 out:
 	key_put(key);
 	_leave(" = %d", ret);


