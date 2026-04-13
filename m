Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F106425332E;
	Mon, 13 Apr 2026 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096396; cv=none; b=FkLj4ifyxYQyOEKcxA6EoxHZXUP1G5rq+XNAs6/iJnP5O8darBysSHIrcIcnOFSvntQIK4TJ2SIHD24ljOPkidwC0fxXnmbGCA7Crc0NypUPjPKK6YIZw/jBwcd3utN8P0P3Q51IWxuLYnprE5liF/CFKA0aEPAJV2Y+Mp0MV0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096396; c=relaxed/simple;
	bh=r3giP86m/T+JpKKl9Uu/nylHpi+5KoRv7jKa/6Wav3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVKxtSh7+yIrLY5Dp5PPx3/Runfkg2Hkc8C6DaQqFym6ebZgIcJly5IF+Tl5lxZ6tGu4C8FGI0MBpB85tpEy9UsDA20jAdpemkrU0fqOxnS6JJbx1Nj2N/dfrPFEkRpuoEP/DEhxPwlF1zaoIGQPA9IVSyo5KtkqL4ztY6a37AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhiKTNTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhiKTNTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F776C2BCAF;
	Mon, 13 Apr 2026 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096395;
	bh=r3giP86m/T+JpKKl9Uu/nylHpi+5KoRv7jKa/6Wav3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhiKTNTvVab9gUD4xrVDllt5ktXlnJjBPusPrlZeV/kDwjOtiRqs3nxso1MIXE20w
	 qOdjf3+cGQKDwCwSJHpXI+MqQ1zcRVRC4l//kNqd9ltTtkJphXQD4+h8wMHmBlr60t
	 1jnW/9CXMZMHcQGbZCbuB0rq/9ZEyIRgMoq13tnY=
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
Subject: [PATCH 6.19 82/86] rxrpc: Fix leak of rxgk context in rxgk_verify_response()
Date: Mon, 13 Apr 2026 18:00:29 +0200
Message-ID: <20260413155734.598192289@linuxfoundation.org>
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


