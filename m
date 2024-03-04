Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429AC7BAE6;
	Mon,  4 Mar 2024 21:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589236; cv=none; b=gBdSoaItFmqLZDtMTNckbqCN8fRO5vG+TURZH0czy9WbDVWyi5zigdfRvP3BBM2fNImZXaZHGGnTe64VeSWLv5cOJIbc66eDqZ4RtBmWzeXwSUVm/vfO1gNPyA0Zmif22/gSMwC0C7D6a9sTpeJwnkXVht2sPxuz4hLBKheI+yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589236; c=relaxed/simple;
	bh=TgAXctvB+AkODeXepa9e10RNlQ+6JsTjP5tDCCz1U94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlttT0HslTTcGET/srk+H3ue4r1CV7Jc557h2dLQszc7Asigtdgh6lBUMDhUYtC+6aQEbt921ejH2nq1mVosA02iYM4jZ2sil7/M6Y3ps8JCF8i2L4P2h2QC59+9uXQgT5LBzx11xuyBK/v/JIkt0j563Fkb9TeRNhy6tvbnuCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2JdXoYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2JdXoYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8571C433F1;
	Mon,  4 Mar 2024 21:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589236;
	bh=TgAXctvB+AkODeXepa9e10RNlQ+6JsTjP5tDCCz1U94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2JdXoYN6dgQdg14Gy2YsTENytUMUNrg2qK+Y7v31Mo4Vm0lhzlaMaXNgTMbzNsrg
	 mPyNqdWN2VUdpT5q27oKowcmZ/PaYqMsV4Gk762x5I8MJJzIJ7Qj1eBkqUTo8rMX8k
	 QxsjvBkhbwNOUAwTJnrsI9yIzAPJ+dnXTiCKltpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/84] tls: rx: drop unnecessary arguments from tls_setup_from_iter()
Date: Mon,  4 Mar 2024 21:24:05 +0000
Message-ID: <20240304211543.401104359@linuxfoundation.org>
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

[ Upstream commit d4bd88e67666c73cfa9d75c282e708890d4f10a7 ]

sk is unused, remove it to make it clear the function
doesn't poke at the socket.

size_used is always 0 on input and @length on success.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index eed32ef3ca4a0..cf09f147f5a09 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1348,15 +1348,14 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 	return skb;
 }
 
-static int tls_setup_from_iter(struct sock *sk, struct iov_iter *from,
+static int tls_setup_from_iter(struct iov_iter *from,
 			       int length, int *pages_used,
-			       unsigned int *size_used,
 			       struct scatterlist *to,
 			       int to_max_pages)
 {
 	int rc = 0, i = 0, num_elem = *pages_used, maxpages;
 	struct page *pages[MAX_SKB_FRAGS];
-	unsigned int size = *size_used;
+	unsigned int size = 0;
 	ssize_t copied, use;
 	size_t offset;
 
@@ -1399,8 +1398,7 @@ static int tls_setup_from_iter(struct sock *sk, struct iov_iter *from,
 		sg_mark_end(&to[num_elem - 1]);
 out:
 	if (rc)
-		iov_iter_revert(from, size - *size_used);
-	*size_used = size;
+		iov_iter_revert(from, size);
 	*pages_used = num_elem;
 
 	return rc;
@@ -1519,12 +1517,12 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			sg_init_table(sgout, n_sgout);
 			sg_set_buf(&sgout[0], aad, prot->aad_size);
 
-			*chunk = 0;
-			err = tls_setup_from_iter(sk, out_iov, data_len,
-						  &pages, chunk, &sgout[1],
+			err = tls_setup_from_iter(out_iov, data_len,
+						  &pages, &sgout[1],
 						  (n_sgout - 1));
 			if (err < 0)
 				goto fallback_to_reg_recv;
+			*chunk = data_len;
 		} else if (out_sg) {
 			memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 		} else {
-- 
2.43.0



