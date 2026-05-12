Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17493EDE4E;
	Tue, 12 May 2026 17:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608775; cv=none; b=XdIbD0Bz1DTvLisx2hU9BQI5JYnkM0RrsxLNxwSkkWCKC/VCZFdixmvkxWg46mFnJqeF/3LmUr2gS28A0ct881f+WjogELBu5XkTl1muhDmDsACBcb4j8fYWgUXRlSKbrgbEGaOu2mW3+ZmI3Z7Dp9RbGBUP1EeltGOJfKXAj/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608775; c=relaxed/simple;
	bh=UnfWgyD7Sm1kukTyPy5qQH9AjbKPFt8w0schBYZXUdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8EAYAa8Xoi7fOOlz8ypvqDNJ2CSj5f5J2zFRWp90oc4TAEKIJRaxiQYPvA/odIOJFD+sYzEGbmtDsjYApA6Z1QfJB0p+Iby01f/+PO641nyW7bNhhZZtOGLHIOB4A/1u6Ad3axBpYad4Qjgt877M644m7gBNpZTC1fZEmh8h3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHyJ8MgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHyJ8MgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C9AC2BCC7;
	Tue, 12 May 2026 17:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608775;
	bh=UnfWgyD7Sm1kukTyPy5qQH9AjbKPFt8w0schBYZXUdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHyJ8MgAydGnxwIMoh+XjZrsyHHWJnVoJIpS6TSUk9CuCCP1nQDT/m7fkjOzbsiQG
	 TBGjHiIByeKbu05/mP8lPZmXoCVpmV7MdVaQZyEmwqHqe2VLWySIDEA/Ux4HrWlRp1
	 kdtRy1Lyjet6aGFMUmGUISRWRhATOw3jp+LSgiDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Tuller <lance@lance0.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 208/270] mptcp: fastclose msk when linger time is 0
Date: Tue, 12 May 2026 19:40:09 +0200
Message-ID: <20260512173942.826998244@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit f14d6e9c3678a067f304abba561e0c5446c7e845 upstream.

The SO_LINGER socket option has been supported for a while with MPTCP
sockets [1], but it didn't cause the equivalent of a TCP reset as
expected when enabled and its time was set to 0. This was causing some
behavioural differences with TCP where some connections were not
promptly stopped as expected.

To fix that, an extra condition is checked at close() time before
sending an MP_FASTCLOSE, the MPTCP equivalent of a TCP reset.

Note that backporting up to [1] will be difficult as more changes are
needed to be able to send MP_FASTCLOSE. It seems better to stop at [2],
which was supposed to already imitate TCP.

Validated with MPTCP packetdrill tests [3].

Fixes: 268b12387460 ("mptcp: setsockopt: support SO_LINGER") [1]
Fixes: d21f83485518 ("mptcp: use fastclose on more edge scenarios") [2]
Cc: stable@vger.kernel.org
Reported-by: Lance Tuller <lance@lance0.com>
Closes: https://github.com/lance0/xfr/pull/67
Link: https://github.com/multipath-tcp/packetdrill/pull/196 [3]
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260427-net-mptcp-misc-fixes-7-1-rc2-v1-3-7432b7f279fa@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3162,7 +3162,8 @@ bool __mptcp_close(struct sock *sk, long
 		goto cleanup;
 	}
 
-	if (mptcp_data_avail(msk) || timeout < 0) {
+	if (mptcp_data_avail(msk) || timeout < 0 ||
+	    (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime)) {
 		/* If the msk has read data, or the caller explicitly ask it,
 		 * do the MPTCP equivalent of TCP reset, aka MPTCP fastclose
 		 */


