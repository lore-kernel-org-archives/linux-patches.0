Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F771F9AA3;
	Mon, 21 Oct 2024 10:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507876; cv=none; b=GDoWIu/H14uewpZbOQ27iWrMQhLV8J3c4qnvqUufzronIFc8ZumeSAaCF4nwfZmOFDUVpG49zQmZkN8aiqEp69qGrRDAr9TnQIRFp+LjJjM1u2d+b0Kv+so/p97h75XOtWam8doocWc0pPLvYxEdf2IcdDRhW0khMK14c2dO/zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507876; c=relaxed/simple;
	bh=2Gzg9X06Ykyml4vxGMC5T9Fho1kPelEeQmBH0e+r8gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uK5E9Dne/MHLT2b0nbqNrvHd101YZp7nPfyaLzQD2asMfRRpIJCKNpfurDodVI2W1QfR6XHZ6rx84gXJKxEHmCUyP5mxC9DFTswlEdl/AsWrNqueIjoY1856+sVxkqL/I0jpRc01zaOaLQrbizmjD5XpBbSDwbGvyKsNVTrT1Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNDrN8qg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNDrN8qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DB1C4CEC3;
	Mon, 21 Oct 2024 10:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507876;
	bh=2Gzg9X06Ykyml4vxGMC5T9Fho1kPelEeQmBH0e+r8gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNDrN8qghl+ift7o46EHeVlVswQ5oCYfublVEqilSVhG67ONi3lzopWd5edo/VF66
	 or/h/JOkwm0mB2xcklDtbAopkdDiCXw6wTISmmizFaGnnMp7VESBdXGt8yYrgpgzZp
	 cXCryGfC7SLTgqNuLGVjmulpj+Jz4hdB58DjpZRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 48/52] mptcp: handle consistently DSS corruption
Date: Mon, 21 Oct 2024 12:26:09 +0200
Message-ID: <20241021102243.508538366@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -23,6 +23,8 @@ static const struct snmp_mib mptcp_snmp_
 	SNMP_MIB_ITEM("MPJoinAckRx", MPTCP_MIB_JOINACKRX),
 	SNMP_MIB_ITEM("MPJoinAckHMacFailure", MPTCP_MIB_JOINACKMAC),
 	SNMP_MIB_ITEM("DSSNotMatching", MPTCP_MIB_DSSNOMATCH),
+	SNMP_MIB_ITEM("DSSCorruptionFallback", MPTCP_MIB_DSSCORRUPTIONFALLBACK),
+	SNMP_MIB_ITEM("DSSCorruptionReset", MPTCP_MIB_DSSCORRUPTIONRESET),
 	SNMP_MIB_ITEM("InfiniteMapRx", MPTCP_MIB_INFINITEMAPRX),
 	SNMP_MIB_ITEM("OFOQueueTail", MPTCP_MIB_OFOQUEUETAIL),
 	SNMP_MIB_ITEM("OFOQueue", MPTCP_MIB_OFOQUEUE),
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -16,6 +16,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_JOINACKRX,		/* Received an ACK + MP_JOIN */
 	MPTCP_MIB_JOINACKMAC,		/* HMAC was wrong on ACK + MP_JOIN */
 	MPTCP_MIB_DSSNOMATCH,		/* Received a new mapping that did not match the previous one */
+	MPTCP_MIB_DSSCORRUPTIONFALLBACK,/* DSS corruption detected, fallback */
+	MPTCP_MIB_DSSCORRUPTIONRESET,	/* DSS corruption detected, MPJ subflow reset */
 	MPTCP_MIB_INFINITEMAPRX,	/* Received an infinite mapping */
 	MPTCP_MIB_OFOQUEUETAIL,	/* Segments inserted into OoO queue tail */
 	MPTCP_MIB_OFOQUEUE,		/* Segments inserted into OoO queue */
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -457,6 +457,18 @@ static void mptcp_check_data_fin(struct
 	}
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
@@ -519,10 +531,12 @@ static bool __mptcp_move_skbs_from_subfl
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
@@ -702,7 +702,7 @@ static bool skb_is_fully_mapped(struct s
 	unsigned int skb_consumed;
 
 	skb_consumed = tcp_sk(ssk)->copied_seq - TCP_SKB_CB(skb)->seq;
-	if (WARN_ON_ONCE(skb_consumed >= skb->len))
+	if (unlikely(skb_consumed >= skb->len))
 		return true;
 
 	return skb->len - skb_consumed <= subflow->map_data_len -


