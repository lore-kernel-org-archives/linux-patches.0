Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A208414B965;
	Tue, 25 Jun 2024 09:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309218; cv=none; b=CoCNSps6TW7ZVWPfqCA0lQjLvRoNP2t3RahsghrsXoQSCdiUmQIVbgtaunPKL26pBcp4YJDNlNzQfwq1ZwB7OLysgD9nrzs0gUgtue/xs6+UtD6VL1BjtG6Xyv/E32tN/PUIVHHWbYEyTRt3POvpVOa4gUv66qLEl8R0gm4ljWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309218; c=relaxed/simple;
	bh=STtNRo6dGfRZ0gJEs01oZpGlWXWwVFn5IL3nQLJT9RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVLdE7wqXZA5LgQdEXkJUHWSWBSKW25TEHIIjPQm8ZeBXfv+Xs8y3y0GnAvQvEbW3jyb7L9D/tvVyzY2JQQeIf3Fhr8usEYfE6wKhj7ONzxuuOPY0iXCAnatLe+BGvwsstpi2VIFxanzHOo5MBngIpvwaTUpBflmTsJZWONFhUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrw8EG/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrw8EG/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DF6C32786;
	Tue, 25 Jun 2024 09:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309218;
	bh=STtNRo6dGfRZ0gJEs01oZpGlWXWwVFn5IL3nQLJT9RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrw8EG/jWSSACKX2a5wzwpNhFCcPysbZr/B/JdA6EYxTAa1ZgIzCDCvjl3XWgicIw
	 IHRGuCLTFJ8lmXqg08MLZEfS90ITyAkRZPJJPX95ikFKfA+UJ24ZmJ40uUapCvRAy9
	 4U0YqN2ZkbEjr3NshDvLO04wuk9fT9DpJVlQ7URQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 135/192] net: do not leave a dangling sk pointer, when socket creation fails
Date: Tue, 25 Jun 2024 11:33:27 +0200
Message-ID: <20240625085542.341929798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ignat Korchagin <ignat@cloudflare.com>

commit 6cd4a78d962bebbaf8beb7d2ead3f34120e3f7b2 upstream.

It is possible to trigger a use-after-free by:
  * attaching an fentry probe to __sock_release() and the probe calling the
    bpf_get_socket_cookie() helper
  * running traceroute -I 1.1.1.1 on a freshly booted VM

A KASAN enabled kernel will log something like below (decoded and stripped):
==================================================================
BUG: KASAN: slab-use-after-free in __sock_gen_cookie (./arch/x86/include/asm/atomic64_64.h:15 ./include/linux/atomic/atomic-arch-fallback.h:2583 ./include/linux/atomic/atomic-instrumented.h:1611 net/core/sock_diag.c:29)
Read of size 8 at addr ffff888007110dd8 by task traceroute/299

CPU: 2 PID: 299 Comm: traceroute Tainted: G            E      6.10.0-rc2+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
dump_stack_lvl (lib/dump_stack.c:117 (discriminator 1))
print_report (mm/kasan/report.c:378 mm/kasan/report.c:488)
? __sock_gen_cookie (./arch/x86/include/asm/atomic64_64.h:15 ./include/linux/atomic/atomic-arch-fallback.h:2583 ./include/linux/atomic/atomic-instrumented.h:1611 net/core/sock_diag.c:29)
kasan_report (mm/kasan/report.c:603)
? __sock_gen_cookie (./arch/x86/include/asm/atomic64_64.h:15 ./include/linux/atomic/atomic-arch-fallback.h:2583 ./include/linux/atomic/atomic-instrumented.h:1611 net/core/sock_diag.c:29)
kasan_check_range (mm/kasan/generic.c:183 mm/kasan/generic.c:189)
__sock_gen_cookie (./arch/x86/include/asm/atomic64_64.h:15 ./include/linux/atomic/atomic-arch-fallback.h:2583 ./include/linux/atomic/atomic-instrumented.h:1611 net/core/sock_diag.c:29)
bpf_get_socket_ptr_cookie (./arch/x86/include/asm/preempt.h:94 ./include/linux/sock_diag.h:42 net/core/filter.c:5094 net/core/filter.c:5092)
bpf_prog_875642cf11f1d139___sock_release+0x6e/0x8e
bpf_trampoline_6442506592+0x47/0xaf
__sock_release (net/socket.c:652)
__sock_create (net/socket.c:1601)
...
Allocated by task 299 on cpu 2 at 78.328492s:
kasan_save_stack (mm/kasan/common.c:48)
kasan_save_track (mm/kasan/common.c:68)
__kasan_slab_alloc (mm/kasan/common.c:312 mm/kasan/common.c:338)
kmem_cache_alloc_noprof (mm/slub.c:3941 mm/slub.c:4000 mm/slub.c:4007)
sk_prot_alloc (net/core/sock.c:2075)
sk_alloc (net/core/sock.c:2134)
inet_create (net/ipv4/af_inet.c:327 net/ipv4/af_inet.c:252)
__sock_create (net/socket.c:1572)
__sys_socket (net/socket.c:1660 net/socket.c:1644 net/socket.c:1706)
__x64_sys_socket (net/socket.c:1718)
do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Freed by task 299 on cpu 2 at 78.328502s:
kasan_save_stack (mm/kasan/common.c:48)
kasan_save_track (mm/kasan/common.c:68)
kasan_save_free_info (mm/kasan/generic.c:582)
poison_slab_object (mm/kasan/common.c:242)
__kasan_slab_free (mm/kasan/common.c:256)
kmem_cache_free (mm/slub.c:4437 mm/slub.c:4511)
__sk_destruct (net/core/sock.c:2117 net/core/sock.c:2208)
inet_create (net/ipv4/af_inet.c:397 net/ipv4/af_inet.c:252)
__sock_create (net/socket.c:1572)
__sys_socket (net/socket.c:1660 net/socket.c:1644 net/socket.c:1706)
__x64_sys_socket (net/socket.c:1718)
do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Fix this by clearing the struct socket reference in sk_common_release() to cover
all protocol families create functions, which may already attached the
reference to the sk object with sock_init_data().

Fixes: c5dbb89fc2ac ("bpf: Expose bpf_get_socket_cookie to tracing programs")
Suggested-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20240613194047.36478-1-kuniyu@amazon.com/T/
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240617210205.67311-1-ignat@cloudflare.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3725,6 +3725,9 @@ void sk_common_release(struct sock *sk)
 
 	sk->sk_prot->unhash(sk);
 
+	if (sk->sk_socket)
+		sk->sk_socket->sk = NULL;
+
 	/*
 	 * In this point socket cannot receive new packets, but it is possible
 	 * that some packets are in flight because some CPU runs receiver and


