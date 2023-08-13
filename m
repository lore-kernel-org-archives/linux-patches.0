Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D809446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F91EC433C8;
	Sun, 13 Aug 2023 21:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963079;
	bh=+/7OtCizogLxvq732zG/lBkpMzYp7+dmYrChBNo9WwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeMaH1SqCOOkkp0kYAy3dwsXuh0rK7svBNTT67cDTbo8f+uA/aAa5qddf0vf/jAYk
	 DcJRIVn3b0HLasnTYQc/PFMfe/1JusLWW4Z6A/HaYMzulFuOvLFIH2S6iysFgcQvMO
	 OTotObyGS4Q50hyPxEtnlBnbCLgtuspC/C/+stfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 5.15 45/89] bpf, sockmap: Fix bug that strp_done cannot be called
Date: Sun, 13 Aug 2023 23:19:36 +0200
Message-ID: <20230813211712.142797146@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

commit 809e4dc71a0f2b8d2836035d98603694fff11d5d upstream.

strp_done is only called when psock->progs.stream_parser is not NULL,
but stream_parser was set to NULL by sk_psock_stop_strp(), called
by sk_psock_drop() earlier. So, strp_done can never be called.

Introduce SK_PSOCK_RX_ENABLED to mark whether there is strp on psock.
Change the condition for calling strp_done from judging whether
stream_parser is set to judging whether this flag is set. This flag is
only set once when strp_init() succeeds, and will never be cleared later.

Fixes: c0d95d3380ee ("bpf, sockmap: Re-evaluate proto ops when psock is removed from sockmap")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20230804073740.194770-3-xukuohai@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skmsg.h |    1 +
 net/core/skmsg.c      |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -63,6 +63,7 @@ struct sk_psock_progs {
 
 enum sk_psock_state_bits {
 	SK_PSOCK_TX_ENABLED,
+	SK_PSOCK_RX_STRP_ENABLED,
 };
 
 struct sk_psock_link {
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1124,13 +1124,19 @@ static void sk_psock_strp_data_ready(str
 
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
 {
+	int ret;
+
 	static const struct strp_callbacks cb = {
 		.rcv_msg	= sk_psock_strp_read,
 		.read_sock_done	= sk_psock_strp_read_done,
 		.parse_msg	= sk_psock_strp_parse,
 	};
 
-	return strp_init(&psock->strp, sk, &cb);
+	ret = strp_init(&psock->strp, sk, &cb);
+	if (!ret)
+		sk_psock_set_state(psock, SK_PSOCK_RX_STRP_ENABLED);
+
+	return ret;
 }
 
 void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
@@ -1158,7 +1164,7 @@ void sk_psock_stop_strp(struct sock *sk,
 static void sk_psock_done_strp(struct sk_psock *psock)
 {
 	/* Parser has been stopped */
-	if (psock->progs.stream_parser)
+	if (sk_psock_test_state(psock, SK_PSOCK_RX_STRP_ENABLED))
 		strp_done(&psock->strp);
 }
 #else


