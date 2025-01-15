Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAD4248BB2;
	Wed, 15 Jan 2025 10:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937944; cv=none; b=LdADKw2NtC5/WuRBnq/XvCWdRmeQqi+AD9ip7WJwKJAet1uALgCZmN79s9G7o3KrQWPwNlVYxWhFPMa1/gd+T5pEpCSII/QB9+azy5/OVOfKPdSu743sm/6lOHDRMiGvx9QvhZzYaTi31BQHS0LZT8MMp6lHJewFJb+hhEpmZio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937944; c=relaxed/simple;
	bh=SgdlEe02j9fAlXgAFdmtSniebkK1C8dHQxY1UBG/hQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6Y8zHkQUNf2dFI6ZDN/x4fyeiQmj4rSwSZBn4wUxjbISTRNH9vcIVlXp3o2TJXedqpKy57k5BzusrRS+paqci6GaYGYodsofWswUDUIdqB2QsqCYHF/zKAybhgU+hRV2saK5bACbDd/QEv89uhlLXKinnbCEFO8yosH2FNq274=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCVM2zMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCVM2zMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0778C4CEDF;
	Wed, 15 Jan 2025 10:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937944;
	bh=SgdlEe02j9fAlXgAFdmtSniebkK1C8dHQxY1UBG/hQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCVM2zMmwYao/Dw97f9eySnIkPReOjMYHvwzHApYi7qUTpRHEO7gkyzSzYeV7WVtE
	 8LCTXq5Bar5m3m7BT/3nf/NF6QIAL2mlSaeVeUKBQX0YNxqsXAlDqcbm27yiwBY4dA
	 MWc77Bqg4A7BWrV4RT/Y1z4X04jBv3tW/KI7I4aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/189] tls: Fix tls_sw_sendmsg error handling
Date: Wed, 15 Jan 2025 11:35:34 +0100
Message-ID: <20250115103607.882544682@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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
index bbf26cc4f6ee..7bcc9b4408a2 100644
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



