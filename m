Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DB4477E4E;
	Mon, 31 Aug 2026 13:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184426; cv=none; b=rZleCs9ecCHTKwhsC4J8/VdRj/m6pH9+CKOiBgDaTmf6YIfTU4hMqe6iJZWtRmbBVY6pWyST8eMs8nYEyAvXXW++GUBDOda26XwUSUqOm4d/U1srinWZ2XowLjmBMjvg+tmf2uicrhZH1NOhZ7h2Q56q5TteHhBqRH4kBaxxyYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184426; c=relaxed/simple;
	bh=IGS7uZ6iEsDOzXj8TSMkTSZ5nPQHQ1PBc2yTgFwlMhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q31MoaJx20ZU/4Z4FeLU+QZ6ALdpNPv3v97dn7Depl+RSflB5jeP5esZf4hiVVhedKMh5QU6fomOd0Qh0c3Dz6aFuNOjsnOLgibrVmWah+Ayz+Q1fyjZl9rZVft2WFR8XrE1JuV184CR1ubgYQj6HRU6l8QAKV1RVf2pIoCqC8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izByj7ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izByj7ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0C11F000E9;
	Mon, 31 Aug 2026 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184425;
	bh=JazVM+oJ4x2x32PZUPx/bQCqyui6eHM3bRckgGB8B2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izByj7ldXYXbyWAM50qFNSak/3pcmJeoV0F02Xw/whxn2eZ+fxaeI30mMYNBAQI3P
	 fsTI1Clh7K7zWkkb/wPT5NSuGja/pPK5jYtknTTMb5I5ZQZjkrIuby5qddbkyDuaJa
	 x9kVSx5ViSzp7hzeERg/1dEMS2CB+t/+GE0esQ7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 65/99] tls: device: fix out-of-bounds write in tls_append_frag()
Date: Mon, 31 Aug 2026 15:34:34 +0200
Message-ID: <20260831133403.233325985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

commit b17cf742eaad70ae29ac558cefb3aa9bbeea03d4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -530,7 +530,8 @@ handle_error:
 		if (!size) {
 last_record:
 			tls_push_record_flags = flags;
-			if (flags & MSG_MORE) {
+			if ((flags & MSG_MORE) &&
+			    record->num_frags < MAX_SKB_FRAGS - 1) {
 				more = true;
 				break;
 			}


