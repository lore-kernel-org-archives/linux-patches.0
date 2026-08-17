Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0619943990C;
	Mon, 17 Aug 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977997; cv=none; b=gnzs2j1ef6iLhMVwLYboopRKB9CKJI3Eyw5qcVfLlRAPPUE2EZqMmG5mhGRUGY5c7rz0gnBkqFqBMQoX7c4pya4GpAw3FhGwHLlvC71OQZcPO6FZ0qd0eXXx+MW3eyNynXOfVHZmxdCrB/UfI+s9LJEy7UKTOO2WJ9CXl2767sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977997; c=relaxed/simple;
	bh=tpPelYqIFRwcaDG6XEQ6YmCoi+l/xvZxDnpVnLOLM2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gihauldJsSX7pVCIbIKCg75QKo+YBGelddqaMHzcGJ+SW2hyS4tpeZJVzkIOd4C2S+bsvybAgQtICcdGGH+H+ectQ0W5TzRAYYGEJub1ZaLp90TUvJm+A8z7a5H7QRZj5JN845nk5b4ISIoVsN1lMXreLqd+m/YN9iec74VEz3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghG/kl0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghG/kl0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1521F000E9;
	Mon, 17 Aug 2026 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977995;
	bh=XY+hGjXV6djeFy5fiJ555C8Zc5b59uh+77rIv19PR4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghG/kl0a9nai0A58Hd+SaV25QqcsyG+i1TArBADAZmgXT9Q2DwAH44i9vhZfL6CIA
	 j5NwKdYnIVCbAipNPy6B35haKJ0blzvVPO4owHk6CjilZLpygxycL0QwxiAB6IilMF
	 VRwWt59q+ZJy5vMPVtwFTIYhYALN1GGE4lFk7yh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Gao <zcgao@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/181] tcp: do not change rcv_ssthresh in tcp_measure_rcv_mss()
Date: Mon, 17 Aug 2026 15:32:12 +0200
Message-ID: <20260817132536.875937338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Nathan Gao <zcgao@amazon.com>

[ Upstream commit 0e125ecfe20c077625cf0be8d750d5c3abc0dce9 ]

Commit f5da7c45188e ("tcp: adjust rcvq_space after updating scaling
ratio") replaced the direct window_clamp update in tcp_measure_rcv_mss()
with a call to tcp_set_window_clamp(), a helper that implements the
TCP_WINDOW_CLAMP setsockopt. As a side effect, the helper also shrinks
rcv_ssthresh via __tcp_adjust_rcv_ssthresh().

As a result, each scaling_ratio decrease detected by
tcp_measure_rcv_mss() also cuts rcv_ssthresh. Elsewhere in TCP,
rcv_ssthresh is usually cut under memory pressure and grows via
tcp_grow_window().

Flows whose segment sizes vary keep scaling_ratio oscillating, which
leads to an unstable rcv_ssthresh: a dip of rcv_ssthresh only recovers
via tcp_grow_window(), keeping the advertised window at a relatively
low level even after the ratio itself has recovered, and can even stall
the sender.

Observed on a customer's proxy gateway after upgrading from kernel 6.1
to 6.12: in the worst case, rcv_ssthresh was cut in half by a
scaling_ratio dip. P99 latency jumped from <10ms on 6.1 to ~100ms on
6.12, and almost returned to the 6.1 level with this patch applied.

Restore the plain WRITE_ONCE() update of window_clamp, as introduced
in commit a2cbb1603943 ("tcp: Update window clamping condition"), and
keep the rcvq_space.space adjustment. Now rcv_ssthresh is decoupled from
scaling_ratio changes in tcp_measure_rcv_mss().

Fixes: f5da7c45188e ("tcp: adjust rcvq_space after updating scaling ratio")
Signed-off-by: Nathan Gao <zcgao@amazon.com>
Link: https://patch.msgid.link/20260725030806.28135-1-zcgao@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e57917aefd508..2fb68455679a8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -247,7 +247,7 @@ static void tcp_measure_rcv_mss(struct sock *sk, const struct sk_buff *skb)
 				struct tcp_sock *tp = tcp_sk(sk);
 
 				val = tcp_win_from_space(sk, sk->sk_rcvbuf);
-				tcp_set_window_clamp(sk, val);
+				WRITE_ONCE(tp->window_clamp, val);
 
 				if (tp->window_clamp < tp->rcvq_space.space)
 					tp->rcvq_space.space = tp->window_clamp;
-- 
2.53.0



