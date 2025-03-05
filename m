Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD97A1ACEDD;
	Wed,  5 Mar 2025 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198404; cv=none; b=Zo9bogpwiuuYDmD1pQ3bXPy+0GIHSmy6OKX6jo7G5dvfRmwPyIaK+CppdT8BQJwFodqkohYLxAn4F59khw74oDFg8LeeBaAY+6IFRa3EhCt+vMscor2icik1WWfPqD6Nm7tXfocornfZdIQJhFsR2Xa1YznimRMEGnRv+xRDJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198404; c=relaxed/simple;
	bh=JRLiQDr2RAzo/+n5pN/RqBaZ5ScUZv0+KqO6Hjiacl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOKdoLTSHnOkEA/qdHNbEzUOBYD71aFj0ypJ1H9Wfk/ZTgzdwHEbPo96AWgJZFM+u/ATGiAMcXdTo8VAw+6lr6n4rQlXoBicWWIpDiGwt5Zwk1Pd6NJsHaehYDZNf06JRw/cqkwzJn9w5CZ5EL0AVg0uoXdJhn686NrwXoFoLFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEgcO2+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEgcO2+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428E2C4CED1;
	Wed,  5 Mar 2025 18:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198404;
	bh=JRLiQDr2RAzo/+n5pN/RqBaZ5ScUZv0+KqO6Hjiacl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEgcO2+QjAn+/Fwk89W5kczDAO+ZtIgxzV76fLYtsr5s6EsBmFyUNp/y5tJSKOtab
	 a0m6VbM2qoE2gJD8/Lgk4ilEPYfiSaw7rmScdcCduVCeYvTnLtJKat0IftsR481Ojo
	 J4ehWA7oylaqgDzR17QpOh/X3PLmBYIOrFeHGJbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 017/157] SUNRPC: Handle -ETIMEDOUT return from tlshd
Date: Wed,  5 Mar 2025 18:47:33 +0100
Message-ID: <20250305174505.981914209@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 7a2f6f7687c5f7083a35317cddec5ad9fa491443 ]

If the TLS handshake attempt returns -ETIMEDOUT, we currently translate
that error into -EACCES.  This becomes problematic for cases where the RPC
layer is attempting to re-connect in paths that don't resonably handle
-EACCES, for example: writeback.  The RPC layer can handle -ETIMEDOUT quite
well, however - so if the handshake returns this error let's just pass it
along.

Fixes: 75eb6af7acdf ("SUNRPC: Add a TCP-with-TLS RPC transport class")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index c60936d8cef71..6b80b2aaf7639 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2581,7 +2581,15 @@ static void xs_tls_handshake_done(void *data, int status, key_serial_t peerid)
 	struct sock_xprt *lower_transport =
 				container_of(lower_xprt, struct sock_xprt, xprt);
 
-	lower_transport->xprt_err = status ? -EACCES : 0;
+	switch (status) {
+	case 0:
+	case -EACCES:
+	case -ETIMEDOUT:
+		lower_transport->xprt_err = status;
+		break;
+	default:
+		lower_transport->xprt_err = -EACCES;
+	}
 	complete(&lower_transport->handshake_done);
 	xprt_put(lower_xprt);
 }
-- 
2.39.5



