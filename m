Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7488017CA1F;
	Sun,  1 Sep 2024 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208299; cv=none; b=LTG2XXY/+j9BoupvNVKPHamtGIbB1PKfyakGIuV9rQtieWMXmVuoVa85c6MMWQnyHrhkzjyGiCrAE3jCDOdU7WdeiaGUwDW01X80btM+NFibp7t6pR05kTmzLEisW1tdwToNrnqKf3K5X5iREqz74k+sCv+y3ba1OYI4+s5V41Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208299; c=relaxed/simple;
	bh=G/3O2aqsTjkvV4PE3JGBQq0rJ7iVjdPbf1SEgHbiO2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raiwpNLj9D/OuCq7lohnaR2xMvtUKN5sKI3XCIhXtbbp5t2nOY3LtDOxLciaJNiFZ8L52kMEq1LRZliyZcNrYhLxGnDVt7jwppjoqTM8PBBY8esSy0Wfj6z6WokMk3b1TNlD1zcvKv/5w8DAhwIuUTZ3bpO4nkjVhxpyA1rUOrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wR78WzrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wR78WzrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE6DC4CEC3;
	Sun,  1 Sep 2024 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208298;
	bh=G/3O2aqsTjkvV4PE3JGBQq0rJ7iVjdPbf1SEgHbiO2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wR78WzrQFRSf+VZ8z+FHiKbNmmcSc1nD2DYNoxZB9QsNqCjwtfymfbyzMB3Knb82H
	 GfkOJvhkfYVDDehtbabTg0gAZiFhtxHjxZRfxMWmAcHjw+0RoDf7SRLhecENWp9nSp
	 Q0sQz5cg3Z8slUHJlIqvTNkdSpHtP4gefbUIeSQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 022/149] mptcp: pm: skip connecting to already established sf
Date: Sun,  1 Sep 2024 18:15:33 +0200
Message-ID: <20240901160818.299983032@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -130,12 +130,15 @@ static bool lookup_subflow_by_daddr(cons
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


