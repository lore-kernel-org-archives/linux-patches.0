Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252FD446C9;
	Tue, 20 Feb 2024 21:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464808; cv=none; b=QHD2IBTxLntORRyCklnRFBLfIfKcCM7IkQl8IZTwfeOJuDAkiWBJVDvA/z/lk495JSgCeld7MSb5QIqIqZOoXhnUZ02/H6dOAIiYVDhhDNQDG8FX+fq0mzitjksDvxvkMsT2OSybbEskjm3PKDXo6Bfk16V/R0yrhfRFXU6aWR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464808; c=relaxed/simple;
	bh=qtQddbWrt94ZSeSRRzJhhOO8cnjd2UFPHnMp5YodOVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIOaUOZTrZ6kWGyZV88yZAZuWQo7bnl4IQjfSJ3YClrYCGR1D6Ew/XrpC0byO9OGVUG34Mq5Oghygto4JQgDCoTpSBntyzrjctbKvbH2XzdHpbsEYNDiNxTEz2JsgKij0c1tVYngGoZTo5n49tsp+qzh564SWNmYlMug2e2WjSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dr0Ya1Yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dr0Ya1Yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A77C433F1;
	Tue, 20 Feb 2024 21:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464808;
	bh=qtQddbWrt94ZSeSRRzJhhOO8cnjd2UFPHnMp5YodOVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dr0Ya1Yrov82UlEm15o5rlTB1g4kq97aA7WGw5Pus+vjhum62yrg7cyM16PYsgqFd
	 q0DEARU7tMId9ljbtZ08IAZ+pfp+3d25xlIcmedSGnf7AZkFNFJt90nnsLWMYEG9id
	 vRoZaAQK4z5jEX3WFQZhh5/72BUONWmciY+XSAOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c53d4d3ddb327e80bc51@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 126/309] mptcp: really cope with fastopen race
Date: Tue, 20 Feb 2024 21:54:45 +0100
Message-ID: <20240220205637.103416125@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 337cebbd850f94147cee05252778f8f78b8c337f upstream.

Fastopen and PM-trigger subflow shutdown can race, as reported by
syzkaller.

In my first attempt to close such race, I missed the fact that
the subflow status can change again before the subflow_state_change
callback is invoked.

Address the issue additionally copying with all the states directly
reachable from TCP_FIN_WAIT1.

Fixes: 1e777f39b4d7 ("mptcp: add MSG_FASTOPEN sendmsg flag support")
Fixes: 4fd19a307016 ("mptcp: fix inconsistent state on fastopen race")
Cc: stable@vger.kernel.org
Reported-by: syzbot+c53d4d3ddb327e80bc51@syzkaller.appspotmail.com
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/458
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1118,7 +1118,8 @@ static inline bool subflow_simultaneous_
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
-	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_FIN_WAIT1) &&
+	return (1 << sk->sk_state) &
+	       (TCPF_ESTABLISHED | TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | TCPF_CLOSING) &&
 	       is_active_ssk(subflow) &&
 	       !subflow->conn_finished;
 }


