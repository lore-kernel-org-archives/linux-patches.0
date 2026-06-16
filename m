Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7BA3D8105;
	Tue, 16 Jun 2026 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634221; cv=none; b=c0WgEUAvY1qA6w7kt0OURSIfZTJ3eCKZfj1WHhQ7PXAOMHjlyaiTtidbr+F0jOoUSn8acQid+MEZ2SxG6xtUdEglczu4asXvEGztFFePOkEpkVYmjvp2u5ljy5KfHw74XgWog+RY12OYrekczpG+iVA/a3fixNOCpi4T1UgdkZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634221; c=relaxed/simple;
	bh=ZWElGjKb7XTaarr5sGwXn3gWRt0j+42t70xVqGvTkek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIh1qI/+vWUruhrDjuj1u+2mfDhWNUxPbSi0IFeckcEpcMqfxW++aChEZ0fUchfkL6akg3frMl2zeLIGC6l93a4+FDNpg+pLuu8+R8x4JQOUO1CZvg81vDyZjyx+50k4I/QXM+l3j5uY8NMJ84AkbOS5ktGh9S/lbf/b2gtY/So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrvvdCyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrvvdCyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B9D1F000E9;
	Tue, 16 Jun 2026 18:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634220;
	bh=OL/7I2fQTwsFr0IZU22zyfpfFqvgSH5K/vrkY8zaF1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrvvdCyHiZX0/pDWsOuoRKiDsslU0eUXLpifd490B5gYqWWfXhwZq78Yil3xOCjMU
	 fVy0CbA7kN6heSFlUgx7lPuyqifYE5I/HF646uIgRUstpB0WQYx/nCiHhgVK9u0ukf
	 O50f6Ih30qkxH+eQGA32+UyOYdfcpuDC0eu2M5nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 214/411] mptcp: fix retransmission loop when csum is enabled
Date: Tue, 16 Jun 2026 20:27:32 +0530
Message-ID: <20260616145112.144612918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

commit d1918b36edcaed0ec4ef6888b2358c6b1ddcff47 upstream.

Sashiko noted that retransmission with csum enabled can actually
transmit new data, but currently the relevant code does not update
accordingly snd_nxt.

The may cause incoming ack drop and an endless retransmission loop.

Address the issue incrementing snd_nxt as needed.

Fixes: 4e14867d5e91 ("mptcp: tune re-injections for csum enabled mode")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-2-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2539,6 +2539,10 @@ static void __mptcp_retrans(struct sock
 
 	release_sock(ssk);
 
+	/* With csum enabled retransmission can send new data. */
+	if (after64(dfrag->already_sent + dfrag->data_seq, msk->snd_nxt))
+		WRITE_ONCE(msk->snd_nxt, dfrag->already_sent + dfrag->data_seq);
+
 reset_timer:
 	if (!mptcp_rtx_timer_pending(sk))
 		mptcp_reset_rtx_timer(sk);


