Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2661E7C08;
	Thu, 30 Jan 2025 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246738; cv=none; b=Qwq5/97V2iWQ4ZEW9TK/06AAraCJqi7Wa0pY+DEVRhh3CmwM2NgFI36L6n8sJWj+wI4tUDBQ0egrueXxjD3JLM6KTtV8jkJBvA7aS8erGiQduEoCANHDPsQ3PKeGkWoVqQ6SkNPczB51h0Vw4bbogZU9BzCt7F6jZf/pVQLoJcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246738; c=relaxed/simple;
	bh=PiFVp/AUjgRmVD2Ex9RmJbhgpUUVxUU33tMEp45RVns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoVXQWUQzckU1fQKhCPxa774fz/XGjDrABCL4cQne0QxIFnOqEne4bjlSx+bGMROGaO2HOi1ULu3+AaDBdMFYStuQLVOg2+6lf6X1kSoZqbEC4gGmMcqXrRNurBVTMbosq3mf3g3FwVlug2QIw0wUR4LX8xqiYuw5MEw1Q7bL9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UchU6tpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UchU6tpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18DAC4CED2;
	Thu, 30 Jan 2025 14:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246738;
	bh=PiFVp/AUjgRmVD2Ex9RmJbhgpUUVxUU33tMEp45RVns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UchU6tpOFlj0Ks1yCdlIC8oaNQY48Fmpr/IiCQW2pgroZb4vfxILsr4MQFA4bSNSa
	 Gqhnpn+oz0bU56zZtyZcOSzo9/pay/IiGAMmyvijbxnz3tmvKOChsSluuL4VZ0u4eP
	 aXTpKM4Z1a0DbuexhnoKazbUzs62VYPNFeQ2HAiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/91] tls: Fix tls_sw_sendmsg error handling
Date: Thu, 30 Jan 2025 15:00:29 +0100
Message-ID: <20250130140134.081481749@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 910da98d6bfb..03f608da594e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -425,7 +425,7 @@ int tls_tx_records(struct sock *sk, int flags)
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, -EBADMSG);
+		tls_err_abort(sk, rc);
 
 	return rc;
 }
-- 
2.39.5



