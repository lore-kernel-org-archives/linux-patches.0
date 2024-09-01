Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D05185928;
	Sun,  1 Sep 2024 16:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209142; cv=none; b=nuCRyXpI4h647c1/D+WI3RGou19r7B4HFo9+ALVD7Q8jNTdPM8x1WSH0PqZuiG8GStjpEtDPa3nZ62dFkyANb30NjEYgh6zLffRuLIgZCmPRbWS5j8v9bk0GhjNyc8iLKusLETwePcDqj/2+bESP+TdXxj17qYut2/vNuUaAw7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209142; c=relaxed/simple;
	bh=9NfQkAYW2wC70AgCsVyz424WDVDCDdDT7NSJHoHvPG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cg4jzK2OAU7fTQN2G5QKCu+sDoUMVwdvZv11PK8jt7cGy2qEoz/WX8p/VoOhvnQjNTGhNavkTGw7irBE8TBJQIDik5/W/VVfYRXQSSKIUK38GKrvvBS7dROLm+Lj7otPiBtLEU6Af6fsUiUsnjUo7S1E0pB3wLBRe7Hu3H2T/Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O471W/Q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O471W/Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CADC4CEC3;
	Sun,  1 Sep 2024 16:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209142;
	bh=9NfQkAYW2wC70AgCsVyz424WDVDCDdDT7NSJHoHvPG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O471W/Q96vDFissxBkw2wqWwGrGnpHK1JmsNEGziQe41y7kv6jkilKlshewGUPBCc
	 Ls1KE0sj3JTSQJxYQKp38lNR8ODq0H9et1L+Vi9txs6yZWAK87yMiY5e5yZhzdZuCB
	 Oh+Cd3swvYa5jyxW6K225QO/DzHqINHSoZwXh4tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 13/71] mptcp: pm: skip connecting to already established sf
Date: Sun,  1 Sep 2024 18:17:18 +0200
Message-ID: <20240901160802.389610794@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

commit bc19ff57637ff563d2bdf2b385b48c41e6509e0d upstream.

The lookup_subflow_by_daddr() helper checks if there is already a
subflow connected to this address. But there could be a subflow that is
closing, but taking time due to some reasons: latency, losses, data to
process, etc.

If an ADD_ADDR is received while the endpoint is being closed, it is
better to try connecting to it, instead of rejecting it: the peer which
has sent the ADD_ADDR will not be notified that the ADD_ADDR has been
rejected for this reason, and the expected subflow will not be created
at the end.

This helper should then only look for subflows that are established, or
going to be, but not the ones being closed.

Fixes: d84ad04941c3 ("mptcp: skip connecting the connected address")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -134,12 +134,15 @@ static bool lookup_subflow_by_daddr(cons
 {
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_addr_info cur;
-	struct sock_common *skc;
 
 	list_for_each_entry(subflow, list, node) {
-		skc = (struct sock_common *)mptcp_subflow_tcp_sock(subflow);
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		remote_address(skc, &cur);
+		if (!((1 << inet_sk_state_load(ssk)) &
+		      (TCPF_ESTABLISHED | TCPF_SYN_SENT | TCPF_SYN_RECV)))
+			continue;
+
+		remote_address((struct sock_common *)ssk, &cur);
 		if (mptcp_addresses_equal(&cur, daddr, daddr->port))
 			return true;
 	}


