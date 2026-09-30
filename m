Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC983E7151;
	Wed, 30 Sep 2026 19:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796580; cv=none; b=ladRzNJ9saKI2+QC2at9oVCe2hGTnw/Rl2GTN0yYX7WzJxmf8+f2prUTaOpZ4XzxZw7ZkSN7EVxKR+XJNjh2pAoVeYGkkwoLqH6pndilW93yaXQI58+rB/bc/eSAw6wa+lhNqgZu/cax874Ah+eXJozVrPdBC7cuvm7sHNGp1bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796580; c=relaxed/simple;
	bh=//11NWrjlI2WTM06x16Gk4khyZWBfIQqilWCrNPur00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZUJCSVPxlSpXBMzIHxBKqhvic0G4WMYhJ/WQhRVZcg3gQDB4x+1uf8lVJsxAoapWURQaV0BgySpvUVpmMDNPyyON7RmWp6tRdH8k1sMjJOf2ICqCJ3syTsbXagz0o1I9zzeAmQwX3/igNAhIwOQokJN+rRuus8/FHwKwqDh33I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZS4ml1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZS4ml1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC681F00898;
	Wed, 30 Sep 2026 19:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796578;
	bh=ytP4k2UixLWwBfpU0/ka9EpNJt+k29F2oh4ooo5ygqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZS4ml1c66MWDwiezRabgFo9HpOn9EgHE0+rE7KLieG+rW4y4nhf1sqSkFaZqjaDz
	 4IniqXEyAAbPdfJIDoOVLOWGX9GzkXR2pci2BB6NBKpG6p1+TmpuuLzAQdi/PkB+Jk
	 K/+jrNsYaTazeBGggwrKK7zU93P+/Mg0z+FiRpD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0964/1193] bpf: Fix out-of-bounds read of sk_protocol in bpf_sock_destroy()
Date: Wed, 30 Sep 2026 17:27:28 +0200
Message-ID: <20260930152455.661890670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f947154603203..9f3608de67a3d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -12071,8 +12071,9 @@ __diag_ignore_all("-Wmissing-prototypes",
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
@@ -12084,8 +12085,12 @@ __bpf_kfunc int bpf_sock_destroy(struct sock_common *sock)
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



