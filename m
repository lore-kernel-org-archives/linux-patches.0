Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0744B34F49C;
	Wed,  3 Dec 2025 16:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778392; cv=none; b=iKtd/2wvPP7fjkxVC8YTVlDErFqislwmqUfeezj7iIs0vpv4KGsX5j/yR/qoVuMEODJyV2109Xifswhnrm2AFsQmQxbRu606mahy6CAkN7sJGfdK01OvDj/fWh3bKGuU2oIJt+RvPePpVNO+SHLUT3B3asNJlwymyg79suYqSdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778392; c=relaxed/simple;
	bh=cEoLVAAPLkhcNvt1BzJCCTaMS+c1GhD/vOOXHwcfxTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEgd6N3+kqmy+NqlwTYAP2lX0EbAArmwXQbECPj7bq8FZUuVdk7ZOmEV6V8VsmWi9eaBasKw9MlKn15yo8wI+cWTxu9UiVrBRuC6hbbZE9RU4jtsG8DLt1fHXhnUpcRkBuHnA8JR540Jo6QrYG/q5sognr92dd79YyFNeMAhhYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3mntrv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3mntrv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C6BC4CEF5;
	Wed,  3 Dec 2025 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778391;
	bh=cEoLVAAPLkhcNvt1BzJCCTaMS+c1GhD/vOOXHwcfxTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3mntrv+2UTqea0yswvSSJxbAVjpf0/Ur3MogM1+zvCRQ4YjLghOBCHnTY7bE1GpI
	 Na2Yx7u7v7hTcl3i6swHly7gx2hP4wsw293Gru6ztCND0IbQmcW72e8XtRF8Xj4oHk
	 K+5PlEBFrSX9+ljiLyMj5OL0XCUlJiiKzr+xSPZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/392] mptcp: fix ack generation for fallback msk
Date: Wed,  3 Dec 2025 16:28:01 +0100
Message-ID: <20251203152426.348293192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 5e15395f6d9ec07395866c5511f4b4ac566c0c9b ]

mptcp_cleanup_rbuf() needs to know the last most recent, mptcp-level
rcv_wnd sent, and such information is tracked into the msk->old_wspace
field, updated at ack transmission time by mptcp_write_options().

Fallback socket do not add any mptcp options, such helper is never
invoked, and msk->old_wspace value remain stale. That in turn makes
ack generation at recvmsg() time quite random.

Address the issue ensuring mptcp_write_options() is invoked even for
fallback sockets, and just update the needed info in such a case.

The issue went unnoticed for a long time, as mptcp currently overshots
the fallback socket receive buffer autotune significantly. It is going
to change in the near future.

Fixes: e3859603ba13 ("mptcp: better msk receive window updates")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/594
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-1-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -810,8 +810,11 @@ bool mptcp_established_options(struct so
 
 	opts->suboptions = 0;
 
+	/* Force later mptcp_write_options(), but do not use any actual
+	 * option space.
+	 */
 	if (unlikely(__mptcp_check_fallback(msk)))
-		return false;
+		return true;
 
 	if (unlikely(skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_RST)) {
 		if (mptcp_established_options_mp_fail(sk, &opt_size, remaining, opts)) {
@@ -1222,6 +1225,20 @@ static void mptcp_set_rwin(const struct
 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 }
 
+static void mptcp_track_rwin(const struct tcp_sock *tp)
+{
+	const struct sock *ssk = (const struct sock *)tp;
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk;
+
+	if (!ssk)
+		return;
+
+	subflow = mptcp_subflow_ctx(ssk);
+	msk = mptcp_sk(subflow->conn);
+	WRITE_ONCE(msk->old_wspace, tp->rcv_wnd);
+}
+
 __sum16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)
 {
 	struct csum_pseudo_header header;
@@ -1283,6 +1300,12 @@ void mptcp_write_options(__be32 *ptr, co
 		return;
 	}
 
+	/* Fallback to TCP */
+	if (unlikely(!opts->suboptions)) {
+		mptcp_track_rwin(tp);
+		return;
+	}
+
 	/* DSS, MPC, MPJ and ADD_ADDR are mutually exclusive, see
 	 * mptcp_established_options*()
 	 */


