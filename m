Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F79725DAEB;
	Tue, 25 Mar 2025 12:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906435; cv=none; b=sUZfjz07jX7bzJGfbOZtMrEebvMkDQ/PC7DjWGCErVPB34Aw26QKD1/HaXdFXzhCnuuOjcpc5qU2cJAw19fSm2n7IxHGE59BTLvTvZJv23BEw7kLe5pXIpJI6BQ1CFUUqMZ1aj0IIrgsJ15bJY1N2L4CiDGPZl/oDCsA4dDIK94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906435; c=relaxed/simple;
	bh=84EhEmbEZP/a26jflbNXZEb1EAkAzbl4a+H6+emxKEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suX1IM8+jfbs7khGIxD2Uw/tRAwh/0UVZinUfC9TIcs2vMVX989lps1gCmc2HSYYkfe1ujWsJQUDAdrwVOrXAc48k7IedAEbJaFUFbWpDTE4bM3BzxV7Ii7qWgxWaszjNNHTKcSKUtqfBTFQ8sBh6u2yZ0uvUgqhCKqzWWRvDSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FviM090t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FviM090t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3254EC4CEE4;
	Tue, 25 Mar 2025 12:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906435;
	bh=84EhEmbEZP/a26jflbNXZEb1EAkAzbl4a+H6+emxKEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FviM090tT4xgT0dGQZ3GSlmQUH9HbRe0fA8mZryFf2vvjOFn8dW3h8bGn2kXY8BhB
	 xGC/qbPWsP3S6nyvy+lVA5/OzYIa5Nwu9TsxhITKCjp+p2n6mG03C6l7fyqgRKC2LJ
	 FcGVDhpNr6NrONXJqI2dgIynFToT/AnTukPoweEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Arthur Mongodin <amongodin@randorisec.fr>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH 6.12 116/116] mptcp: Fix data stream corruption in the address announcement
Date: Tue, 25 Mar 2025 08:23:23 -0400
Message-ID: <20250325122152.175590397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arthur Mongodin <amongodin@randorisec.fr>

commit 2c1f97a52cb827a5f2768e67a9dddffae1ed47ab upstream.

Because of the size restriction in the TCP options space, the MPTCP
ADD_ADDR option is exclusive and cannot be sent with other MPTCP ones.
For this reason, in the linked mptcp_out_options structure, group of
fields linked to different options are part of the same union.

There is a case where the mptcp_pm_add_addr_signal() function can modify
opts->addr, but not ended up sending an ADD_ADDR. Later on, back in
mptcp_established_options, other options will be sent, but with
unexpected data written in other fields due to the union, e.g. in
opts->ext_copy. This could lead to a data stream corruption in the next
packet.

Using an intermediate variable, prevents from corrupting previously
established DSS option. The assignment of the ADD_ADDR option
parameters is now done once we are sure this ADD_ADDR option can be set
in the packet, e.g. after having dropped other suboptions.

Fixes: 1bff1e43a30e ("mptcp: optimize out option generation")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Arthur Mongodin <amongodin@randorisec.fr>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
[ Matt: the commit message has been updated: long lines splits and some
  clarifications. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250314-net-mptcp-fix-data-stream-corr-sockopt-v1-1-122dbb249db3@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -651,6 +651,7 @@ static bool mptcp_established_options_ad
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	bool drop_other_suboptions = false;
 	unsigned int opt_size = *size;
+	struct mptcp_addr_info addr;
 	bool echo;
 	int len;
 
@@ -659,7 +660,7 @@ static bool mptcp_established_options_ad
 	 */
 	if (!mptcp_pm_should_add_signal(msk) ||
 	    (opts->suboptions & (OPTION_MPTCP_MPJ_ACK | OPTION_MPTCP_MPC_ACK)) ||
-	    !mptcp_pm_add_addr_signal(msk, skb, opt_size, remaining, &opts->addr,
+	    !mptcp_pm_add_addr_signal(msk, skb, opt_size, remaining, &addr,
 		    &echo, &drop_other_suboptions))
 		return false;
 
@@ -672,7 +673,7 @@ static bool mptcp_established_options_ad
 	else if (opts->suboptions & OPTION_MPTCP_DSS)
 		return false;
 
-	len = mptcp_add_addr_len(opts->addr.family, echo, !!opts->addr.port);
+	len = mptcp_add_addr_len(addr.family, echo, !!addr.port);
 	if (remaining < len)
 		return false;
 
@@ -689,6 +690,7 @@ static bool mptcp_established_options_ad
 		opts->ahmac = 0;
 		*size -= opt_size;
 	}
+	opts->addr = addr;
 	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
 	if (!echo) {
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ADDADDRTX);


