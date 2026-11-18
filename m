Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027781;
	b=FxBtV2mnDWq2Eg0ckkZoP3RXt9EQKzHoRJ5SCfbqdK74OKsBqbCOoxwWvIrnWs+xIPUI
	 vX5fg1/s8wigclc3YB0fDHV2Ls08ZhusP3UXKnsp0oW6zeqYFZxQhR+wNcMbECnzaFxbx
	 h7xd9GyKYnBhtk9hVRXfsBsgSiEjlqK+Zh5MVdxMd6UaDfdiz9nEeMvfa+4Lf2dVsAlZG
	 TkHVt0srTE/n4El65ZkiJ9iFJ6t7Q3Ac0oh7tAEfYTXg+O3L7UVD1YfC6R7X4E5JI/Z/O
	 WaCnvXYAg8DW57yFh6e02g4+fITgRgnjvCJBzn5KkvEaIYQxVhDVfRjyeCDlpwwyMFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eoFBdczWpEG6VfqzMObIZW5xhEkgX7LJPcLWuum/zPM=;
	b=YBcAHSSsZOB/IbnrIyi7zAnW3mw1iRzL+8fY9qqoODc7dNH3mTul332jU/gVq/n8zdrs
	 PTBjVp7ANAgB87LoSg3at1bXA+VAtOin+JOMYt0xPsQj+RqM/P+Wc/qnRJc56AfrEPvJr
	 G4wR0KcudK0n8eK+m+7EAglJhM/idnkJaVgx2L7M+seDQsWulp2SQKMinSZNFSVOgq5ep
	 cAjpzUJF1FyXUTS3HfDHFuUQRp557yAVUcGl0lJZ+1odjjp/QunoVDU4as63BwqUKOsdB
	 f0Nn22NO0whJ0AXrYFP8NTx8niKdH8T+VFLMavsJl/zxX8joGMxltM4bErWO0Vq5ZEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zO+jzOst;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F211606A320;
	Wed, 18 Nov 2026 18:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zO+jzOst
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16B51F000C7;
	Wed, 18 Nov 2026 18:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027781;
	bh=eoFBdczWpEG6VfqzMObIZW5xhEkgX7LJPcLWuum/zPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zO+jzOstmYVrdmGukLScJDsLqKelKKOL0pDxFMmYBbLWwrPgLORDFlSvjfZh8WqZC
	 PMTds03lLnKbuzJ3hQu64mLbbzhLFK1PEzX1DUDApR40Bg87Xl0yPCrfaydlmp8n81
	 AiyP6UlrhwB37r0bW5zAxGkOdIvVIKbCq36nZJd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1870/2151] gtp: hold RCU for the device lookup when adding a PDP context
Date: Wed, 18 Nov 2026 16:00:05 +0100
Message-ID: <20261118150229.916467140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Kaushik <anilkaushikwireless@gmail.com>

[ Upstream commit fe3e1a42fb7eb18d8c55d714b50a3d51f8cd6ffe ]

gtp_genl_new_pdp() calls gtp_find_dev(), which looks the device up with
dev_get_by_index_rcu(). Since commit e2d1baca2b33 ("gtp: remove useless
rcu_read_lock()"), this only runs under the rtnl lock, and kernels with
CONFIG_PROVE_RCU_LIST warn:

  WARNING: suspicious RCU usage
  net/core/dev.c:1047 RCU-list traversed in non-reader section!!
  ...
   dev_get_by_index_rcu
   gtp_find_dev
   gtp_genl_new_pdp

Hold the RCU read lock around the lookup only: gtp_pdp_add() allocates
with GFP_KERNEL, and the rtnl lock keeps the device alive afterwards.

Found with the gtp selftest on a debug kernel.

Fixes: e2d1baca2b33 ("gtp: remove useless rcu_read_lock()")
Signed-off-by: Anil Kaushik <anilkaushikwireless@gmail.com>
Link: https://patch.msgid.link/20261016093225.1036375-3-anilkaushikwireless@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index ecc9e0f088caa..779ab090ef149 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -2050,7 +2050,10 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 
+	/* the rtnl lock keeps the device alive once found */
+	rcu_read_lock();
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
+	rcu_read_unlock();
 	if (!gtp) {
 		err = -ENODEV;
 		goto out_unlock;
-- 
2.53.0



