Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB554EB34;
	Tue, 23 Jan 2024 00:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970131; cv=none; b=bHyeCMeOEH6+thsM+kr5wC20Ozo+HvfBtiSOu+dhoqWZnskJN4SUPSIIJiegVhsJbLmYvRPVN1UUkZUfkhyy+kNpbzcbIuU8LkNO29u38dd63WZUuDKeCN+HYQhP9KvCKBJ2n3Mlisoj5yvuc8bXHEUI/oglL/bgkblRzl12SYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970131; c=relaxed/simple;
	bh=gT6Et5ZgdQ2ncZTHtr+9VYUK1YdApEaUXPkiwhlTtkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ahz/FuA7x0nqHT6+8JR+2dwLB/sYdpB+uLWbj0MfUDN29D/gRcbZeqM4+ToQ+6L4NSnvuUvqbzDPA4JAtQTFptmj8GdhIRZZvdbDjOY9N1JHAnF76N8AF/iA7zJuM5MkdCvQruAsItXQL7XTdhHnQIAXQ6C2YzC5TJdL3j5+9aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umHLIGQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umHLIGQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90FEC433C7;
	Tue, 23 Jan 2024 00:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970131;
	bh=gT6Et5ZgdQ2ncZTHtr+9VYUK1YdApEaUXPkiwhlTtkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umHLIGQ1WegsHmjVWzl970j6Vfr+TFh2PitUNAQCHvoHh49gqcnJSmWdMerrECmhu
	 CaZOxfHTJGh3FMlYNh6WZNjgmYQsWNccAL0a5e8mzUIxpwQicLVqXw9VqMS3yqQKF5
	 z+2Kbwk6tVyE3FIV96MpQnSHgpka8W0iige9Mg3o=
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
Subject: [PATCH 6.7 595/641] mptcp: refine opt_mp_capable determination
Date: Mon, 22 Jan 2024 15:58:19 -0800
Message-ID: <20240122235836.825924486@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 09312d619018..91c1cda4228f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -157,7 +157,7 @@ static int subflow_check_req(struct request_sock *req,
 
 	mptcp_get_options(skb, &mp_opt);
 
-	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
+	opt_mp_capable = !!(mp_opt.suboptions & OPTION_MPTCP_MPC_SYN);
 	opt_mp_join = !!(mp_opt.suboptions & OPTION_MPTCP_MPJ_SYN);
 	if (opt_mp_capable) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
@@ -254,7 +254,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	subflow_init_req(req, sk_listener);
 	mptcp_get_options(skb, &mp_opt);
 
-	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
+	opt_mp_capable = !!(mp_opt.suboptions & OPTION_MPTCP_MPC_ACK);
 	opt_mp_join = !!(mp_opt.suboptions & OPTION_MPTCP_MPJ_ACK);
 	if (opt_mp_capable && opt_mp_join)
 		return -EINVAL;
@@ -486,7 +486,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 
 	mptcp_get_options(skb, &mp_opt);
 	if (subflow->request_mptcp) {
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC)) {
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPC_SYNACK)) {
 			MPTCP_INC_STATS(sock_net(sk),
 					MPTCP_MIB_MPCAPABLEACTIVEFALLBACK);
 			mptcp_do_fallback(sk);
@@ -783,7 +783,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 * options.
 		 */
 		mptcp_get_options(skb, &mp_opt);
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC))
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPC_ACK))
 			fallback = true;
 
 	} else if (subflow_req->mp_join) {
-- 
2.43.0



