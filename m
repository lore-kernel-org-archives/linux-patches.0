Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FE835C694;
	Tue, 21 Jul 2026 22:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672654; cv=none; b=Xw/0AdUJFkCNZ3KtwkrJ1CQZnWk4eIlkmRdiavEqa8aP7qrGZVn1llx5+iFzJxI0ujDSUqHqeK0hk8exHGytJx7O35510d7f0A25xht/NJ0crqlwROZSkXGKsuEU+EIz3aI0+DzuXHs3UNtlT1deNBqIVloNA/sZrBH1dUrHvu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672654; c=relaxed/simple;
	bh=M0aE5HxvE1pSD6o7RdVgx79LKxVLfv7jBC5y5VatKwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4iGChRsljYEd9rZK7bHtMvZPZP0rz0phiLd5p4wIlruiIK7epDTL0qpDNCgPp0e3dG7J2J2g00ejAOj90HLypL7izoffFqV0H4Ne5SQFYzU5ARYqdZaSQ0fgluzJTsgyuKzcDwAh9Dfgbq4cvEnisdiEm8fBJt6neD2YoxgODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4/I7KLI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4/I7KLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8423D1F000E9;
	Tue, 21 Jul 2026 22:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672653;
	bh=MDPTsmjAlLb7S+9kBSlsVkrdotrLN8jOWNVxh4L4MNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4/I7KLIxqJFjiMlLi6YMcvFVUdAoIeAwtLVfqaROTjsI90tHlFhedUZJHWAOI39h
	 qQahmF8e3lUbzADePHOQyty6CWzELQC57ElaiI4pNepWaMDA5TBQ0jE8gjCA/cG4F2
	 XYZL1tjsmGI6C84CZqlaJP9BUnFyxniFgMy5YKBQ=
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
Subject: [PATCH 5.15 706/843] ipvs: reset full ip_vs_seq structs in ip_vs_conn_new
Date: Tue, 21 Jul 2026 17:25:41 +0200
Message-ID: <20260721152421.931551428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -996,8 +996,8 @@ ip_vs_conn_new(const struct ip_vs_conn_p
 	cp->app = NULL;
 	cp->app_data = NULL;
 	/* reset struct ip_vs_seq */
-	cp->in_seq.delta = 0;
-	cp->out_seq.delta = 0;
+	memset(&cp->in_seq, 0, sizeof(cp->in_seq));
+	memset(&cp->out_seq, 0, sizeof(cp->out_seq));
 
 	atomic_inc(&ipvs->conn_count);
 	if (flags & IP_VS_CONN_F_NO_CPORT)


