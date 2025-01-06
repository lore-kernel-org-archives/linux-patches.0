Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02CD1DD539;
	Mon,  6 Jan 2025 15:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179192; cv=none; b=jhDjMWFl49TPhMK6e7nWjBVRCp0/MH4yLmp1itCZQu/NL5eGlRt+yTfVzL4M6dPGdP5ioMcymLoslee+tg5W1IQ7c6VqLGloqMVimsHfebE53lJmaPldiWJfKRt0H4rC7DN3DELEH7R0fMsZgcGsKxBxwbEMOb/FagxOr8owiAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179192; c=relaxed/simple;
	bh=Q4fDaftEIIVe71f3flseVxIU8FCnzWLkg5026lIk0t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpFk8B8vqCsPOXhTVl6XFf66+wjOMaktt9EoJnws3tGKouHakViZJ7ZDoWh9F8oi5kQwsZq7ZIrQVHIkJec1gLbMLCfTwxA5NL78TFYim4qEM62WPA/x9gYq93+lDigmmoa0zAu0tUmJtUdwK8+UNOkaTIZE8SYHfxKE9kVbCCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEmMzBQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEmMzBQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6C7C4CED2;
	Mon,  6 Jan 2025 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179192;
	bh=Q4fDaftEIIVe71f3flseVxIU8FCnzWLkg5026lIk0t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEmMzBQqwoQC0ut6+/6IwIJQr6iGkiq8y97us2cDMpmgAO73zxxkiLTdFGDs9Y1fD
	 gH5TP2Fh6F8rFy/UGg/r8KpmUcqw5H4hwXORw3B2Ljchscl5SIPatnqWpLmNyos+bQ
	 UobRReY5oJQhJlvWctePl0dNU3icBpHGaCiZ5R+s=
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
Subject: [PATCH 5.4 57/93] bpf: fix recursive lock when verdict program return SK_PASS
Date: Mon,  6 Jan 2025 16:17:33 +0100
Message-ID: <20250106151130.856253891@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a606ad8e8be2..dfc2e4d6a7a0 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -904,9 +904,9 @@ static void sk_psock_strp_data_ready(struct sock *sk)
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



