Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61705499F02;
	Mon, 31 Aug 2026 14:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185258; cv=none; b=E3yorwjzHs7DxoYxh9nVfPzCCO3i0h54R/b8c9twzue+7wJjvpV292oEnx2Bqu4T6+lD0rUAzqxYX9xo7CMHFCq7UdvnVy0mNARTLqZ0GL0ZSbEHoAPB4KUZ0wH+nl03A4JowySBYdl3eZEWJqB5bP48lLADVyvkJlxjxZ0Ww1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185258; c=relaxed/simple;
	bh=ylo5z3ckQHpHqJb6a5kGpN1ON+IKcrzWvo8KcoGiEMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgjNgqjE6UyLbgzIh5hTnGQunvieKhKrWcYTlN1Y6PnSAvsI2FKfOsqoLH3Sym6hfGGkV4OdxTMwTq+vVHpPw6fYC+Vw8FaVWdZGlu+QxL3iImM3V7uIWBElgHnjN/ZD6pvjFPuClrMdNzjBzmCz8WsrXiV934+1NsaTAFsnJG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSo9L52p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSo9L52p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23621F000E9;
	Mon, 31 Aug 2026 14:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185257;
	bh=G74TUqE3LJSD65FggfcnVDlpRs0hMfpFNB/sMBbcsCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSo9L52p9Yoax1tVHMKN7tveFI27waKf8qJPlYXXvdgR/u8RSSyK76IPdVuzflrPf
	 iQH7+RlFYTI++MjdYv9GBDboPwaCvVdjRp4zOPWN5qeO8kIsl6NdfbdWLf7s8Y7/OC
	 XWR3E1mgm9KlCP0Xgyjp4RSuenD07cLllpKc/vKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@linux.dev>,
	syzbot+608a2acde8c5a101d07d@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/43] bpf: Remove tst_run from lwt_seg6local_prog_ops.
Date: Mon, 31 Aug 2026 15:35:14 +0200
Message-ID: <20260831133358.832009876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit c13fda93aca118b8e5cd202e339046728ee7dddb ]

The syzbot reported that the lwt_seg6 related BPF ops can be invoked
via bpf_test_run() without without entering input_action_end_bpf()
first.

Martin KaFai Lau said that self test for BPF_PROG_TYPE_LWT_SEG6LOCAL
probably didn't work since it was introduced in commit 04d4b274e2a
("ipv6: sr: Add seg6local action End.BPF"). The reason is that the
per-CPU variable seg6_bpf_srh_states::srh is never assigned in the self
test case but each BPF function expects it.

Remove test_run for BPF_PROG_TYPE_LWT_SEG6LOCAL.

Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
Reported-by: syzbot+608a2acde8c5a101d07d@syzkaller.appspotmail.com
Fixes: d1542d4ae4df ("seg6: Use nested-BH locking for seg6_bpf_srh_states.")
Fixes: 004d4b274e2a ("ipv6: sr: Add seg6local action End.BPF")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20240710141631.FbmHcQaX@linutronix.de
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 18d8094d87591..8ec5b4d868ab9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9920,7 +9920,6 @@ const struct bpf_verifier_ops lwt_seg6local_verifier_ops = {
 };
 
 const struct bpf_prog_ops lwt_seg6local_prog_ops = {
-	.test_run		= bpf_prog_test_run_skb,
 };
 
 const struct bpf_verifier_ops cg_sock_verifier_ops = {
-- 
2.53.0



