Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5795417B505;
	Wed,  5 Mar 2025 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197969; cv=none; b=GHm7DjUBM2X3Oyv6fyTTurm1gHTdpS5GN1peXRJZkLH2uXbXInW4HEjND6IFq4cEQS0oDyQ4Bz666QYz6Zwkid3NBtOKahJkM9C4tbIBp7ur5O9MQNf3i65iwVLcgoGb2uI3FEMNsiuZyi5LC2Z0aIZyp3IkEc00BoHYwDjPYys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197969; c=relaxed/simple;
	bh=+x9pgCc9yuVjQ+98H89tn7F9aH4ov/4inOkD/n0Sl4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBmWjH0aaIAoSmI3rF6Tnz2u+mIASruU21BN4wxvh39CH2zah0/sCPT/SBzgd2BICs1BtINimk4ds6q8dfNCu2KY0d+uDsPENfPfD8Jf5BEKfIhB65SEM97wqgTlxGX8sU0+3dAOgQoqmGAhtsdDIFEwLe8/QqsGBGQArAGo+1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0e9vfmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0e9vfmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D558DC4CED1;
	Wed,  5 Mar 2025 18:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197969;
	bh=+x9pgCc9yuVjQ+98H89tn7F9aH4ov/4inOkD/n0Sl4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0e9vfmrNSxRfHqf/ounmSb+K8040kVZvDqug+cCql7WnxKxpggAskmWndCJ4ONcs
	 2V44omKu1Eg6e55ojs6sTnymn9s6FZp+55gBmqUe6Ryd8X21kzaZnlErbo3200Trrf
	 Aorl4DoQykWqyaqaoCNHQ8JfiMbtOgkLUj4p8De4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/150] SUNRPC: Handle -ETIMEDOUT return from tlshd
Date: Wed,  5 Mar 2025 18:47:29 +0100
Message-ID: <20250305174504.622610278@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b69e6290acfab..171ad4e2523f1 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2580,7 +2580,15 @@ static void xs_tls_handshake_done(void *data, int status, key_serial_t peerid)
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



