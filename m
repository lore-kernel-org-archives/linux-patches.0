Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6230E35B158;
	Wed,  3 Dec 2025 16:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780067; cv=none; b=KrFLrKCTWOZkeI6Mljkd7CQMK9qlIZuF/0VEpaMqin0db5qzj2AY1ID4oX+baC+dGTb3Owb2QocpfpdJMDGtWK2a4m0NssFd9sF0/d6jyyFpMNN9xxMMjw/23M8u+mcHfQMm0CulUn8YlbyPtmt8V+YLXXlyukPc0mDs8/pdMtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780067; c=relaxed/simple;
	bh=JlRmjDYmg3tYgIi2Fsb+WPv6VLJtzZ7AZvfr3uSO+UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iK3L4AJ2hAvsc7IMy4+AtM05ENcvqqVMPHQU5GXw3+zA0SPrJMahAfZLI6w6n5xvQX+7I3MVMHpuW8vYmut+iaOat875rCEDYZOj5HWfGLAEjjwiuKvK+KBU4R2NrSUtcZScgwqyPoGJGCYwXQoBEifyk6aBSzSOfEMF9UHOBH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te5K11Pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te5K11Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DABC4CEF5;
	Wed,  3 Dec 2025 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780067;
	bh=JlRmjDYmg3tYgIi2Fsb+WPv6VLJtzZ7AZvfr3uSO+UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te5K11PqEGjq0qQQxxtnyc+3F/9aO4h9QaDCwnGutD8IhcIzOEhAFV4AN7BHuMXcl
	 jpehUorpYclkhYhSBlUvPwQeBG+G4jDQNS4k/MjFgtbrdbWokNZcg7ZhLHIrPXrXHv
	 W7Q47laG7068Xqnj1hb7GpH3Auw/diJoZv+pkvp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 445/568] mptcp: fix ack generation for fallback msk
Date: Wed,  3 Dec 2025 16:27:27 +0100
Message-ID: <20251203152456.999109733@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 5e15395f6d9ec07395866c5511f4b4ac566c0c9b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -834,8 +834,11 @@ bool mptcp_established_options(struct so
 
 	opts->suboptions = 0;
 
+	/* Force later mptcp_write_options(), but do not use any actual
+	 * option space.
+	 */
 	if (unlikely(__mptcp_check_fallback(msk) && !mptcp_check_infinite_map(skb)))
-		return false;
+		return true;
 
 	if (unlikely(skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_RST)) {
 		if (mptcp_established_options_fastclose(sk, &opt_size, remaining, opts) ||
@@ -1296,6 +1299,20 @@ update_wspace:
 	WRITE_ONCE(msk->old_wspace, tp->rcv_wnd);
 }
 
+static void mptcp_track_rwin(struct tcp_sock *tp)
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
@@ -1588,6 +1605,10 @@ mp_rst:
 				      opts->reset_transient,
 				      opts->reset_reason);
 		return;
+	} else if (unlikely(!opts->suboptions)) {
+		/* Fallback to TCP */
+		mptcp_track_rwin(tp);
+		return;
 	}
 
 	if (OPTION_MPTCP_PRIO & opts->suboptions) {


