Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061978;
	b=TwDBN8lkvRd+/rqkHUCdnSzYu+dlHQyJuVrFdLR6Y7LI5LsnpopHUb/CA8+TL62o/Yf2
	 mBneRa4iBuCZXBZJyn4RfS5V04w35dUAGpg7LIJ9ETkbGA0h8WPvCSc1P/Lw1VDhYmpPq
	 mnF62ZSox8XSeVvXRofLbJnhUhTX1/Pb6Nppp9awQwkI7Xt2B8GaldnYZQzbGDVuePGEU
	 Rl7FF8vhemUgnyzlx7JgytIcm2zUHo/mJcUzIK7zM/ZzQJN2AKtn76upccTcErJxzMDA/
	 okFMDEMLHuxuLOOoGV+1eduIs4p/Z94ETXn8CDJFjA2D3kBoW7hFkV8gCglNjti5ORA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lJQ8g6TJ73BfBs0VOc7eZwDWa4kkb8XTafWfbHJ5PMY=;
	b=uv+SfYj2BUgCIvdboWhpKFPOtYPmvyMMTMq9u0lH3BxWB1S+5IXuE1uVQoaQCVin1+GH
	 NcqX1LqDXj0UD3iHLyhhm0d47umtWWUl3UpB6Hr9aKvgPbAFfnnEDJPgQ/5qPtcb0HcNC
	 cNN6WvqZPZtqDu15fRs75W5oQF7gl49yMUvpPtVIob639v5Wjjr/g7AawoFR6BKaid2j2
	 rf87+vxg3m7DksCjBA38So5j5ZEytgf4uU2YjgyCfs4qCDC3GbbX4qrLvPwhu79CM/blh
	 GH2Yt2CxJYlFU6x/50jbEfA7j7YE7R8Spyk7wAvJINq7gIXyDT4nLmAgtwM7oFjs/Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvSj3je2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB4C606A32C;
	Thu, 19 Nov 2026 04:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvSj3je2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC581F000C4;
	Thu, 19 Nov 2026 04:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061978;
	bh=lJQ8g6TJ73BfBs0VOc7eZwDWa4kkb8XTafWfbHJ5PMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvSj3je2JM9gtbB2ZBRqJyhpS05wwIB9BM/eSAKgRLVGEtOU1j5gWWavCgFgaCE8K
	 psLsbBKW5p+gEQxYmm6y/TMQXOj7Qpg8+PPxXyd3oHgA912PEglG3EeBGUvGz89yVa
	 LQa7Fk0U5SjPiNpwdNQVw0aIh9834qVHAAGWqmC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1747/1848] gtp: hold RCU for the device lookup when adding a PDP context
Date: Wed, 18 Nov 2026 16:03:05 +0100
Message-ID: <20261118150032.634670702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4112bec371024..b5297bf6df96f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1085,7 +1085,10 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 
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



