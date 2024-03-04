Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B31078B47;
	Mon,  4 Mar 2024 21:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589228; cv=none; b=c1OAJNdkGB1reZ17zdSILMi6IJQ38ZQZrOuXXG3IIyJwi4JDe8/1E9Lfi00ptou9rC4O8nrbi1ZRxkMSmDATOh+3Dk5l6aKXV2TA4poF+M94v606UYjNCoL5Tn/04zrNMOa8O8bRoPGgcRcwRWr5Da+VBj6If8WlIEJFetJYoDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589228; c=relaxed/simple;
	bh=Lg0DSmxv2ktsC1eOFgchb5XShOcFWQoy1quwRxixxtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAGF5NnYUHJlC4/v8wiqZ/KZ2Jy0rsSKAVz2urnpwvj2JUmqDVMIqaHf/ZDKhv38vMK4P/qd2+7CPDeUtthvS1AsXMzvo22RPGrjlpu6kowJFHj8FNZBoGNZb5WNdQQeECPdCuRDdjZ2pzcuZIED+5ClxZgfzGEmxd6LMct2c5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz1/NXZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz1/NXZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A3C433C7;
	Mon,  4 Mar 2024 21:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589228;
	bh=Lg0DSmxv2ktsC1eOFgchb5XShOcFWQoy1quwRxixxtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz1/NXZ1i8jywmRZ7lBZzfHhbo/jUvSBpICSLtHw92I8HIBseGnzvKE6kRQvJDwUn
	 MWk7rDJEQexHzHSYuEBEYp0+rXJ2/c5QZfSjuf74t/NTTXSiG5bsnjqLRT7KnaSjMq
	 AX6fgMPxGuTAJpWv29TXbTsMbuRwjxqRwsCPL9iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/84] tls: rx: dont issue wake ups when data is decrypted
Date: Mon,  4 Mar 2024 21:24:02 +0000
Message-ID: <20240304211543.304699537@linuxfoundation.org>
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

[ Upstream commit 5dbda02d322db7762f1a0348117cde913fb46c13 ]

We inform the applications that data is available when
the record is received. Decryption happens inline inside
recvmsg or splice call. Generating another wakeup inside
the decryption handler seems pointless as someone must
be actively reading the socket if we are executing this
code.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0a6630bbef53e..5fdc4f5193ee5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1557,7 +1557,6 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 			      bool async)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
 	struct tls_msg *tlm = tls_msg(skb);
@@ -1596,7 +1595,6 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		rxm->full_len -= prot->overhead_size;
 		tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 		tlm->decrypted = 1;
-		ctx->saved_data_ready(sk);
 	} else {
 		*zc = false;
 	}
-- 
2.43.0



