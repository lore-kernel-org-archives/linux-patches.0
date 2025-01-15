Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A3C1DB13A;
	Wed, 15 Jan 2025 10:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938573; cv=none; b=DyD/dR6L4LtK6OlwqtucRX9Z+KRo0C9dPvx0y4kdyJ2x/fgbgoMcH/MBvbrN1pLWvKG8H+ihKhtOHlJGVS06b/rYTwhMbZxYbpOE9UxTPTl2Y9pfQac02LSC3RcWIdCCY9f6AWjolNI4d4wU7vPJEEmwkKtxGJK9zA9zNmkdugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938573; c=relaxed/simple;
	bh=cpyUoZQ/IvcVimrNmpx6kCswBC+xCjRpLH8WiB71HBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niQ5VakpqagoFXdhk602QhgMhc3dLx1b51COEFOL1KH/A3uYTixWP/7aM7XLk9RGOtYw5gkCK5/Dxhu81HGRaxQiuNwrnXo9qqQQtDbRphpVNrxktxf5Yc7/Lc+15k8lVjij/RHxkwVdcwQg4QBOFQ93c+N/5CVmdYXD/h7evGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIxkkgJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIxkkgJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EACC4CEDF;
	Wed, 15 Jan 2025 10:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938572;
	bh=cpyUoZQ/IvcVimrNmpx6kCswBC+xCjRpLH8WiB71HBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIxkkgJAguTgsiS/JEIXQv2F3N5CEmYfpr7xEHwHNB0WxHs0zKEN1TeAfRcIJPwIr
	 iouxPs1A+rjbdnYrdSGki+vBjLrh/P2ZOT8qbxt+tpDU9alOJ8HN9pU9+jPCxc2Drh
	 84Bg5mSJhg75bPBXcWhBFs859rEQSp06LCUV+N9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/129] tls: Fix tls_sw_sendmsg error handling
Date: Wed, 15 Jan 2025 11:36:46 +0100
Message-ID: <20250115103555.619995555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit b341ca51d2679829d26a3f6a4aa9aee9abd94f92 ]

We've noticed that NFS can hang when using RPC over TLS on an unstable
connection, and investigation shows that the RPC layer is stuck in a tight
loop attempting to transmit, but forever getting -EBADMSG back from the
underlying network.  The loop begins when tcp_sendmsg_locked() returns
-EPIPE to tls_tx_records(), but that error is converted to -EBADMSG when
calling the socket's error reporting handler.

Instead of converting errors from tcp_sendmsg_locked(), let's pass them
along in this path.  The RPC layer handles -EPIPE by reconnecting the
transport, which prevents the endless attempts to transmit on a broken
connection.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Link: https://patch.msgid.link/9594185559881679d81f071b181a10eb07cd079f.1736004079.git.bcodding@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index df166f6afad8..6e30fe879d53 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -458,7 +458,7 @@ int tls_tx_records(struct sock *sk, int flags)
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, -EBADMSG);
+		tls_err_abort(sk, rc);
 
 	return rc;
 }
-- 
2.39.5



