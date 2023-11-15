Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CBF3C465
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1qClOgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FE5C433CA;
	Wed, 15 Nov 2023 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077190;
	bh=RALN69McNKmgd7W0NJrnS+XGvpprvSHYFaQ3qblKv3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1qClOgBD+cCg7WHp2Ybcxhdegwk9YMmixG3E3MvZpEmwcpSQDGYUX246YyMf/JZt
	 BE0P66BcQ+dNwc+FQReRajAz5816p0jZjUBfKmCCtQUB/4vQDlXctl6lVFx6+lW5j5
	 jlUAVMIIm/fJfOU/doF6Xr6UAsy9mNrzQWylSruc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/603] mptcp: properly account fastopen data
Date: Wed, 15 Nov 2023 14:11:38 -0500
Message-ID: <20231115191623.769180902@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit bf0e96108fb6707613dd055aff5e98b02b99bb14 ]

Currently the socket level counter aggregating the received data
does not take in account the data received via fastopen.

Address the issue updating the counter as required.

Fixes: 38967f424b5b ("mptcp: track some aggregate data counters")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231023-send-net-next-20231023-2-v1-2-9dc60939d371@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/fastopen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/fastopen.c b/net/mptcp/fastopen.c
index bceaab8dd8e46..74698582a2859 100644
--- a/net/mptcp/fastopen.c
+++ b/net/mptcp/fastopen.c
@@ -52,6 +52,7 @@ void mptcp_fastopen_subflow_synack_set_params(struct mptcp_subflow_context *subf
 
 	mptcp_set_owner_r(skb, sk);
 	__skb_queue_tail(&sk->sk_receive_queue, skb);
+	mptcp_sk(sk)->bytes_received += skb->len;
 
 	sk->sk_data_ready(sk);
 
-- 
2.42.0



