Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD7843AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGbOgZAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066B4C43391;
	Wed, 15 Nov 2023 20:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081231;
	bh=j3sO1PSUnt5dZaTcgwK7U0EYNWc+u6wlk2tvS+mMx2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGbOgZApRvuvFP8MIlPv7D71ZUWBfUuxNgyOAJU4gtehTOTzOB8v09d7SNUt0NcSx
	 uc/byvmN50bC3WOp6jcv4jy9FGrk1z9e9sERQH2yfMChNJf9ioKYbqPFfxdHK4QcId
	 ggXhFd10IKot/HoP51X71Ateqzl/oyhRGMRWD4hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/244] tcp_metrics: properly set tp->snd_ssthresh in tcp_init_metrics()
Date: Wed, 15 Nov 2023 15:33:42 -0500
Message-ID: <20231115203550.186199437@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 081480014a64a69d901f8ef1ffdd56d6085cf87e ]

We need to set tp->snd_ssthresh to TCP_INFINITE_SSTHRESH
in the case tcp_get_metrics() fails for some reason.

Fixes: 9ad7c049f0f7 ("tcp: RFC2988bis + taking RTT sample from 3WHS for the passive open side")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 0275bf7570b4c..940f75df19358 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -470,6 +470,10 @@ void tcp_init_metrics(struct sock *sk)
 	u32 val, crtt = 0; /* cached RTT scaled by 8 */
 
 	sk_dst_confirm(sk);
+	/* ssthresh may have been reduced unnecessarily during.
+	 * 3WHS. Restore it back to its initial default.
+	 */
+	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	if (!dst)
 		goto reset;
 
@@ -489,11 +493,6 @@ void tcp_init_metrics(struct sock *sk)
 		tp->snd_ssthresh = val;
 		if (tp->snd_ssthresh > tp->snd_cwnd_clamp)
 			tp->snd_ssthresh = tp->snd_cwnd_clamp;
-	} else {
-		/* ssthresh may have been reduced unnecessarily during.
-		 * 3WHS. Restore it back to its initial default.
-		 */
-		tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	}
 	val = tcp_metric_get(tm, TCP_METRIC_REORDERING);
 	if (val && tp->reordering != val)
-- 
2.42.0



