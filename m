Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210386;
	b=SeFGH0a2OzCkR13WCsBppJoL7FaIL/CO8S6PNQutPWxBHmrpZcDi1ccz7qcB0DIasprZ
	 eZRgWZexYz1zGcfQqkmi/ZqOgz2prVIfNzmhpXawYAmLr7ORFA34jDnKdYFiH4o3BvCmd
	 xZSjMi2OZn6MweGQH6iJ76NM8QWCSRlRp6dFWyFZ/G3yyMowXJ8BOCPA76Z71AfnZ0mFx
	 6iXQCQzAa958d1hEfQayyMVkjKbZgt6dsDZn8bZ1jMrJXr5wKCBiEp7G5YiuDJeNwvJ8v
	 4MNpN9RhgLzEgxxpi3HFyCLKuN8sG+k5hMWGHzVKKUMVAgsgXyrZW1UneE8GkXzs/HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i26LHE3vzFT30j44KhkNLmxbnd8hMuzQ9rsL6jgVjjk=;
	b=JxcepFmgHkloetYiy7utvITxM7dSLpKpw76tWKNYLjMxOOZk/qnaRicHxfCb6zmrlxh7
	 0g6/hRpyCmv853j4ifujvyMefYHylLjC95JegEujWoxBTgPh5/cKKDZf+psUe1P8wuCqy
	 OjaR7oUfk71WMXiAke6RfI7hL6bSp6f5SqmIYf7rtKr5dNC4mRcimRDUlTDprYCF+gGzp
	 OgcrTTcOwVfHupVaHFzjH1TdnqmzRIx1oPR30SfZuztnCluAGKkK+v4xLIWoCbyQlBDQ8
	 TdojYeGRfTktZ/2fhyPfRDfcOjVmEqrlkwbgloUsMN/O+D1vpZheADheGFV5ijwikfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CZM/XgX+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA81606A31A;
	Wed, 28 Oct 2026 17:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZM/XgX+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5501F01825;
	Wed, 28 Oct 2026 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210386;
	bh=i26LHE3vzFT30j44KhkNLmxbnd8hMuzQ9rsL6jgVjjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZM/XgX+J6kEOl452FMqNUBXY2am3kpa4yJAR89YoTv6VigVEWMsIXkqq+BSq1g65
	 dYhPjoHbgH5oWeGn8Rx42fPjtOGiNB73oj/IOVIz9UTVgR8flwOQzICVpHVNFFFIlk
	 rYzgjSyFf+96//RsMoyFzTZDskkLdWrfjoOyWtsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/571] tls: device: fix out-of-bounds write in tls_append_frag()
Date: Wed, 28 Oct 2026 17:52:28 +0100
Message-ID: <20261028170008.049298839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit b17cf742eaad70ae29ac558cefb3aa9bbeea03d4 ]

Found with syzkaller and a local syzbot instance running on top of a
netdevsim TLS offload emulation; tls_device.c is otherwise only reachable
on a machine with a NIC that implements the offload.

tls_push_data() only checks whether the open record still has room for
another frag at the bottom of its loop, and the MSG_MORE early break
skips that check.  The record survives to the next syscall with the frag
count it already had, and tls_append_frag() does not check either, so
with TLS_TX_ZEROCOPY_RO every splice(SPLICE_F_MORE) of a byte or two adds
a non-coalescing pipe page and num_frags walks off the end of
tls_record_info.frags[MAX_SKB_FRAGS].  Once the record is pushed,
tls_push_record() runs the same index over sg_tx_data[MAX_SKB_FRAGS] and
the sg_set_page() writes land on the destruct_work that follows it, which
the workqueue then calls.

The byte limit is fine because copy drops to 0 and the loop falls through
to the same check; the frag count has no such feedback.

Push the record rather than keep a full one open, which is what a plain
TCP socket does - tcp_sendmsg_locked() uses tcp_mark_push() and
new_segment in both the copy and the MSG_SPLICE_PAGES paths, and tls_sw
already sets full_record when the sk_msg ring fills up, MSG_MORE or not.

  BUG: KASAN: slab-out-of-bounds in tls_append_frag ( net/tls/tls_device.c:269)
  Write of size 8 at addr ffff8881104d1530 by task tls_oob/450

  CPU: 2 UID: 0 PID: 450 Comm: tls_oob Not tainted 7.2.0-rc7+ #329 PREEMPT
  Call Trace:
   <TASK>
   dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
   print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
   kasan_report (mm/kasan/report.c:595)
   tls_append_frag (net/tls/tls_device.c:269)
   tls_push_data (net/tls/tls_device.c:518)
   tls_device_sendmsg (net/tls/tls_device.c:583)
   inet_sendmsg (net/ipv4/af_inet.c:865)
   sock_sendmsg (net/socket.c:775 net/socket.c:790 net/socket.c:813)
   splice_to_socket (fs/splice.c:884)
   do_splice (fs/splice.c:936 fs/splice.c:1349)
   __do_splice (fs/splice.c:1431)
   __x64_sys_splice (fs/splice.c:1634 fs/splice.c:1616)
   do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
   </TASK>

and, once the record is pushed:

  UBSAN: array-index-out-of-bounds in net/tls/tls_device.c:300:24
  index 18 is out of range for type 'skb_frag_t [17]'
  UBSAN: array-index-out-of-bounds in net/tls/tls_device.c:301:41
  index 18 is out of range for type 'scatterlist [17]'
  UBSAN: array-index-out-of-bounds in net/tls/tls_device.c:302:39
  index 18 is out of range for type 'scatterlist [17]'
  UBSAN: array-index-out-of-bounds in net/tls/tls_device.c:307:38
  index 26 is out of range for type 'scatterlist [17]'

  kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
  BUG: unable to handle page fault for address: ffffea000411a680
  #PF: supervisor instruction fetch in kernel mode
  #PF: error_code(0x0011) - permissions violation
  Oops: Oops: 0011 [#1] SMP KASAN PTI
  Workqueue: ktls_device_destruct 0xffffea000411a680
  RIP: 0010:0xffffea000411a680
  Call Trace:
   <TASK>
   worker_thread (kernel/workqueue.c:3405 kernel/workqueue.c:3486)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
   </TASK>

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260823084758.20936-1-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 10f7b35673bc6..2060380265a75 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -493,7 +493,8 @@ static int tls_push_data(struct sock *sk,
 		if (!size) {
 last_record:
 			tls_push_record_flags = flags;
-			if (flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE)) {
+			if ((flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE)) &&
+			    record->num_frags < MAX_SKB_FRAGS - 1) {
 				more = true;
 				break;
 			}
-- 
2.53.0



