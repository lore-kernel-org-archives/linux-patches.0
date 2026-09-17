Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9184F402D;
	Thu, 17 Sep 2026 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666001; cv=none; b=l8e3SqwJKZUm6ILaZWc5zjFe+FOicu1VQP6YVfiJKCAFrnNAFbrWUE/O9MX71CO/w2ka0kbkHjeVrfdAZaT5fzzEBqurK8anOAIziSsvjKFvBf/PM4OwyayItC2AY8ykzO2nYI/OwkeUlxDtldp0GuXiZ03D8vsL3kyTS8bwZ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666001; c=relaxed/simple;
	bh=WIcoZSDpS2e3ExoSwQ+Llo/cX35tQFQXwOo/bYazWQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVOXHHKA8ipsUxWGJ+fCPaPLZi67xMSJk3pXvmgByXHaF9SDbR8nuQZ3AAoG3q9IqduvlF0HRS5pYMIVUKX1IPXo3CVu5MgYb0C/Mqx1KmAFFyk8oBYQgAXXv2L0+rQT8icNUrOkFBSVkXwTdTYdzpw2viEkM8D7d5MzYhdx/pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0TmkGBs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0TmkGBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F311F000FF;
	Thu, 17 Sep 2026 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665999;
	bh=qS70nZFeA2ONAm2iiNYT6p8S8BUmqbJgp3nDTZ0wOMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0TmkGBsRmmua6HDhGSlciWav5JVCbzCowR5aLHks4l7l0r6qZv2RtU8Vgo8FSQZ2
	 cf2c39MnXMZk3M/2rxrty4S6vOO2C90b9443BJ0BbE9CYJZcwPU2xTDlDyET15mASZ
	 nQW+76UnYDssS+Dx0nOPOHYu02XKj8AkYqq1GLAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0890/1250] mptcp: remove unneeded READ_ONCE() annotation
Date: Thu, 17 Sep 2026 16:11:25 +0100
Message-ID: <20260917151616.108058210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit caa4a79f74f32084ce28aee8653bc04df745970d ]

The subflow->fully_established flag is always written under the subflow
socket lock. Reading such value under the same lock does not require any
ONCE annotation.

Fixes: 581c8cbfa934 ("mptcp: annotate data-races around subflow->fully_established")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-10-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  | 4 ++--
 net/mptcp/protocol.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 7f7aa5af6092c..45deaa3279e61 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -530,7 +530,7 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 		return false;
 
 	/* MPC/MPJ needed only on 3rd ack packet, DATA_FIN and TCP shutdown take precedence */
-	if (READ_ONCE(subflow->fully_established) || snd_data_fin_enable ||
+	if (subflow->fully_established || snd_data_fin_enable ||
 	    subflow->snd_isn != TCP_SKB_CB(skb)->seq ||
 	    sk->sk_state != TCP_ESTABLISHED)
 		return false;
@@ -997,7 +997,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 	/* here we can process OoO, in-window pkts, only in-sequence 4th ack
 	 * will make the subflow fully established
 	 */
-	if (likely(READ_ONCE(subflow->fully_established))) {
+	if (likely(subflow->fully_established)) {
 		/* on passive sockets, check for 3rd ack retransmission
 		 * note that msk is always set by subflow_syn_recv_sock()
 		 * for mp_join subflows
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 20c449fd74102..4f22cd78abaec 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3614,7 +3614,7 @@ static void schedule_3rdack_retransmission(struct sock *ssk)
 	struct tcp_sock *tp = tcp_sk(ssk);
 	unsigned long timeout;
 
-	if (READ_ONCE(mptcp_subflow_ctx(ssk)->fully_established))
+	if (mptcp_subflow_ctx(ssk)->fully_established)
 		return;
 
 	/* reschedule with a timeout above RTT, as we must look only for drop */
-- 
2.53.0



