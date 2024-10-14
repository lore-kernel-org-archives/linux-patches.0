Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921D525632;
	Mon, 14 Oct 2024 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916462; cv=none; b=lMQpK83kUVVB2//NmsSdiGZB5mMCZGaxu/k3eQ8PMEpT0LYj6jBFdiT46yrwTr++BzVxKwuKgO/QHEcNZy2QzuCVUGQg/GGlnqDKYFuB26NL3ivO0jztHyQ6YVaRDAvE+0KaqHumptz+BcBz79TKD2EVEqvLFOsHjkbjobJVB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916462; c=relaxed/simple;
	bh=Izg/NzZ5IzQ0UWAAaS7xgJC3fH1eHPmxMSdOzcbgSMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnrpcEAlxi8c79xsm/pcWWuaghUdys96m8Y9hcyGfgNnGCnSignjnisqH8V1qtI81ahof3DsGt54d2BSZjJ/FRyO1/qBfnBIMpiH+4IH7NzQneYsCFJOYPGM3KF6gIdD2drvbBzvvc4u74R+IBzl8nvPcf5hdpfuFc2S1Xca5QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrYqYCry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrYqYCry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09DBC4CEC7;
	Mon, 14 Oct 2024 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916462;
	bh=Izg/NzZ5IzQ0UWAAaS7xgJC3fH1eHPmxMSdOzcbgSMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrYqYCryQV78LOZozq9GOo+F3W8G6UjtBfetIPDhoRCd0RoAOH4ZMHX3Ur4Hb7/Ce
	 rEcF1rm/aIsXBm5XII9uNwbS8KmtIQF4DriAA04xO7wzHwJgO6I1SCKoMtClvjDbf/
	 0sfwEoS7A296PC1bJOs6ilSJwIbivl2sh18Ppjkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 189/214] mptcp: fallback when MPTCP opts are dropped after 1st data
Date: Mon, 14 Oct 2024 16:20:52 +0200
Message-ID: <20241014141052.353540512@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 119d51e225febc8152476340a880f5415a01e99e upstream.

As reported by Christoph [1], before this patch, an MPTCP connection was
wrongly reset when a host received a first data packet with MPTCP
options after the 3wHS, but got the next ones without.

According to the MPTCP v1 specs [2], a fallback should happen in this
case, because the host didn't receive a DATA_ACK from the other peer,
nor receive data for more than the initial window which implies a
DATA_ACK being received by the other peer.

The patch here re-uses the same logic as the one used in other places:
by looking at allow_infinite_fallback, which is disabled at the creation
of an additional subflow. It's not looking at the first DATA_ACK (or
implying one received from the other side) as suggested by the RFC, but
it is in continuation with what was already done, which is safer, and it
fixes the reported issue. The next step, looking at this first DATA_ACK,
is tracked in [4].

This patch has been validated using the following Packetdrill script:

   0 socket(..., SOCK_STREAM, IPPROTO_MPTCP) = 3
  +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
  +0 bind(3, ..., ...) = 0
  +0 listen(3, 1) = 0

  // 3WHS is OK
  +0.0 < S  0:0(0)       win 65535  <mss 1460, sackOK, nop, nop, nop, wscale 6, mpcapable v1 flags[flag_h] nokey>
  +0.0 > S. 0:0(0) ack 1            <mss 1460, nop, nop, sackOK, nop, wscale 8, mpcapable v1 flags[flag_h] key[skey]>
  +0.1 <  . 1:1(0) ack 1 win 2048                                              <mpcapable v1 flags[flag_h] key[ckey=2, skey]>
  +0 accept(3, ..., ...) = 4

  // Data from the client with valid MPTCP options (no DATA_ACK: normal)
  +0.1 < P. 1:501(500) ack 1 win 2048 <mpcapable v1 flags[flag_h] key[skey, ckey] mpcdatalen 500, nop, nop>
  // From here, the MPTCP options will be dropped by a middlebox
  +0.0 >  . 1:1(0)     ack 501        <dss dack8=501 dll=0 nocs>

  +0.1 read(4, ..., 500) = 500
  +0   write(4, ..., 100) = 100

  // The server replies with data, still thinking MPTCP is being used
  +0.0 > P. 1:101(100)   ack 501          <dss dack8=501 dsn8=1 ssn=1 dll=100 nocs, nop, nop>
  // But the client already did a fallback to TCP, because the two previous packets have been received without MPTCP options
  +0.1 <  . 501:501(0)   ack 101 win 2048

  +0.0 < P. 501:601(100) ack 101 win 2048
  // The server should fallback to TCP, not reset: it didn't get a DATA_ACK, nor data for more than the initial window
  +0.0 >  . 101:101(0)   ack 601

Note that this script requires Packetdrill with MPTCP support, see [3].

Fixes: dea2b1ea9c70 ("mptcp: do not reset MP_CAPABLE subflow on mapping errors")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/518 [1]
Link: https://datatracker.ietf.org/doc/html/rfc8684#name-fallback [2]
Link: https://github.com/multipath-tcp/packetdrill [3]
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/519 [4]
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241008-net-mptcp-fallback-fixes-v1-3-c6fb8e93e551@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1276,7 +1276,7 @@ static bool subflow_can_fallback(struct
 	else if (READ_ONCE(msk->csum_enabled))
 		return !subflow->valid_csum_seen;
 	else
-		return !subflow->fully_established;
+		return READ_ONCE(msk->allow_infinite_fallback);
 }
 
 static void mptcp_subflow_fail(struct mptcp_sock *msk, struct sock *ssk)


