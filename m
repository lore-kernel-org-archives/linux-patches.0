Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCDB1F1306;
	Mon, 21 Oct 2024 10:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507712; cv=none; b=iiTNqq/bEx0NwtPvCVuWexiKfZ+GdNb9EPCj5FPzIeHxQKkvi9+YdNPsb069xafmzkWVuv3FfMmP5FBXGtFtUZdJFhjnPW/NE+9jBSf/D4FT2lXOhpfhWwNk9m8/cq/icQzJErcth3w9VtEA7xjGUaCBYl6SqhW56oH9N9sOHEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507712; c=relaxed/simple;
	bh=Bc0AsO3MXvK47Ey2+UIBbNOJ/XoUdfLK3B4StJdCqFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCKkBHc5+f/uZ+jrKR7+9JxdK5CXpd3dvtPzCeG1RrKRDIQAlk+8+xPSI41MZW+qQGuBfwVzuOh1gAnpIdE1tIJm8wuf9so9Fap3sd5o13+YnFKKC3TDeJgQKaaKxayQ9qv/RSmgkyAUx767lDp2RepeW+7gSA4ekNcqhpnqshE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmrnsorD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmrnsorD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FE5C4CEC3;
	Mon, 21 Oct 2024 10:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507712;
	bh=Bc0AsO3MXvK47Ey2+UIBbNOJ/XoUdfLK3B4StJdCqFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmrnsorDaEuGWUCsDRNq5JTt3iRlo+XjpHIhITcydQrS2/XoUJfObSiZF/LvJYkRB
	 YbQN6Zb9oEai9+Y4A42eB2FwYoJEzsKqqJXYccnE116wY5Azxxy9V0jTF3ibL81IUT
	 KSRcg9IxtEgdukt/tZc+DDdWxJOdxjtMB7lkuCIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 75/82] mptcp: handle consistently DSS corruption
Date: Mon, 21 Oct 2024 12:25:56 +0200
Message-ID: <20241021102250.183045919@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Conflicts in mib.[ch], because commit 104125b82e5c ("mptcp: add mib
  for infinite map sending") is linked to a new feature, not available
  in this version. Resolving the conflicts is easy, simply adding the
  new lines declaring the new "DSS corruptions" MIB entries.
  Also removed in protocol.c and subflow.c all DEBUG_NET_WARN_ON_ONCE
  because they are not defined in this version: enough with the MIB
  counters that have been added in this commit. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/mib.c      |    2 ++
 net/mptcp/mib.h      |    2 ++
 net/mptcp/protocol.c |   20 +++++++++++++++++---
 net/mptcp/subflow.c  |    2 +-
 4 files changed, 22 insertions(+), 4 deletions(-)

--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -26,6 +26,8 @@ static const struct snmp_mib mptcp_snmp_
 	SNMP_MIB_ITEM("MPJoinAckRx", MPTCP_MIB_JOINACKRX),
 	SNMP_MIB_ITEM("MPJoinAckHMacFailure", MPTCP_MIB_JOINACKMAC),
 	SNMP_MIB_ITEM("DSSNotMatching", MPTCP_MIB_DSSNOMATCH),
+	SNMP_MIB_ITEM("DSSCorruptionFallback", MPTCP_MIB_DSSCORRUPTIONFALLBACK),
+	SNMP_MIB_ITEM("DSSCorruptionReset", MPTCP_MIB_DSSCORRUPTIONRESET),
 	SNMP_MIB_ITEM("InfiniteMapRx", MPTCP_MIB_INFINITEMAPRX),
 	SNMP_MIB_ITEM("DSSNoMatchTCP", MPTCP_MIB_DSSTCPMISMATCH),
 	SNMP_MIB_ITEM("DataCsumErr", MPTCP_MIB_DATACSUMERR),
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -19,6 +19,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_JOINACKRX,		/* Received an ACK + MP_JOIN */
 	MPTCP_MIB_JOINACKMAC,		/* HMAC was wrong on ACK + MP_JOIN */
 	MPTCP_MIB_DSSNOMATCH,		/* Received a new mapping that did not match the previous one */
+	MPTCP_MIB_DSSCORRUPTIONFALLBACK,/* DSS corruption detected, fallback */
+	MPTCP_MIB_DSSCORRUPTIONRESET,	/* DSS corruption detected, MPJ subflow reset */
 	MPTCP_MIB_INFINITEMAPRX,	/* Received an infinite mapping */
 	MPTCP_MIB_DSSTCPMISMATCH,	/* DSS-mapping did not map with TCP's sequence numbers */
 	MPTCP_MIB_DATACSUMERR,		/* The data checksum fail */
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -554,6 +554,18 @@ static bool mptcp_check_data_fin(struct
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
@@ -626,10 +638,12 @@ static bool __mptcp_move_skbs_from_subfl
 				moved += len;
 			seq += len;
 
-			if (WARN_ON_ONCE(map_remaining < len))
-				break;
+			if (unlikely(map_remaining < len))
+				mptcp_dss_corruption(msk, ssk);
 		} else {
-			WARN_ON_ONCE(!fin);
+			if (unlikely(!fin))
+				mptcp_dss_corruption(msk, ssk);
+
 			sk_eat_skb(ssk, skb);
 			done = true;
 		}
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -847,7 +847,7 @@ static bool skb_is_fully_mapped(struct s
 	unsigned int skb_consumed;
 
 	skb_consumed = tcp_sk(ssk)->copied_seq - TCP_SKB_CB(skb)->seq;
-	if (WARN_ON_ONCE(skb_consumed >= skb->len))
+	if (unlikely(skb_consumed >= skb->len))
 		return true;
 
 	return skb->len - skb_consumed <= subflow->map_data_len -


