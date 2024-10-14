Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097CC1AAE19;
	Mon, 14 Oct 2024 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920074; cv=none; b=F1yy2YZi5/0Ka2z2v1GukQTUuwEQOH8oE+r+BF2nvLYYGaKog/r92BjLC+7KjgHeZXU6OzTn2z8VXSeydMkRSOKnMB62jLX+G9xAJBr6BKLzZnK4tKzABTXnU1vHbn13cYFK1kvG+gsg256dTgWIiaCw0KJgm2DNWUW1Yrr2nd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920074; c=relaxed/simple;
	bh=TWrMeBFt9NR00wZqOGntFDjxLgBFt90/wzwa4EkII/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1APZiVYv+BTnOu9zvjG6t88db1BfLiEJvIqJ0w/yFXQDFnrl1eX7kXNmrPC202QVWsS9nC3eg+34JkYuSPBRcgS6C/1WdgnyIaOizyhfX/dQ7WYC24n/60N3jCWYv4F5VedZn8II10fCYxSIiy4nzKm7e9GiaujbiI8E1AdD/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbvEZ5XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbvEZ5XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E862C4CEC3;
	Mon, 14 Oct 2024 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920073;
	bh=TWrMeBFt9NR00wZqOGntFDjxLgBFt90/wzwa4EkII/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbvEZ5XUXkbAShWX6oUofFQCIJNPZP+3hSTbieRV7XDqXJ2z7Wi2oxBqL1hti4Ay5
	 CMuSCocp99BC4QdixBN5fX0gn5Ueh4rBrjU0AAXzXZkqP9q68TwQcqUiKEO1HZ2GZe
	 SK7XC/IGTiNaN8YfgZinA/c8s92ma3Xnd7skkws4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 790/798] mptcp: pm: do not remove closing subflows
Date: Mon, 14 Oct 2024 16:22:24 +0200
Message-ID: <20241014141249.109861987@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit db0a37b7ac27d8ca27d3dc676a16d081c16ec7b9 upstream.

In a previous fix, the in-kernel path-manager has been modified not to
retrigger the removal of a subflow if it was already closed, e.g. when
the initial subflow is removed, but kept in the subflows list.

To be complete, this fix should also skip the subflows that are in any
closing state: mptcp_close_ssk() will initiate the closure, but the
switch to the TCP_CLOSE state depends on the other peer.

Fixes: 58e1b66b4e4b ("mptcp: pm: do not remove already closed subflows")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241008-net-mptcp-fallback-fixes-v1-4-c6fb8e93e551@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -864,7 +864,8 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow_get_local_id(subflow);
 
-			if (inet_sk_state_load(ssk) == TCP_CLOSE)
+			if ((1 << inet_sk_state_load(ssk)) &
+			    (TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | TCPF_CLOSING | TCPF_CLOSE))
 				continue;
 			if (rm_type == MPTCP_MIB_RMADDR && remote_id != rm_id)
 				continue;


