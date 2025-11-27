Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED02299943;
	Thu, 27 Nov 2025 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255189; cv=none; b=dMdDtyffMC1VlDEVqoN1WpUQKRht2sodAHTBX787rvsf37Z2YSFY7TiirdaadAF83gYUBcGpqL8oY+eLx6sc1dL7EdST3b2zOijmqhT4WOTIZ9CTSgW7KdQi7DgOrFV6ocV7DCcC/mJ4aSjYPjHsOth4rKzD5J/rpXmeW+JoOFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255189; c=relaxed/simple;
	bh=qd2SHDIVnvCLxxasESOtKR7rsRqJH+G3lp+TtsxeeM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r//C4wPveicPbSrRCtWIKQLR4fxzTzCFqLTZyILW1iYHi3Fcgz3nXBWMDfv4ZQLGyrxSWbZw6526Y25qcnOWTLy7IS9vmiKnC6QyJfMtGmLBKo5fn+CNXK2EE+FWA87xPnp6a3XJsxbkKcxzVb297N0In5StkAq3g1I6vgq7BoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPunQAKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPunQAKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED65C4CEF8;
	Thu, 27 Nov 2025 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255189;
	bh=qd2SHDIVnvCLxxasESOtKR7rsRqJH+G3lp+TtsxeeM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPunQAKtVLKV3peYKtTHqSxIEIw37UN7Q+CoIPlE0jhNWGnVxo0Wx0UkUey2TzWDm
	 T6J7ZS9v2HeffzEvpJHcJBduLPGnTt8kRmPW05Pyhk2p0w0rmVSxItl1Mb5kuSAHck
	 hzCpjsnsyJUxJEgDGHdv+7aRK0VWodABNi3M5Dxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 039/112] mptcp: fix premature close in case of fallback
Date: Thu, 27 Nov 2025 15:45:41 +0100
Message-ID: <20251127144034.271955906@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 17393fa7b7086664be519e7230cb6ed7ec7d9462 upstream.

I'm observing very frequent self-tests failures in case of fallback when
running on a CONFIG_PREEMPT kernel.

The root cause is that subflow_sched_work_if_closed() closes any subflow
as soon as it is half-closed and has no incoming data pending.

That works well for regular subflows - MPTCP needs bi-directional
connectivity to operate on a given subflow - but for fallback socket is
race prone.

When TCP peer closes the connection before the MPTCP one,
subflow_sched_work_if_closed() will schedule the MPTCP worker to
gracefully close the subflow, and shortly after will do another schedule
to inject and process a dummy incoming DATA_FIN.

On CONFIG_PREEMPT kernel, the MPTCP worker can kick-in and close the
fallback subflow before subflow_sched_work_if_closed() is able to create
the dummy DATA_FIN, unexpectedly interrupting the transfer.

Address the issue explicitly avoiding closing fallback subflows on when
the peer is only half-closed.

Note that, when the subflow is able to create the DATA_FIN before the
worker invocation, the worker will change the msk state before trying to
close the subflow and will skip the latter operation as the msk will not
match anymore the precondition in __mptcp_close_subflow().

Fixes: f09b0ad55a11 ("mptcp: close subflow when receiving TCP+FIN")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-3-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2615,7 +2615,8 @@ static void __mptcp_close_subflow(struct
 
 		if (ssk_state != TCP_CLOSE &&
 		    (ssk_state != TCP_CLOSE_WAIT ||
-		     inet_sk_state_load(sk) != TCP_ESTABLISHED))
+		     inet_sk_state_load(sk) != TCP_ESTABLISHED ||
+		     __mptcp_check_fallback(msk)))
 			continue;
 
 		/* 'subflow_data_ready' will re-sched once rx queue is empty */


