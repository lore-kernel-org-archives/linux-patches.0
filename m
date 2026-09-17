Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBA54E324C;
	Thu, 17 Sep 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659838; cv=none; b=ukiXoIk96YF76Nu7T6QEEY6ysy4t6lk2zgfKIxlVdiZ328EdE2Fy9dAkVwu/WL3GzLxEfIYtCGmC/6826BPwxbtXhdhaCF1By9aA1FndSCZ7IewSr0PEDWZwg5hk/oWtEuPhzGdxXDUSdmcfjafebG9GTCvxBHvjmr5jKwtsMw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659838; c=relaxed/simple;
	bh=eYdGGcU/2nHW5xi7vPYxhYNKMQVSiZ3hIPm4/qwf82g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE1XT3XRU6ptnalUK/j39m6yjOC8oUV5ZdPbrryLpEUK2JI1s9jzbLxw34dYZyDED2HeB3CCd4Tz5FcS7j26ubpg7+x+PZavB9sE6vRNtYzSOaVuoeaNi5wUr5aG7t8bNYW9+/PEpkcjc3ttYiQnHJDYg0+K4mVR0yh2wskH2p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AO0C90ap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AO0C90ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395DC1F00898;
	Thu, 17 Sep 2026 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659832;
	bh=jAE+QvFlq5eVNP2eiaH4D4nzDH7Q1ooP9vMquSZU4Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AO0C90apGPkkOaJyhWeCl4ijv/LjWc/j00YVKMRtCWZ6KdztjuhwawEmb4DRdtqzC
	 Wyu+KSVouIJwL5TDjNQlgeRocg3o3p9NkncqP9SAk8RsDKEEPX3Xs1ybGG+Nj3WauQ
	 u8ubV97vBCklZ4+Yrw/4ANcAV3mpYdsU9gz1hQLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 389/733] mptcp: remove unneeded READ_ONCE() annotation
Date: Thu, 17 Sep 2026 16:11:37 +0100
Message-ID: <20260917151401.396390619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1057d500577b0..6e208b4e024a6 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -529,7 +529,7 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 		return false;
 
 	/* MPC/MPJ needed only on 3rd ack packet, DATA_FIN and TCP shutdown take precedence */
-	if (READ_ONCE(subflow->fully_established) || snd_data_fin_enable ||
+	if (subflow->fully_established || snd_data_fin_enable ||
 	    subflow->snd_isn != TCP_SKB_CB(skb)->seq ||
 	    sk->sk_state != TCP_ESTABLISHED)
 		return false;
@@ -980,7 +980,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 	/* here we can process OoO, in-window pkts, only in-sequence 4th ack
 	 * will make the subflow fully established
 	 */
-	if (likely(READ_ONCE(subflow->fully_established))) {
+	if (likely(subflow->fully_established)) {
 		/* on passive sockets, check for 3rd ack retransmission
 		 * note that msk is always set by subflow_syn_recv_sock()
 		 * for mp_join subflows
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8adf699894e32..5c6923fdcad08 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3743,7 +3743,7 @@ static void schedule_3rdack_retransmission(struct sock *ssk)
 	struct tcp_sock *tp = tcp_sk(ssk);
 	unsigned long timeout;
 
-	if (READ_ONCE(mptcp_subflow_ctx(ssk)->fully_established))
+	if (mptcp_subflow_ctx(ssk)->fully_established)
 		return;
 
 	/* reschedule with a timeout above RTT, as we must look only for drop */
-- 
2.53.0



