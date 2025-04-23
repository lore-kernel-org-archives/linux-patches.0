Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434AF28CF52;
	Wed, 23 Apr 2025 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421408; cv=none; b=jCgFSmPlzgz1YuleB0SbTZkURCxzlSBTO5Hj/LOLuBwy5AdJaRcGRm09h7ClDS0U2a8nob9ic+JzU2m4UtmN5utk9YU7KUsUenv2oZVVHbGeouzb3SEvTljq0gGcmkTjruDUP4ZRaGwH7Kgcv5WlNOB1ClV/4D4Kek2fCA57crI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421408; c=relaxed/simple;
	bh=l/6HZ+jZ3lPEzzozvvias+Qj88JYcMXUvMfyrJgUPpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY7kqm+CpK+q5w3YjbUep9j254cVNgDNlPR4s+JRoCXN7+ls8eOo331+CpMEzD6ARaSK65LogSW1a+AVr3sAUHs4mtDUd1VgNqB33FF/b8Iu/eJX0km3T8Fqi6Xc/bDUhVo/c5+sckbpWKcWcAvRImxoUzhXK6YPlG+xDi2ItHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmH9Myyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmH9Myyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D2C4CEE2;
	Wed, 23 Apr 2025 15:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421407;
	bh=l/6HZ+jZ3lPEzzozvvias+Qj88JYcMXUvMfyrJgUPpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmH9MyyxFS2ofEkEgjJXVBKYzt3oNdArllvZ+8pu48KQfKAzo3Q73gEZHzq/oVslw
	 AYeNvZw1DRaMLi8U5HaHTK17FtFgZxSmWlgFSM51yFAcVNvqkDadkmehuMEEaX/YZH
	 8/Ob8Uj1kymR10djkAeIY0GYbyJf8ENJvVvmxaJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 176/393] mptcp: fix NULL pointer in can_accept_new_subflow
Date: Wed, 23 Apr 2025 16:41:12 +0200
Message-ID: <20250423142650.646815045@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Gang Yan <yangang@kylinos.cn>

commit 443041deb5ef6a1289a99ed95015ec7442f141dc upstream.

When testing valkey benchmark tool with MPTCP, the kernel panics in
'mptcp_can_accept_new_subflow' because subflow_req->msk is NULL.

Call trace:

  mptcp_can_accept_new_subflow (./net/mptcp/subflow.c:63 (discriminator 4)) (P)
  subflow_syn_recv_sock (./net/mptcp/subflow.c:854)
  tcp_check_req (./net/ipv4/tcp_minisocks.c:863)
  tcp_v4_rcv (./net/ipv4/tcp_ipv4.c:2268)
  ip_protocol_deliver_rcu (./net/ipv4/ip_input.c:207)
  ip_local_deliver_finish (./net/ipv4/ip_input.c:234)
  ip_local_deliver (./net/ipv4/ip_input.c:254)
  ip_rcv_finish (./net/ipv4/ip_input.c:449)
  ...

According to the debug log, the same req received two SYN-ACK in a very
short time, very likely because the client retransmits the syn ack due
to multiple reasons.

Even if the packets are transmitted with a relevant time interval, they
can be processed by the server on different CPUs concurrently). The
'subflow_req->msk' ownership is transferred to the subflow the first,
and there will be a risk of a null pointer dereference here.

This patch fixes this issue by moving the 'subflow_req->msk' under the
`own_req == true` conditional.

Note that the !msk check in subflow_hmac_valid() can be dropped, because
the same check already exists under the own_req mpj branch where the
code has been moved to.

Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250328-net-mptcp-misc-fixes-6-15-v1-1-34161a482a7f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -731,8 +731,6 @@ static bool subflow_hmac_valid(const str
 
 	subflow_req = mptcp_subflow_rsk(req);
 	msk = subflow_req->msk;
-	if (!msk)
-		return false;
 
 	subflow_generate_hmac(msk->remote_key, msk->local_key,
 			      subflow_req->remote_nonce,
@@ -828,12 +826,8 @@ static struct sock *subflow_syn_recv_soc
 
 	} else if (subflow_req->mp_join) {
 		mptcp_get_options(skb, &mp_opt);
-		if (!(mp_opt.suboptions & OPTION_MPTCP_MPJ_ACK) ||
-		    !subflow_hmac_valid(req, &mp_opt) ||
-		    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
-			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPJ_ACK))
 			fallback = true;
-		}
 	}
 
 create_child:
@@ -882,6 +876,13 @@ create_child:
 				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);
 				goto dispose_child;
 			}
+
+			if (!subflow_hmac_valid(req, &mp_opt) ||
+			    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
+				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
+				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);
+				goto dispose_child;
+			}
 
 			/* move the msk reference ownership to the subflow */
 			subflow_req->msk = NULL;


