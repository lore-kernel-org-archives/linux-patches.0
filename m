Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA3E1EB9FA;
	Mon, 21 Oct 2024 10:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507754; cv=none; b=NAXq9yftEFJ7yZy09tfMcvq+7pN1TBAs9TZJACr0x4HYOqidF847g2qX9lqT12Ao7wh44YP3MHGZjL/3tvpYywnzgrSY38rhm6wm9LYWRO0Iz+PVE43Ksr/zDcNFUMv4zYidpYC8uh4StowGps3zzj+vMe42DXBjr3p4xHqXhQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507754; c=relaxed/simple;
	bh=atbiMCbCIBkAPsesEv+rnVespRN2rUxkK5sex/ElVxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5I5D6KvAKtSLiID9INtszFdIBdlB7fXzE5fDbqT4mzhgwzO02MRn3a6qBEHjYF6Fm3yhPzHbZZv8XGoOnWVLMb1elqbvgRy6TYZnuaTb+ndRBZnqb73SDcDzd5LGBx95VAh6/xPc2WDwYw1Nohqih9+Z7wLqgN4pFnZjy77S2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtnwsE9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtnwsE9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91354C4CEC3;
	Mon, 21 Oct 2024 10:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507754;
	bh=atbiMCbCIBkAPsesEv+rnVespRN2rUxkK5sex/ElVxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtnwsE9X8uhaWxRrN95WhWYxTeiMb3QPCyu09ljIwtm7LsjIrEfaux4LGQacwxpYu
	 Av8qtZbTVmqzJ9U3WufII0YOYiPqXM7nGU0ccFv8Kvsy3TnlOdQo0aGB0ZvIZrJz7r
	 NOsRpeEVZcF7ryqENCyfDHbi75TICWTsyZJjRe3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 77/82] mptcp: fallback when MPTCP opts are dropped after 1st data
Date: Mon, 21 Oct 2024 12:25:58 +0200
Message-ID: <20241021102250.261088889@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

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
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1152,7 +1152,7 @@ static bool subflow_can_fallback(struct
 	else if (READ_ONCE(msk->csum_enabled))
 		return !subflow->valid_csum_seen;
 	else
-		return !subflow->fully_established;
+		return READ_ONCE(msk->allow_infinite_fallback);
 }
 
 static bool subflow_check_data_avail(struct sock *ssk)


