Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2BC188A28;
	Tue, 10 Sep 2024 10:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963561; cv=none; b=Y9mrSR+yALkKTh35NUYv7BnKxjQkAKpWULjojRToRAxHdUw8C1Z0/ZhsbDcWdsHySpDqa64fNNkfAIASm3y+/wgS5cy3MgXNLAzLsYwD/oJslDkxTXIofDXmAvUK+5Hu7lxVodQZCLLN009qvcCf3u9EdNHi168XJCbylA0FNtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963561; c=relaxed/simple;
	bh=z0Hhqc4oYGeIQPu3exfBwKdxWTHV+IPlePlg0yyYdfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjs1dPuGyE5cMtDS7hiRlhoqUh+hR3QpWizalpb0MNm2TPduvb1e9BC0s094lcePwWtjUmY40ztjsh7xyowpEk+oYV/9ehX781Ktd8Y8wSNux17DwuLzrrbfpTfl/03BnykefG5zqnc//RggKbnrhPm5Y+lECUALo45CpRETrsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8AoOivY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8AoOivY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3F0C4CEC3;
	Tue, 10 Sep 2024 10:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963561;
	bh=z0Hhqc4oYGeIQPu3exfBwKdxWTHV+IPlePlg0yyYdfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8AoOivYWuL+y3rprtoxs+386kaw59B4Yy2ga0wpz/4uuoTYavOgfVxNt0CqHgA/W
	 MWD/Hkt8Thc76z2DT464dSO8GQIrgme+sxqTkjyZDE9XftqBLbX0bxpYKgaFfO55cY
	 9v1y9U8ovWffeJXV06kXPdxW0Lb0Pgl0yrheMBQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 100/214] mptcp: pm: skip connecting to already established sf
Date: Tue, 10 Sep 2024 11:32:02 +0200
Message-ID: <20240910092602.882002649@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
[ Conflicts in pm_netlink.c, due to commit 4638de5aefe5 ("mptcp: handle
  local addrs announced by userspace PMs"), not in this version, and
  changing the context. The same fix can still be applied. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -145,12 +145,15 @@ static bool lookup_subflow_by_daddr(cons
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
 		if (addresses_equal(&cur, daddr, daddr->port))
 			return true;
 	}


