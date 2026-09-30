Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C6C5221FA;
	Wed, 30 Sep 2026 18:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792753; cv=none; b=U1+/V+YLf87PFQnJ3U/czucGGh3xxcK37jvBuBOx14rKnM91Hfn5R89ks2rmcPxoVd/aHb/NPIfzJbuFDmDcLa9P4Hioy1/UHrTFTTWHvjn0C+vG0gJ7Kn6odg/3Z142lJO++YDowb1YT/bJ2uOioxqmSZmM3w8s+J+kajnuSHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792753; c=relaxed/simple;
	bh=SsatphcLP+FdfzNfek9P0e8mwcyv5VT5yNULt0RSiL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM+B+m9Vgi8lB6A2abZ93cN5G0coCBp49rIWxgz65YDT4gjVFQRgZ2g5Q/6DVuFcdw3nuN8+J5TTUObHfSIMKK6G9ncDKtg3NwrYtjc4GjkpK+gDK9MMp9G67pVCko8Yv8EK7a7ZoK5tMq+6u1cTwiMTaNR2VlNswONQG6AGL8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9xH2NbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9xH2NbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05EE1F000FF;
	Wed, 30 Sep 2026 18:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792752;
	bh=7Ki1MsdoUWSsxfTzq9r7D9m55tZSIGZeSwBqUnWNToc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9xH2NbDpPonJcXsGWoBxUPRpqKjXhrKolAqa3SY8BqRbIQZsQItKYRIrT10t8ipl
	 V0bJ/MOdxML3ungu8HvnH6tA71ROirJf5JYhojQq/4gJYx0d5Z3joTcdDnCNXVwZ1o
	 G5YbyfXzLSTWNcWIDmXl35sXj/jOBWnQnZpUBzZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/395] bpf: Fix out-of-bounds read of sk_protocol in bpf_sock_destroy()
Date: Wed, 30 Sep 2026 17:24:36 +0200
Message-ID: <20260930152340.925819414@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 01b245ba016d44861690594e10f67e026ce8552f ]

sk_protocol lives in struct sock, not in struct sock_common. A timewait
or request sock handed to bpf_sock_destroy() by the tcp iterator is
neither, so reading sk->sk_protocol runs past the object:

==================================================================
BUG: KASAN: slab-out-of-bounds in bpf_sock_destroy+0xc7/0xe0
Read of size 2 at addr ffff8881047d11b4 by task test_progs/428

Tainted: [W]=WARN
Call Trace:
 <TASK>
 dump_stack_lvl+0x91/0xf0
 print_report+0xd1/0x630
 kasan_report+0xf3/0x130
 __asan_report_load2_noabort+0x14/0x30
 bpf_sock_destroy+0xc7/0xe0
 bpf_prog_c3dd61f9d9cd9f37_iter_tcp6_timewait+0x9f/0xb7
 bpf_iter_run_prog+0x538/0xde0
 bpf_iter_tcp_seq_show+0x26b/0x4b0
 bpf_seq_read+0x424/0x1210
 vfs_read+0x197/0xe40
 ksys_read+0x119/0x240
 __x64_sys_read+0x72/0xc0
 x64_sys_call+0x647/0x27e0
 do_syscall_64+0xe5/0x610
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Only check sk_protocol on full socks. tcp_abort() already knows how to
deal with TIME_WAIT and NEW_SYN_RECV socks. Also fix the comment, it
never matched the code.

Fixes: 4ddbcb886268 ("bpf: Add bpf_sock_destroy kfunc")
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Closes: https://lore.kernel.org/bpf/20260702224519.800135-1-xmei5@asu.edu/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://lore.kernel.org/r/20260910112634.152195-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 0b849567afe9f..4f0a052d9aed1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -12497,8 +12497,9 @@ __bpf_kfunc_start_defs();
  * @sock: Pointer to socket to be destroyed
  *
  * Return:
- * On error, may return EPROTONOSUPPORT, EINVAL.
- * EPROTONOSUPPORT if protocol specific destroy handler is not supported.
+ * On error, may return EOPNOTSUPP, or whatever the protocol specific
+ * destroy handler returns.
+ * EOPNOTSUPP if protocol specific destroy handler is not supported.
  * 0 otherwise
  */
 __bpf_kfunc int bpf_sock_destroy(struct sock_common *sock)
@@ -12510,8 +12511,12 @@ __bpf_kfunc int bpf_sock_destroy(struct sock_common *sock)
 	 * Supporting protocols will need to acquire sock lock in the BPF context
 	 * prior to invoking this kfunc.
 	 */
-	if (!sk->sk_prot->diag_destroy || (sk->sk_protocol != IPPROTO_TCP &&
-					   sk->sk_protocol != IPPROTO_UDP))
+	if (!sk->sk_prot->diag_destroy)
+		return -EOPNOTSUPP;
+
+	if (sk_fullsock(sk) &&
+	    sk->sk_protocol != IPPROTO_TCP &&
+	    sk->sk_protocol != IPPROTO_UDP)
 		return -EOPNOTSUPP;
 
 	return sk->sk_prot->diag_destroy(sk, ECONNABORTED);
-- 
2.53.0



