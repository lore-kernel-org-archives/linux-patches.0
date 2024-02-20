Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E83151CCC;
	Tue, 20 Feb 2024 21:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463692; cv=none; b=usxyitDswKHfjKhs7mKZFYg/QXX6+TkLaN/yErv3EKPvdzpdDutJSM9IGsbUDl2FVPo87TG6NzoXr47jnhgosKfQlaHLTCc2z+ghoIHrWYKWU1TDWwru1jnDM+OrjuZS9DLRqCzBJewUy65zsp8qzTU1zH/nDMzJ6DTGv51mRo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463692; c=relaxed/simple;
	bh=WC4X+rHQId93xI6aE4+OFVnERxIJcVTqZW4uB0yuw44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLVRmEfGUPpPsZFj/WfcjrqrZgCie0JsHvUrUmRZAm0ycdS+UrzlgIcjNVIGyCNE/SRKxy5EA4krYtsQs8JsgrWifcs9tqdIGCmWyAoxd/fE9LJqp5MQgCGZrYcmN2ndbuxe+ormRKx1mKdyO2c6LF5hUA1mERT5kxlz/V67ToU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYbDdC23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYbDdC23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435B3C433C7;
	Tue, 20 Feb 2024 21:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463691;
	bh=WC4X+rHQId93xI6aE4+OFVnERxIJcVTqZW4uB0yuw44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYbDdC23jf4HXU/J1x/Uwb0msO4QJocKrwgMrOOSVbCJ3vNvOXvlfxa5UTWVXsWkq
	 w7RRwvyv2catIa8+lCttiCm/wI/DeY7G5Z0kDG3PX7iC982o37wtTq7RUt+jp9MU9v
	 dkcOeDMeKPXjrrzkePOQL2G/L3K5q+ZDeesxak9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c53d4d3ddb327e80bc51@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 115/331] mptcp: really cope with fastopen race
Date: Tue, 20 Feb 2024 21:53:51 +0100
Message-ID: <20240220205641.232031978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1104,7 +1104,8 @@ static inline bool subflow_simultaneous_
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
-	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_FIN_WAIT1) &&
+	return (1 << sk->sk_state) &
+	       (TCPF_ESTABLISHED | TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | TCPF_CLOSING) &&
 	       is_active_ssk(subflow) &&
 	       !subflow->conn_finished;
 }


