Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE70951EDFF;
	Wed, 30 Sep 2026 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792782; cv=none; b=QUtWaWcFDV3KVah1dSwIDF0k0VKtkL9f0Wc19vul9FWMX0A94YzVUt4K5lfjarml1oyrCmChNfQxbecW6PA2f4l6IldK6YcqSJRUnjWBaH1diJ/xQLZ3lGVYN582KPTxOBl7R3adatqp7XpLWLeOD6S1PmeLv9nTWdXBGPbkpl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792782; c=relaxed/simple;
	bh=48LZ6w/xuVrjy8zCxJ4jK0hL3pZ1FxY8S3ClnjVHrXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j77dWSwxUY+hafq949MxevLfuCxxp4WbixrgyoopYDHCAdGFwHXXbyqEQjUjkDb62uy59CDq63nUn3vgFspdu7YdCQaUxI0vwTBxgh3BBGtpR21xBR8xDMCz+wUJ1AbLNwwwd5IAVcsdNGNGo262jbXFX6N0hpxIECGxHdWn8PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5bCrKuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5bCrKuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA601F000FF;
	Wed, 30 Sep 2026 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792780;
	bh=azml8rCGh9gexDMYMMiRSNCRuoKq9YMgEo55Drx68a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5bCrKuzHNO56PdNI6fIneIA3gLeq/BaF5pQUKjhM0lxNB6zC0eRMK9W6rYQB4+Fu
	 EFW0qHIi8jBn6hRJc0+KJTE9Q1Y40rzRmNXekbf0aRzWZFEc8bkwMTU694uQ5Q2xRb
	 Wkts3X9NJKg8pOAyj+M8WBKSU6HRq8I8XVgjxlYk=
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
Subject: [PATCH 6.18 023/395] bpf, sockmap: Fix self-redirect copied_seq double-counting
Date: Wed, 30 Sep 2026 17:24:45 +0200
Message-ID: <20260930152341.120164367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c1c315ae2b22b..f5c12ef68675c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1036,6 +1036,10 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
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



