Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D62C1E871;
	Fri,  6 Dec 2024 15:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497314; cv=none; b=RustGngPz4UdlEzSsRSdSn/PMjqfDmZjff/7T0mL/rJTRG3SNTsTBlbwVbp6/lq/jPQEp1CZxrESUhxjD2lX24LYyePXSNncl9x8PUQif/ObyUNlwxC1pgyvknzp2T9BUhlPcGJzzklvLXJY0ycNFxS+5yDsLlOW/sJTm/OgPKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497314; c=relaxed/simple;
	bh=vf110dLUeqxiM51J0QJ5yRpON2MFmqQaPFYmYJSfTTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEoIJem8QOeEMsIQIIVOL/g+FAxfCGWaQuRagJEQhW3y1nNmdq1t1K02DjLQKbB73iyTt5B/ooufAsV4dMYmWgCXY748UBpfK/PAdgHPElLOlQw4iPYsW9xQZQQzxPaOAzwpAZTS7jMPNp2CB9xw0lJlJFG3iYWdfcs0pn2SwnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+ljcP8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+ljcP8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE9BC4CED1;
	Fri,  6 Dec 2024 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497314;
	bh=vf110dLUeqxiM51J0QJ5yRpON2MFmqQaPFYmYJSfTTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+ljcP8YLsMMt0bV5540wEcoU0sgthZ1QDqwnqGcy1cal+sTc4jBEPMESuGn8bMPU
	 rZXL/3AGqdIGip8ZEyoNBjDIVzRyIZg5aRdO9fCuxX+YRiOfYpHPBV1XumGy53nlLk
	 9VBEJcRL+vLhryBH+IFwD0FHhY6HGPZtkRIIFNR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Whitchurch <vincent.whitchurch@datadoghq.com>,
	Jiayuan Chen <mrpre@163.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/676] bpf: fix recursive lock when verdict program return SK_PASS
Date: Fri,  6 Dec 2024 15:31:16 +0100
Message-ID: <20241206143703.371857112@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit 8ca2a1eeadf09862190b2810697702d803ceef2d ]

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
---
 net/core/skmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index bbf40b9997138..846fd672f0e52 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1117,9 +1117,9 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 		if (tls_sw_has_ctx_rx(sk)) {
 			psock->saved_data_ready(sk);
 		} else {
-			write_lock_bh(&sk->sk_callback_lock);
+			read_lock_bh(&sk->sk_callback_lock);
 			strp_data_ready(&psock->strp);
-			write_unlock_bh(&sk->sk_callback_lock);
+			read_unlock_bh(&sk->sk_callback_lock);
 		}
 	}
 	rcu_read_unlock();
-- 
2.43.0



