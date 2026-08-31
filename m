Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E6347D442;
	Mon, 31 Aug 2026 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184706; cv=none; b=pCl5Q+Ul+WrFw7XPfXRJS7npgwTknsII//ASCmRQ+4NrvPszh9xKxWKWjJyfSycs46R7hBdm1Hc3bxbOtLsyZlya9IZSaRtH0KTGTEFmHpEid5AuVIkRFoCVFcqB93vGMb9IDbDVyOVLrmWbgWwnGmLQtDWeQbgNumgUEFnM/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184706; c=relaxed/simple;
	bh=e/OQrEkR1D9RQwn8cvaNi/qZbjvGJ0o5eBU8cR32dKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxnKlyyMuvmr1afYh1oq9+m77CdGE4gTbzem3SKJtfvm+cjPMlxOdynu6atlifRkXXsxRPKhe2+qNSCokiVrTXoU3XpqvmgwjY0ttnHYFcKbIFkmK/XBkyt5lIwbWiFYFzfCkWQsw97b80ZfN5wX3WGhEfJu/yDoCL4yTuZLQ2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQhH9f0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQhH9f0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FDA1F000E9;
	Mon, 31 Aug 2026 13:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184705;
	bh=A3VIGYL9NWj9xR8ANx/laWdS+UJBxRwdA/wfF9R1tYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQhH9f0j9sMgJA+BZ9BiZiARyPSKlbZJnzu52NXlL0/x2mPhLX3tBCdF3EPf10sjg
	 J1oDFvi0GYXBA+5j4AFPOew8mleRL4aeYZXesCDgf/S0BEUZnsjQGDi+C3FqQykqZC
	 2HJKED/KnL9iSlhEyEOg88fZceVebVXgc5OSQhbI=
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
Subject: [PATCH 6.1 10/92] bpf: Remove tst_run from lwt_seg6local_prog_ops.
Date: Mon, 31 Aug 2026 15:34:08 +0200
Message-ID: <20260831133400.026645696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
index 91d337252fc90..e2fd25d9e3580 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -11041,7 +11041,6 @@ const struct bpf_verifier_ops lwt_seg6local_verifier_ops = {
 };
 
 const struct bpf_prog_ops lwt_seg6local_prog_ops = {
-	.test_run		= bpf_prog_test_run_skb,
 };
 
 const struct bpf_verifier_ops cg_sock_verifier_ops = {
-- 
2.53.0



