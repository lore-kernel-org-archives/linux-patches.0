Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061517;
	b=WfaljbIT2PoLJHkJMovuqjP30hTEmcOu+MJwQVMmsSRmOkxa5QZa/NcvCVozOVdFP+s7
	 HY398iuXBEOzxsHU09zRNlRnbVGSDFjGcm5dIpX07HFl1WUP6fkh2Lfb2eADN70bkECw9
	 dTiMPp0Ep0S0bPwQtb+7BPp/wcbpucubyfZV+sF1fM/SV7D9dqD9QQTTLKgDZ1/3uZ7wE
	 WNXHrTef+ShOh+iA81B5P1JnsP0hTaTIkpkJ3p5FkxsozoHqQP7R2lGA9F6asz1wnvm7P
	 1/VwugYy75E0kpoa1Al3/rc+VGsKBigTE6OIcxPsRvdPMv5V5j7PT1VU9X2jrGb1IBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QrPNhxG2TztbYM/WgqGNBhJjMZI/HqVLxK1h2+z9E4Y=;
	b=awxu4VJ3MDqROFaJSTeDkhjNge+V8W9ReY/asQ9rFaWGpNy0dZLT5KBwmu70qo+9HBK9
	 A77N9ryEyU9nrFR0pjjPTntjrNU27Z6zzH/hzP8M0DYifR8jfJgyls67g3QwONK0XKSVP
	 UY8Il7myVER2Me8XpBKNq7ybw9HjHMIJ1Q0sl8O6Igjv3nn2fPiigLj7DYcuIwL1ePqal
	 RdDGJABfa62f/dbA9lOaBtUReDv1RhHNgqpoSIZ8qW108kh8PUJayhMf3pECEIUrPYANx
	 1tE675RqGAIvngfhlXon+bK6kFe7F3/cTnblirB69gPzFhi0vJi+LfMYR4llG76kZ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hixFXY66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA05606A336;
	Sat,  7 Nov 2026 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hixFXY66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193ED1F0089F;
	Sat,  7 Nov 2026 14:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061512;
	bh=QrPNhxG2TztbYM/WgqGNBhJjMZI/HqVLxK1h2+z9E4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hixFXY66Q0ATkXLizwTyin3lFu1Z+87ElTQK4iDXQERNRX7qYRKx8mCEBFWJ51yzv
	 nyreAdSRbBnMuQJNv9fmG6wiflRhLun6vsardDmiOSjRnSveBdTnX2T227M4Lot/v2
	 h/BLOrIy0u6Yz4opBTcFrc81w7+zcTcazfXkW2nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijing Yin <yzjaurora@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0603/1536] SUNRPC: fix netns use-after-free in write_gssp()
Date: Sat,  7 Nov 2026 08:43:39 -0500
Message-ID: <20261107135014.478222027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijing Yin <yzjaurora@gmail.com>

commit e7a8721b7edb54a157623f9e31d71345333b5fb9 upstream.

While fuzzing with a customized syzkaller, I hit a refcount warning in
xprt_alloc(), reached from a write to /proc/net/rpc/use-gss-proxy:

  refcount_t: addition on 0; use-after-free.
  WARNING: lib/refcount.c:25 at refcount_warn_saturate+0xf8/0x120
  CPU: 0 PID: 10404 Comm: syz.0.17 Not tainted 7.3.0-rc1-00096-gcfebfd3db73d
  Call Trace:
   <TASK>
   xprt_alloc+0x83f/0x9d0
   xs_setup_xprt+0xaf/0x3c0
   xs_setup_local+0x47/0x7f0
   xprt_create_transport+0x16c/0x730
   rpc_create+0x38e/0x7f0
   gssp_rpc_create+0xe2/0x180
   set_gssp_clnt+0xba/0x1b0
   write_gssp+0x200/0x310
   proc_reg_write+0x240/0x330
   vfs_write+0x2aa/0x1050
   ksys_write+0x12a/0x250
   do_syscall_64+0x117/0x750
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

create_use_gss_proxy_proc_entry() stores the struct net pointer as the
proc entry's private data without taking a reference on it, and an open
file descriptor does not pin the namespace either, as procfs only pins
the proc_dir_entry. write_gssp() reads that pointer back with
pde_data() and hands it to set_gssp_clnt(), which reaches xprt_init():

	xprt->xprt_net = get_net_track(net, &xprt->ns_tracker, GFP_KERNEL);

get_net_track() -> get_net() -> refcount_inc() is unconditional, so
rpc_create() assumes its caller holds a reference on args.net.
write_gssp() does not.

Dropping the last ns.count reference does not make the file go away.
__put_net() only queues cleanup_net() on a workqueue, and the
remove_proc_entry() that fences off further writes runs from the
rpcsec_gss pernet .exit method, that is, from inside cleanup_net(). A
write landing between those two points increments a refcount that is
already zero. cleanup_net() does not re-read ns.count, so the namespace
is freed anyway and the rpc_xprt -- along with the AF_LOCAL socket
opened for it -- is left pointing at freed memory. The resurrected
count is visible to the rest of that teardown too: with
CONFIG_IPV6_MROUTE the same cleanup_net() worker then trips
!mr_can_free_table() in ip6mr_free_table(), which tests check_net() on
the namespace it is freeing.

It reduces to opening /proc/net/rpc/use-gss-proxy inside a new network
namespace, calling setns() back to the original one to drop the last
reference, and then writing "1" to the still-open descriptor.

Take the reference in write_gssp() itself and refuse the write when the
namespace is already gone. This is what procfs does for every other
/proc/net file: get_proc_net() is maybe_get_net(PDE_NET(PDE(inode)))
and seq_open_net() returns -ENXIO when it fails. PDE_NET() cannot be
reused here because the parent directory /proc/net/rpc carries no
namespace pointer. Adding a .pre_exit to rpcsec_gss_net_ops so the
entry is removed earlier would only narrow the window, since pre_exit
also runs from cleanup_net().

Live namespaces are unaffected: a write still returns the error from
set_gssp_clnt(), a write of "2" still returns -EINVAL, and reads are
untouched.

Fixes: 030d794bf498 ("SUNRPC: Use gssproxy upcall for server RPCGSS authentication.")
Cc: stable@vger.kernel.org
Signed-off-by: Zijing Yin <yzjaurora@gmail.com>
Link: https://patch.msgid.link/20260907085435.644076-1-yzjaurora@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1420,10 +1420,18 @@ static ssize_t write_gssp(struct file *f
 		return res;
 	if (i != 1)
 		return -EINVAL;
+
+	/*
+	 * Neither the proc entry nor an open descriptor pins @net, so it
+	 * might already be dying when rpc_create() takes its reference.
+	 */
+	if (!maybe_get_net(net))
+		return -ENXIO;
+
 	res = set_gssp_clnt(net);
-	if (res)
-		return res;
-	res = set_gss_proxy(net, 1);
+	if (!res)
+		res = set_gss_proxy(net, 1);
+	put_net(net);
 	if (res)
 		return res;
 	return count;


