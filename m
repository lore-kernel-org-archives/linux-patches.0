Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624290;
	b=aw/UgGcoKFxKOwKqO3pt+v44C/E6tnUzcJZ/n/tqJrr14PMTf2jD03eOj7s3V6hjABWK
	 hIhve8oTh3owu7UZ7pXmuLa7dKZLHbOWyU070VRxZLfzKeSvw7/9dVOhiBK/jZZ9K34h/
	 85hkqp/Uk025rDIJoUK//COzPSAjSyK38wZbi1z/MmiZohYu09lWTtBel2b1vla9YuWDB
	 H83ryjy0ol6mol3lx63Ao/XzlKbCxz75rv/Am86j0LsbYkWFcPLZSC3+FFvPVrzO9ZOmQ
	 qqCMYIoWWWvx+NbQZPRIZCcESpxDVfP+30asPmB5fNlDhojJ2dg1cyW9dQwxvDr2DPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1+Iei4d26zrviS/2LTOhHmIp4bEg/eHtw18snSBSQwk=;
	b=P3snbXgxRPkZTMyP9aIcdvdG30uqDMahM6IjHqWW8WnBInVeQjbuO/lDb02PwZQu/kqH
	 u6ato4vOMblp95Gb3DBRde6iREEZ8Kqe8hchCqKtbFUP0/XejSwkFS6cJbuQeGsrY7+p9
	 zItDV4wkRd8Pkp2nZxs6qpZIRV70UcYJHemOI28N2iYvQi56ssoG8wctE10euK7+lhNmd
	 JkiD1XHcBhRM04JMKvW53Yavyjc7I/M/K2ZN7p4MCn7ax3V6ZqS8xH/NPtMq+q+lmvk5A
	 IKrHwtWj1i3c99d+jyAoYqHglw2FMWzOz65uK+s5U+UO83CEbpSnWK+jkPmSrRoOaKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VMEVa5id;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB02606A68F;
	Wed, 25 Nov 2026 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VMEVa5id
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25B91F000CF;
	Wed, 25 Nov 2026 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624289;
	bh=1+Iei4d26zrviS/2LTOhHmIp4bEg/eHtw18snSBSQwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMEVa5idDGkqUAZEsrEA5XxBD7USJssJZyIBfV38kYPjgKRGxX50kKuSMQIB5OOUK
	 x2EHMVlb4bd5unMGnkhaWQGZtXHG8MfArUaixQ6fiwqsCiSStjYvmeKtkKv2LzzQz9
	 3977zMFwdqMdn/4g65dZbAZKUHT/Ruxi8e6mQZtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/816] net/iucv: take a private, writable frame before rewriting it in place
Date: Wed, 25 Nov 2026 15:28:14 +0100
Message-ID: <20261125143852.577757686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit f38bce9af9e2a3cced7d303a1476f21c1f42bcb7 ]

afiucv_hs_rcv() rewrites the frame in place -- EBCASC() on four name
fields, then afiucv_swap_src_dest() swaps them and pushes an Ethernet
header -- and can hand the same skb to dev_queue_xmit(), without making
it private first, so a packet socket that also gets the frame reads the
rewritten names. An ETH_P_ALL tap runs first and leaves af_iucv a
cloned skb; a socket opened for ETH_P_AF_IUCV sits on a ptype_specific
list, walked after ptype_base[], so deliver_skb() takes a reference and
af_iucv runs on an skb that is shared but not cloned.

Unshare, then cow, in that order: skb_cow() can reach
pskb_expand_head(), which has BUG_ON(skb_shared()). skb_cow() tests
skb_cloned(), which is what a rewrite of the data needs; skb_cow_head()
tests only the header. Asking for ETH_HLEN also covers the unchecked
push in afiucv_swap_src_dest(); on the ordinary path eth_type_trans()
has already pulled that much, so it only compares.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Closes: https://sashiko.dev/#/patchset/20260813-b4-disp-60433a46-v1-1-509e1200533e@proton.me?part=1
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261028-b4-disp-1edbbc34-v3-1-13495411f5b9@proton.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index c7017ab56b1e7..39f82cdbd1bb8 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2071,11 +2071,20 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	int err = NET_RX_SUCCESS;
 	char nullstring[8];
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		return NET_RX_SUCCESS;
+
 	if (!pskb_may_pull(skb, sizeof(*trans_hdr))) {
 		kfree_skb(skb);
 		return NET_RX_SUCCESS;
 	}
 
+	if (skb_cow(skb, ETH_HLEN)) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
 	trans_hdr = iucv_trans_hdr(skb);
 	EBCASC(trans_hdr->destAppName, sizeof(trans_hdr->destAppName));
 	EBCASC(trans_hdr->destUserID, sizeof(trans_hdr->destUserID));
-- 
2.53.0



