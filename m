Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAA24A24;
	Mon, 14 Oct 2024 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916551; cv=none; b=piBOQ0A6UP6fnsYL1ABIQFvHg+siGli4vr/jJYRmxtTlqNN1oVCV4wMUuwcrkasJuOSvgd1aY+f8PKw064nCL5h21sT+YiHr948NoNuCvN496ubCxZXCxCxMgL0/lX7y8BZemMyTeTAfOhggsYKYc2iKRb1m9xvUmk/qComLUB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916551; c=relaxed/simple;
	bh=bWZgJcyuJDPWtquun8GjdlGHecm/im51dA13oFoRP0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV1OCD3wrxTDnf+pA2pjPnAfWPXEu49HocOoEtRTvOkg3z+myI/OC65utL1AB4b+nAHmPHi1Nh8QZypxnIiTzKJ4JbPox5gMjaTYxrdK5gD4WW2fiEZ6/I26tls+zR0q0BSc0oSDqDh6YsmXp7pwUmDh8hvJsOE4pEwaa2T2WrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNnwE/CO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNnwE/CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F58EC4CEC3;
	Mon, 14 Oct 2024 14:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916551;
	bh=bWZgJcyuJDPWtquun8GjdlGHecm/im51dA13oFoRP0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNnwE/COYnuPrZVP8BvsPIecoGYsuBH514T0yD6s2/CasFvJEpiUE4DV/5JzfGxeq
	 bYex2OgmqqLl/bDVDXBiyOM6OvpItKyo4nWS0nUO0jBHgLWPl/5ULD9Szz17p0Wxec
	 XesYzFKMDSzPei7V+dAeovP85MlhtEKkNw7D+mDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 197/214] mptcp: handle consistently DSS corruption
Date: Mon, 14 Oct 2024 16:21:00 +0200
Message-ID: <20241014141052.664725060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit e32d262c89e2b22cb0640223f953b548617ed8a6 upstream.

Bugged peer implementation can send corrupted DSS options, consistently
hitting a few warning in the data path. Use DEBUG_NET assertions, to
avoid the splat on some builds and handle consistently the error, dumping
related MIBs and performing fallback and/or reset according to the
subflow type.

Fixes: 6771bfd9ee24 ("mptcp: update mptcp ack sequence from work queue")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241008-net-mptcp-fallback-fixes-v1-1-c6fb8e93e551@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/mib.c      |    2 ++
 net/mptcp/mib.h      |    2 ++
 net/mptcp/protocol.c |   24 +++++++++++++++++++++---
 net/mptcp/subflow.c  |    4 +++-
 4 files changed, 28 insertions(+), 4 deletions(-)

--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -26,6 +26,8 @@ static const struct snmp_mib mptcp_snmp_
 	SNMP_MIB_ITEM("MPJoinAckRx", MPTCP_MIB_JOINACKRX),
 	SNMP_MIB_ITEM("MPJoinAckHMacFailure", MPTCP_MIB_JOINACKMAC),
 	SNMP_MIB_ITEM("DSSNotMatching", MPTCP_MIB_DSSNOMATCH),
+	SNMP_MIB_ITEM("DSSCorruptionFallback", MPTCP_MIB_DSSCORRUPTIONFALLBACK),
+	SNMP_MIB_ITEM("DSSCorruptionReset", MPTCP_MIB_DSSCORRUPTIONRESET),
 	SNMP_MIB_ITEM("InfiniteMapTx", MPTCP_MIB_INFINITEMAPTX),
 	SNMP_MIB_ITEM("InfiniteMapRx", MPTCP_MIB_INFINITEMAPRX),
 	SNMP_MIB_ITEM("DSSNoMatchTCP", MPTCP_MIB_DSSTCPMISMATCH),
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -21,6 +21,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_JOINACKRX,		/* Received an ACK + MP_JOIN */
 	MPTCP_MIB_JOINACKMAC,		/* HMAC was wrong on ACK + MP_JOIN */
 	MPTCP_MIB_DSSNOMATCH,		/* Received a new mapping that did not match the previous one */
+	MPTCP_MIB_DSSCORRUPTIONFALLBACK,/* DSS corruption detected, fallback */
+	MPTCP_MIB_DSSCORRUPTIONRESET,	/* DSS corruption detected, MPJ subflow reset */
 	MPTCP_MIB_INFINITEMAPTX,	/* Sent an infinite mapping */
 	MPTCP_MIB_INFINITEMAPRX,	/* Received an infinite mapping */
 	MPTCP_MIB_DSSTCPMISMATCH,	/* DSS-mapping did not map with TCP's sequence numbers */
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -620,6 +620,18 @@ static bool mptcp_check_data_fin(struct
 	return ret;
 }
 
+static void mptcp_dss_corruption(struct mptcp_sock *msk, struct sock *ssk)
+{
+	if (READ_ONCE(msk->allow_infinite_fallback)) {
+		MPTCP_INC_STATS(sock_net(ssk),
+				MPTCP_MIB_DSSCORRUPTIONFALLBACK);
+		mptcp_do_fallback(ssk);
+	} else {
+		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DSSCORRUPTIONRESET);
+		mptcp_subflow_reset(ssk);
+	}
+}
+
 static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 					   struct sock *ssk,
 					   unsigned int *bytes)
@@ -692,10 +704,16 @@ static bool __mptcp_move_skbs_from_subfl
 				moved += len;
 			seq += len;
 
-			if (WARN_ON_ONCE(map_remaining < len))
-				break;
+			if (unlikely(map_remaining < len)) {
+				DEBUG_NET_WARN_ON_ONCE(1);
+				mptcp_dss_corruption(msk, ssk);
+			}
 		} else {
-			WARN_ON_ONCE(!fin);
+			if (unlikely(!fin)) {
+				DEBUG_NET_WARN_ON_ONCE(1);
+				mptcp_dss_corruption(msk, ssk);
+			}
+
 			sk_eat_skb(ssk, skb);
 			done = true;
 		}
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -971,8 +971,10 @@ static bool skb_is_fully_mapped(struct s
 	unsigned int skb_consumed;
 
 	skb_consumed = tcp_sk(ssk)->copied_seq - TCP_SKB_CB(skb)->seq;
-	if (WARN_ON_ONCE(skb_consumed >= skb->len))
+	if (unlikely(skb_consumed >= skb->len)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return true;
+	}
 
 	return skb->len - skb_consumed <= subflow->map_data_len -
 					  mptcp_subflow_get_map_offset(subflow);


