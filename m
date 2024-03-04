Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1D21C6AB;
	Mon,  4 Mar 2024 21:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589251; cv=none; b=R5vCcoiJ3lYbSYarC0CjpiS3kTNzekYfhGmhxQkD9/EuTwynb4vBxq+5bqLP8vwUa3ENvN8ip5tU/ANvK4Y1oIzpruaEJonLPe0n9ttxGqXZoLF7k68CjQUiNfYqxWH/Xk4wITBe0urwkYWCqma/wmYZVi+Usd0Q5sdn08R4R4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589251; c=relaxed/simple;
	bh=PYKVn9ewNmSqUpVmZX2nRuyqxhk1asNaLM3e+/m7QXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGzw5CErXbU3kGlAmlIqW+j02O7yOuF8FzJzPno5/vxIs8yplfLtYo2ZZpM80eG+trP/i4nnNqaygZqMgXlx6U1TNxCzDyF6eCM04fVw7vlT1HQpN7EoG9bs/e+SMUaFQxb6C23PhaMATOMlIge7EG3nuFelGVXTZ5rHeQ/XZ94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgLx6oYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgLx6oYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F5FC43390;
	Mon,  4 Mar 2024 21:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589251;
	bh=PYKVn9ewNmSqUpVmZX2nRuyqxhk1asNaLM3e+/m7QXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgLx6oYX7EclViWR6inULCwPWLqYw1FU1Wzn2H9+YDjNGoWejmX2x9r49Qof7cbmT
	 7C0Mz0H0LmzNvYk2tLd86yCdCFdnrwNAuUSvyDvAxff3ffwYbcyOerLuADp9iUysDB
	 yagRcTC/wz6PxpbzwIckak1T0Neky3SJLxcLP4po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/84] tls: rx: move counting TlsDecryptErrors for sync
Date: Mon,  4 Mar 2024 21:24:10 +0000
Message-ID: <20240304211543.572885742@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 284b4d93daee56dff3e10029ddf2e03227f50dbf ]

Move counting TlsDecryptErrors to tls_do_decryption()
where differences between sync and async crypto are
reconciled.

No functional changes, this code just always gave
me a pause.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d3bbae9af9f41..85fa49170b4e5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -274,6 +274,8 @@ static int tls_do_decryption(struct sock *sk,
 
 		ret = crypto_wait_req(ret, &ctx->async_wait);
 	}
+	if (ret == -EBADMSG)
+		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 
 	if (async)
 		atomic_dec(&ctx->decrypt_pending);
@@ -1583,8 +1585,6 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	if (err < 0) {
 		if (err == -EINPROGRESS)
 			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
-		else if (err == -EBADMSG)
-			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 		return err;
 	}
 
-- 
2.43.0



