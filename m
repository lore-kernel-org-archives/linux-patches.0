Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22304F93A8;
	Wed, 30 Sep 2026 16:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786309; cv=none; b=S1DJ4dV/C+4svMO2Gz97jDzHbyAOXOuhtQlsuCZ09YkXhpOBP1rd0sVg1lHE/8cCgad73xdYDjHi5vg6omDm3eATj0lOp214l+v7zZAQOq52tfspgLMZq1vkgD1KncEzFN5Lk+XaHHHB/6Z74NutwzAUrUyCDWUzdMndbut4gIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786309; c=relaxed/simple;
	bh=z3RyP1Q84AsrEtgt+wXE3Bb8nkGnCt7dwWBhrz4Pmbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvhMiOSZBDoa2wJu6pemL9jKEEeZmsiMd39hLUDydFX8DS3uHUeT8IZNdmuJJeYBdEvaxn7W16ge/SYkwhqRiAxo1x8xwIEj92Ye14oKRAqR8leaKpSiPxXhFg77jBiI+zFUpTvqQ6j/whZdCZBBuOTqdwJZ8Erid33m+7fdOuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8kA9i6o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8kA9i6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE271F000FF;
	Wed, 30 Sep 2026 16:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786307;
	bh=xx6vmFVZe8emkXpirQuJTZtuMNZ+K2z9o5JG3hr4gDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8kA9i6oIcXc4WG3gy1f5hoWspKCwRWOXW6tUIphRruQ1c2dBugMQroyygQgI/n8B
	 nkn/ly16z/uybJXIts5j4EDtUz0uFvBRlWZbYYHZ8caRJSSAYvgTLxZc8NJ079vH//
	 LF2iBElWzlBd9M3VdoX5e0Re9dYgbzHqUQmbEehg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 815/982] bpf, sockmap: Fix self-redirect copied_seq double-counting
Date: Wed, 30 Sep 2026 17:25:51 +0200
Message-ID: <20260930152434.264320864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 490a83d6386eec1d29f470c8d7331677fb46c3b7 ]

When a BPF stream_verdict program redirects an skb back to the same
socket (self-redirect with BPF_F_INGRESS), sk_psock_verdict_apply()
calls tcp_eat_skb() which advances tcp_sk->copied_seq. However, the
skb is then delivered to the socket's psock ingress queue and later
read by tcp_bpf_recvmsg_parser(), which also advances copied_seq via
the copied_from_self accounting path. This double-counting causes
copied_seq to advance by 2x the actual data length, triggering:

  TCP recvmsg seq # bug 2: copied BF2E806, seq BF2E7FD, \
			   rcvnxt BF2E806, fl 0
  WARNING: net/ipv4/tcp.c:2745 at tcp_recvmsg_locked+0x72b/0x2640
  Call Trace:
   tcp_recvmsg+0x10a/0x500
   sock_recvmsg+0x168/0x1d0
   __sys_recvfrom+0x19a/0x2a0
   __x64_sys_recvfrom+0xe4/0x1f0
   do_syscall_64+0xf7/0x530
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  cleanup rbuf bug: copied BF2E806 seq BF2E806 rcvnxt BF2E806
  WARNING: net/ipv4/tcp.c:1609 at tcp_cleanup_rbuf+0xf2/0x1c0
  Call Trace:
   tcp_recvmsg_locked+0x8d1/0x2640
   tcp_recvmsg+0x10a/0x500
   sock_recvmsg+0x168/0x1d0
   __sys_recvfrom+0x19a/0x2a0
   __x64_sys_recvfrom+0xe4/0x1f0
   do_syscall_64+0xf7/0x530
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix this by converting self-redirect verdict to __SK_PASS at the
beginning of sk_psock_verdict_apply(). This bypasses the
__SK_REDIRECT case entirely (which calls sk_psock_eat_skb), letting
the __SK_PASS path queue the skb to the psock ingress queue. The
data is then read via tcp_bpf_recvmsg_parser(), which advances
copied_seq exactly once through copied_from_self. Cross-socket
redirects continue through __SK_REDIRECT with sk_psock_eat_skb()
unchanged.

Fixes: e5c6de5fa025 ("bpf, sockmap: Incorrectly handling copied_seq")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Suggested-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/1a8e797a1b26e2f695aaac22ac644c2862f63466.1788858299.git.tanggeliang@kylinos.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 11bc309811d30..20e67399f0b6a 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1031,6 +1031,10 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 	int err = 0;
 	u32 len, off;
 
+	if (verdict == __SK_REDIRECT && skb_bpf_ingress(skb) &&
+	    skb_bpf_redirect_fetch(skb) == psock->sk)
+		verdict = __SK_PASS;
+
 	switch (verdict) {
 	case __SK_PASS:
 		err = -EIO;
-- 
2.53.0



