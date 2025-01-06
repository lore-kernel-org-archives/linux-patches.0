Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5B81DC9AD;
	Mon,  6 Jan 2025 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178307; cv=none; b=qYYIrDlIqdM6BAd+tRV/cKRI6Jffth6rnzXRL+SYJJ9CEJVLUaAw5g9R2WQEHe9xQYjiooS5Shgb+LE9SCSCbGU+53uRwc4olPkDbCNgmGSORdub6jratu4c9hNbld/XdWbUlYe08wppIFjOEN+wtsennEyluYRr5PKs30WzYSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178307; c=relaxed/simple;
	bh=gBq02eoNxMubUIs08iXEq/xfibTnrFx3GYRzCHNlRCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBNHQgarzr6F/oKhhxwB/sQeC/3g66WRh1a/q26mi7k4R4j4dUUw/mkYcf750Cub/qN6YYVIHsU5EAZ56gdebD+9T9iwU58DThQ8JfyKK1mhPFNQL246/TARaiXdT/tWHddg1xvRDOIwENxyymK5Lpv5YyFLzIOut3F16OF3leY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2BM78Ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2BM78Ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD60C4CED2;
	Mon,  6 Jan 2025 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178307;
	bh=gBq02eoNxMubUIs08iXEq/xfibTnrFx3GYRzCHNlRCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2BM78OwwW7DHMTIou3wBDE1pV8sIXwdvse0hEZUHqZF6hWk85ad4x86o4/snIlGS
	 uOYpqU/CB/iWjohKTPun+segdIuWK9OxTbGCo4Ax9tu4CtLBQPfaR9HE9wPhFGujHY
	 xkHemKcZ7N32D6NkWgnf1sLqlvTLq9TudbRlLtyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Whitchurch <vincent.whitchurch@datadoghq.com>,
	Jiayuan Chen <mrpre@163.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Srish Srinivasan <srishwap4@gmail.com>
Subject: [PATCH 5.10 074/138] bpf: fix recursive lock when verdict program return SK_PASS
Date: Mon,  6 Jan 2025 16:16:38 +0100
Message-ID: <20250106151136.035157711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

commit 8ca2a1eeadf09862190b2810697702d803ceef2d upstream.

When the stream_verdict program returns SK_PASS, it places the received skb
into its own receive queue, but a recursive lock eventually occurs, leading
to an operating system deadlock. This issue has been present since v6.9.

'''
sk_psock_strp_data_ready
    write_lock_bh(&sk->sk_callback_lock)
    strp_data_ready
      strp_read_sock
        read_sock -> tcp_read_sock
          strp_recv
            cb.rcv_msg -> sk_psock_strp_read
              # now stream_verdict return SK_PASS without peer sock assign
              __SK_PASS = sk_psock_map_verd(SK_PASS, NULL)
              sk_psock_verdict_apply
                sk_psock_skb_ingress_self
                  sk_psock_skb_ingress_enqueue
                    sk_psock_data_ready
                      read_lock_bh(&sk->sk_callback_lock) <= dead lock

'''

This topic has been discussed before, but it has not been fixed.
Previous discussion:
https://lore.kernel.org/all/6684a5864ec86_403d20898@john.notmuch

Fixes: 6648e613226e ("bpf, skmsg: Fix NULL pointer dereference in sk_psock_skb_ingress_enqueue")
Reported-by: Vincent Whitchurch <vincent.whitchurch@datadoghq.com>
Signed-off-by: Jiayuan Chen <mrpre@163.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20241118030910.36230-2-mrpre@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[srish: Apply to stable branch linux-5.10.y]
Signed-off-by: Srish Srinivasan <srishwap4@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 51792dda1b73..890e16bbc072 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -940,9 +940,9 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 		if (tls_sw_has_ctx_rx(sk)) {
 			psock->parser.saved_data_ready(sk);
 		} else {
-			write_lock_bh(&sk->sk_callback_lock);
+			read_lock_bh(&sk->sk_callback_lock);
 			strp_data_ready(&psock->parser.strp);
-			write_unlock_bh(&sk->sk_callback_lock);
+			read_unlock_bh(&sk->sk_callback_lock);
 		}
 	}
 	rcu_read_unlock();
-- 
2.39.5



