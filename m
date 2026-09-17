Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62E6379C40;
	Thu, 17 Sep 2026 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670716; cv=none; b=Sx0x0oqu70MGBLdveNB4vhrh/WBb2HfCAX54Uhn882M/UnWqWJyZDSuEeMnip00cwj7451FCneie63Lg5THJh3YhRRgQ62+YdJryjbkpo/iKZvRjO4wDLUDfTtFM9TfCWlK1vM79WuUPtpRAEAR31ozgi7QoVOvCtgDpAFh0bN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670716; c=relaxed/simple;
	bh=fizTFlJyWa/sKrMx01R8Gd//OIqEiwHXkxAGPrUaUNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLD6GJcwEXqJ3AqCZKQGVrCHXC5HNmJmU+xV9PN1CdKmAKcrk3iyyLX8BT2GuDfoCAEdzT7iY4SBClTPHn2oaSWIljl7+4um3VIbWhZX0NOXOQqVj3+gt9cfTECtYJF19wCWME1NaJYPtfRYRQnQ+gT438+eHxjYoXN0vEYPdcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbTkVbyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbTkVbyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C091F000FF;
	Thu, 17 Sep 2026 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670715;
	bh=05AcZUkT1iyq0yUF9SJi68XEjUD1jjuM68BLgCdMy94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbTkVbyjbDON+VwDm7vk7SAZWtr6ewmv1bryzFT2rZTrQu5jJnG+saTlxnLghM4gi
	 6MFZiyIawSSUY+H8KiYJ+q6FTgUHSXEZsTfx5NzvwKS+sGanDrc5HJGs3bXP3tISWA
	 sv9mCPIkTp9RkML5c2rv7KtGpTZmw4G+hcef8THo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0746/1102] mptcp: remove unneeded READ_ONCE() annotation
Date: Thu, 17 Sep 2026 16:11:29 +0100
Message-ID: <20260917151559.142483517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 41aa6c9442586..1a71d4d5be325 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -531,7 +531,7 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 		return false;
 
 	/* MPC/MPJ needed only on 3rd ack packet, DATA_FIN and TCP shutdown take precedence */
-	if (READ_ONCE(subflow->fully_established) || snd_data_fin_enable ||
+	if (subflow->fully_established || snd_data_fin_enable ||
 	    subflow->snd_isn != TCP_SKB_CB(skb)->seq ||
 	    sk->sk_state != TCP_ESTABLISHED)
 		return false;
@@ -998,7 +998,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 	/* here we can process OoO, in-window pkts, only in-sequence 4th ack
 	 * will make the subflow fully established
 	 */
-	if (likely(READ_ONCE(subflow->fully_established))) {
+	if (likely(subflow->fully_established)) {
 		/* on passive sockets, check for 3rd ack retransmission
 		 * note that msk is always set by subflow_syn_recv_sock()
 		 * for mp_join subflows
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a4054ed246052..2f34e92d9cced 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3685,7 +3685,7 @@ static void schedule_3rdack_retransmission(struct sock *ssk)
 	struct tcp_sock *tp = tcp_sk(ssk);
 	unsigned long timeout;
 
-	if (READ_ONCE(mptcp_subflow_ctx(ssk)->fully_established))
+	if (mptcp_subflow_ctx(ssk)->fully_established)
 		return;
 
 	/* reschedule with a timeout above RTT, as we must look only for drop */
-- 
2.53.0



