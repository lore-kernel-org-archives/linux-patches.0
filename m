Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2224425CEE;
	Tue, 16 Jun 2026 16:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627334; cv=none; b=DhAbZcKlPJhcR+gNEDQXn3nKOEBmoKYn8ZNYxOsqeSjFC2gUvYKULg2S0pIpKMzH/3woCGwvUiXPwnLecsQAoq1zT2jxxefRYk6+vqhiI+DV45N3QuTS0CpHcuVhVuhZN+Nnc7e/GJjn3a4/4mQMI74zU/YFzIoefD1Q+XkTrL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627334; c=relaxed/simple;
	bh=RHWRvJ4WqM7ERxE0aE+kaj0XMg+xYyPiA9e0p8tPWMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHSL+l1mcviaCqmzFj7zCKP6jWxmfWm+nBgUn5dgw82AepYk1kHMwGyi+o+eeNCkYuqbAqZvxiyOchsPFBjoPdpkymNE60rPTf0STHW5ymJcoW2Gn3CEdSrQaFzEMWr814vWrlnrT38wC5A3Y3zwiHUytP85iTJzXeGqmsNf8qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxxpGQk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxxpGQk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43591F000E9;
	Tue, 16 Jun 2026 16:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627333;
	bh=qBF6TDHqnUzcQH9yLqxSp+2yHIH1EeMiG1Afm2INx1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxxpGQk9CIaZ55wdNVRGfFvtf10RsvLQzRpEm0CagPcn+vlQMKx/cr27X6NDggk4b
	 tEqqhCSk4jyJH1Skb+jsl8StMdu4yBT9TOk2gB1ctVH3RXulOR0UPKVurKCgGmyIOu
	 zZ7YlwMjMr6vtb2f3UiXwWofbqz0UWgiMoTwIF2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 158/261] mptcp: allow subflow rcv wnd to shrink
Date: Tue, 16 Jun 2026 20:29:56 +0530
Message-ID: <20260616145052.397991004@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

commit da23be77e1292cd611e736c3aa17da633d7ddce7 upstream.

In MPTCP connection, the `window` field in the TCP header refers to the
MPTCP-level rcv_nxt and it's right edge should not move backward. Such
constraint is enforced at DSS option generation time.

At the same time, the TCP stack ensures independently that the TCP-level
rcv wnd right's edge does not move backward. That in turn causes artificial
inflating of the MPTCP rcv window when the incoming data is acked at the
TCP level and is OoO in the MPTCP sequence space (or lands in the backlog).

As a consequence, the incoming traffic can exceed the receiver rcvbuf size
even when the sender is not misbehaving.

Prevent such scenario forcibly allowing the TCP subflow to shrink the
TCP-level rcv wnd regardless of the current netns setting.

Fixes: f3589be0c420 ("mptcp: never shrink offered window")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-4-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -567,6 +567,7 @@ static bool mptcp_established_options_ds
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int dss_size = 0;
 	struct mptcp_ext *mpext;
 	unsigned int ack_size;
@@ -615,6 +616,12 @@ static bool mptcp_established_options_ds
 	if (dss_size == 0)
 		ack_size += TCPOLEN_MPTCP_DSS_BASE;
 
+	/* The caller is __tcp_transmit_skb(), and will compute the new rcv
+	 * wnd soon: ensure that the window can shrink.
+	 */
+	if (skb)
+		tp->rcv_wnd = tp->rcv_nxt - tp->rcv_wup;
+
 	dss_size += ack_size;
 
 	*size = ALIGN(dss_size, 4);


