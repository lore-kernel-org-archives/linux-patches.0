Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968753C09E0;
	Tue, 12 May 2026 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608108; cv=none; b=nsc5vfnNxhamxYl1O0hemTsZ7ieR1NwV4xORCcoOSD4Db2MXkjz0JNA/RE1bVTYtfKSC15fMxFtMHZuAzG4TtNsWZYlS3AXLFTUwPxREn7Mb2JEpf2hcD0PRl4ygbjfxthxf29CpqiHcW/o7tM7feBuWxVcg5atO7Mk4VJmCjJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608108; c=relaxed/simple;
	bh=wez/caaltFpaZolBDJ2yPxZdtFADzcqSpqW8ErzW33c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gy58YMJ5e7w5XVRxu3dNp4yDO0tC4xKETqBhnE5JHzfkQbgQ/vXT7ilKLUHe5AYLyFPD12o2VL6EO3lhHtZjfQNOVscT7BqZDOTF0oY9mU8Vae6WW9af9X5urnawOKt4gw2SB1qSAY7B5p92kazc9opEJXMgM6IK9xsFCcbMIQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGdHiYNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGdHiYNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D55DC2BCB0;
	Tue, 12 May 2026 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608108;
	bh=wez/caaltFpaZolBDJ2yPxZdtFADzcqSpqW8ErzW33c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGdHiYNgtt4J6wK4LOaeu/4RMf5FImp4O6ygrPENRBslXa+bUt5AWfHaAF74pxMqM
	 LwfwVJckaM33/4F5HE4mjsdt7K/Ke8wFUjg3lLLLtgfzns0m1TaRRA5oStlHPsGg42
	 5fNAOyA3ZFvAhDumgb/wrEtnYnSTs8TpGe4sQoaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Tuller <lance@lance0.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 159/206] mptcp: fastclose msk when linger time is 0
Date: Tue, 12 May 2026 19:40:11 +0200
Message-ID: <20260512173936.230616460@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3219,7 +3219,8 @@ bool __mptcp_close(struct sock *sk, long
 		goto cleanup;
 	}
 
-	if (mptcp_data_avail(msk) || timeout < 0) {
+	if (mptcp_data_avail(msk) || timeout < 0 ||
+	    (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime)) {
 		/* If the msk has read data, or the caller explicitly ask it,
 		 * do the MPTCP equivalent of TCP reset, aka MPTCP fastclose
 		 */


