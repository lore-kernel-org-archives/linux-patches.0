Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270F11F5612;
	Tue, 21 Jan 2025 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482126; cv=none; b=QuDvLzTyuWOwQRzt5a+5jm2PlpCFGJkc3aCDY3F2OXKZMkhEBM9LBlspURGOhlAPADQuQmVLC4BrjfPdxYLSMPRhDMwI4a/VmQuMRscJBYXFp3h5o9ZiFBKAE5yKqSRLHOND5mpVvfy0P0mbGQSEK3CaVmT3yU8CALOMYd2mCxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482126; c=relaxed/simple;
	bh=S/6OH3P3KMRKwKrHZcdGTa/PUlESFUTnWEeAsXb33kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkjkS66M08pZ7okmbtzP31W5ItcY5f27f7KijxAeS80XbhZr16jFud1JsQH4TyyN6+I1NaPtPTDsVxSA2UicBcY3eh/Ag84bBrlPteSvLvpkegFo7KLaD/NFxZexiQejMBt0TLi+X8t3ClrCOKJ0zxKmAFRy02fcErYKdpXpLnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsqwBhj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsqwBhj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4903C4CEE1;
	Tue, 21 Jan 2025 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482126;
	bh=S/6OH3P3KMRKwKrHZcdGTa/PUlESFUTnWEeAsXb33kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsqwBhj90gqVReNdJkM8tNS+s0UTs48HZe2vrTEUj23VjblulXQBYcwhXZNoNbGBN
	 BTOcBtnaSHwFKOggynIViwd7bDrOFaadTRgiOhlbYDe0AGf3aSNZ6GS3q+ViWvLaDz
	 9X2qTLjmh3Kv+6IBcKt4l3aeWhjizujuRBx63HPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 42/72] mptcp: fix spurious wake-up on under memory pressure
Date: Tue, 21 Jan 2025 18:52:08 +0100
Message-ID: <20250121174525.044117629@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit e226d9259dc4f5d2c19e6682ad1356fa97cf38f4 upstream.

The wake-up condition currently implemented by mptcp_epollin_ready()
is wrong, as it could mark the MPTCP socket as readable even when
no data are present and the system is under memory pressure.

Explicitly check for some data being available in the receive queue.

Fixes: 5684ab1a0eff ("mptcp: give rcvlowat some love")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250113-net-mptcp-connect-st-flakes-v1-2-0d986ee7b1b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -685,10 +685,15 @@ static inline u64 mptcp_data_avail(const
 
 static inline bool mptcp_epollin_ready(const struct sock *sk)
 {
+	u64 data_avail = mptcp_data_avail(mptcp_sk(sk));
+
+	if (!data_avail)
+		return false;
+
 	/* mptcp doesn't have to deal with small skbs in the receive queue,
-	 * at it can always coalesce them
+	 * as it can always coalesce them
 	 */
-	return (mptcp_data_avail(mptcp_sk(sk)) >= sk->sk_rcvlowat) ||
+	return (data_avail >= sk->sk_rcvlowat) ||
 	       (mem_cgroup_sockets_enabled && sk->sk_memcg &&
 		mem_cgroup_under_socket_pressure(sk->sk_memcg)) ||
 	       READ_ONCE(tcp_memory_pressure);


