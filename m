Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE1D13EFEC;
	Tue, 23 Jan 2024 01:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972012; cv=none; b=WkmgsVl6MLVaZFoEVq3EnFLkQnzHN9c9zaKEjioAUCKY1xUTZoAc267Hre3eOlF/vzcbAdFfw4MHcmVQtYozfyfhClVz01lPzdH1XNTGcO2p8jbcRXqUcjkJPrwBYxM9xMr/QrT4eikx5HyZkYPGA9nt5fFwjdFWxLIidpQmQDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972012; c=relaxed/simple;
	bh=zgp89Gx/n9qEeC85ua0NtpqJr2R2HJsFxxKcsVJM/eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvaQAJsTv9Yz60/wvdTmVx7M2zH7ICmVKpY+x9S87jR6++d9rTA87A8sElURijy5mRNboTVCx+FJouZmR44tDLZc6ztBs2mdq2ISIjgUBPMNJdfTGY6fOlpUm1wcBqjC+3lAAdW6aCSYFJ4mhiQVIqjGeW5PFndX2salpdIbmD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lA40r1Er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lA40r1Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81441C43394;
	Tue, 23 Jan 2024 01:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972012;
	bh=zgp89Gx/n9qEeC85ua0NtpqJr2R2HJsFxxKcsVJM/eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lA40r1Er+Wb9xclQ9NKsdKowhiyK0Fy+JTx/Grr81BSkiteGH2tX6+LnmHh3j6juJ
	 ukAbvRWKCODwPqgeeTfNt9rBxsBMKv5q6kQUDpEoAJstuyw0jIxIuwhBlGrzv/VjW4
	 K6vh+ue3xlLVMydsL4yU9MQ61bIPBv+Vp3qYwSMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 386/417] mptcp: refine opt_mp_capable determination
Date: Mon, 22 Jan 2024 15:59:14 -0800
Message-ID: <20240122235805.141145900@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 724b00c12957973656d312dce2a110c75ae2c680 ]

OPTIONS_MPTCP_MPC is a combination of three flags.

It would be better to be strict about testing what
flag is expected, at least for code readability.

mptcp_parse_option() already makes the distinction.

- subflow_check_req() should use OPTION_MPTCP_MPC_SYN.

- mptcp_subflow_init_cookie_req() should use OPTION_MPTCP_MPC_ACK.

- subflow_finish_connect() should use OPTION_MPTCP_MPC_SYNACK

- subflow_syn_recv_sock should use OPTION_MPTCP_MPC_ACK

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Fixes: 74c7dfbee3e1 ("mptcp: consolidate in_opt sub-options fields in a bitmask")
Link: https://lore.kernel.org/r/20240111194917.4044654-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 95cd4f6d83e6..f0ebf39db6cc 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -156,7 +156,7 @@ static int subflow_check_req(struct request_sock *req,
 
 	mptcp_get_options(skb, &mp_opt);
 
-	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
+	opt_mp_capable = !!(mp_opt.suboptions & OPTION_MPTCP_MPC_SYN);
 	opt_mp_join = !!(mp_opt.suboptions & OPTION_MPTCP_MPJ_SYN);
 	if (opt_mp_capable) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
@@ -253,7 +253,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	subflow_init_req(req, sk_listener);
 	mptcp_get_options(skb, &mp_opt);
 
-	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
+	opt_mp_capable = !!(mp_opt.suboptions & OPTION_MPTCP_MPC_ACK);
 	opt_mp_join = !!(mp_opt.suboptions & OPTION_MPTCP_MPJ_ACK);
 	if (opt_mp_capable && opt_mp_join)
 		return -EINVAL;
@@ -415,7 +415,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 
 	mptcp_get_options(skb, &mp_opt);
 	if (subflow->request_mptcp) {
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC)) {
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPC_SYNACK)) {
 			MPTCP_INC_STATS(sock_net(sk),
 					MPTCP_MIB_MPCAPABLEACTIVEFALLBACK);
 			mptcp_do_fallback(sk);
@@ -713,7 +713,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 * options.
 		 */
 		mptcp_get_options(skb, &mp_opt);
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC))
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPC_ACK))
 			fallback = true;
 
 	} else if (subflow_req->mp_join) {
-- 
2.43.0



