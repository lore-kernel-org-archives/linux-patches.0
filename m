Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09CD46C4D5;
	Tue, 21 Jul 2026 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655159; cv=none; b=rDOLHmT/78APel1z3QLsFltehKCVnKo233QvHCxDoy/SWeduSjF1JezEcWsFCSvr9YqbyyLeReXuK3j0uxgmLB/2InABd0IeBVa/7paAFH2dsnjzIMowvyjb/jOjvd/SxLoKaVjapoXn1MedyIElImzsDRto0+ZjgGJFEmvjIC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655159; c=relaxed/simple;
	bh=md45yWuQTDqCD3pMui7My5it7+DN5TKOsn+ok/tp9wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kqbq8OYQl/n9GCCCH3qvWlYHHTAqLxbC13y3cWWc12PjG6rUtOCcQ2x6m3fqcH5X6IdkjYCHR9LddIxiwNqMrju4hohUw7dzz02G1tGBbvk6IMLlVFfzV2hPt0fD+eEtnwDG2JEeX/LDQbpkddmWgPfMGULc2fR9KsQEFfDDlDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pujPfQ/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pujPfQ/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6DD1F000E9;
	Tue, 21 Jul 2026 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655158;
	bh=QT5d81YBF5WRGaU2erY0aw+DAKQmsIJlc1WHFCo4PeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pujPfQ/fYqDS7yFCvIaRtF6x/ZQJxWM4Wcj47wschf+gvYqaG/TyNLtEFWQXxnYnG
	 7qy3TA733TB4/uzaJdlJciy3e2SY39HLQoqYqL2M3WiKmfexOW5P/4YQooNzXADrlx
	 joPC+o/ZCqoFlfB0dmoVqBwfemKD2AM69H5ZiYHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1976/2077] ipvs: reset full ip_vs_seq structs in ip_vs_conn_new
Date: Tue, 21 Jul 2026 17:27:29 +0200
Message-ID: <20260721152639.313100055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit 2975324d164c552b028632f107b567302863b7f6 upstream.

Commit 9a05475cebdd ("ipvs: avoid kmem_cache_zalloc in
ip_vs_conn_new") changed ip_vs_conn_new() to allocate an ip_vs_conn
object with kmem_cache_alloc().  The function then initializes many
fields explicitly, but only resets in_seq.delta and out_seq.delta in the
two struct ip_vs_seq members.

That leaves init_seq and previous_delta uninitialized.  This is normally
harmless while the corresponding IP_VS_CONN_F_IN_SEQ or
IP_VS_CONN_F_OUT_SEQ flag is clear.  For connections learned from a sync
message, however, ip_vs_proc_conn() preserves those flags from
IP_VS_CONN_F_BACKUP_MASK and passes opt=NULL when the message omits
IPVS_OPT_SEQ_DATA.  In that case the new connection can be hashed with
SEQ flags set but with the rest of in_seq/out_seq still containing stale
slab data.

When a packet for such a connection is later handled by an IPVS
application helper, vs_fix_seq() and vs_fix_ack_seq() use
previous_delta and init_seq to rewrite TCP sequence numbers.  A malformed
sync message can therefore make forwarded packets carry stale slab bytes
in their TCP seq/ack numbers, and can also corrupt the forwarded TCP
flow.

Reset both struct ip_vs_seq members completely before publishing the
connection.  This matches the existing "reset struct ip_vs_seq" comment
and keeps the sequence-adjustment gates inactive unless valid sequence
data is installed later.

Fixes: 9a05475cebdd ("ipvs: avoid kmem_cache_zalloc in ip_vs_conn_new")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_conn.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1411,8 +1411,8 @@ ip_vs_conn_new(const struct ip_vs_conn_p
 	cp->app = NULL;
 	cp->app_data = NULL;
 	/* reset struct ip_vs_seq */
-	cp->in_seq.delta = 0;
-	cp->out_seq.delta = 0;
+	memset(&cp->in_seq, 0, sizeof(cp->in_seq));
+	memset(&cp->out_seq, 0, sizeof(cp->out_seq));
 
 	atomic_inc(&ipvs->conn_count);
 	if (unlikely(flags & IP_VS_CONN_F_NO_CPORT)) {


