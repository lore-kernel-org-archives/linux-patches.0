Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E58F224AEB;
	Tue,  8 Apr 2025 11:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112351; cv=none; b=WGpjQzYATH66YYM7XDXrJN/oaw5S9b5cwnNgWP2gNeiwCa1T02qJaVSIHS7Fn4zAlZP51QCWMM+9WXuE2MwU73gzpYoZRmyU1uDbN2G2ZzuKMw4IQsz/NZoFIXVVaLsMyarFQ32M4zR8ZY4KeUNCszBzZz6asl61L4aeVLJcCU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112351; c=relaxed/simple;
	bh=IQqnnMYeh3H9jUCLS7IDJyqOY5FUrsCHKuuG1gGKQ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xhg5bX3Xmw6kHCoP6UWe2vkrMPeABIErTPkiG/ooAGt3s0Xtt++yGW0+cDDDtyLhorNrMk0G6CgGCkpLL3EEINmsnPhyh20GcxXHcwyF329cHw4pNgFWUQc2Jd4dUjUr/EQMFHTaknndpIcOHNmRfRAAoo2HhpIVw5JJsBDNMCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGoetMpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGoetMpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1E8C4CEE5;
	Tue,  8 Apr 2025 11:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112351;
	bh=IQqnnMYeh3H9jUCLS7IDJyqOY5FUrsCHKuuG1gGKQ5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGoetMpdiMpfrf0Pm8ssmWsVajFPMoUT3DoEfQstA9Z18ecZN1YpugCuJY8F46pOH
	 5AEDYnJqDDSoEBMFMCUC7c+XOqfCiLkxA3BpDMziYMUPa+rbz2H2a42s21QNYp0UNs
	 Qz9xClrk8s7J5LuDYXayXl3YdzEzoTO4jSpoAuqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Wang Yufen <wangyufen@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Abdelkareem Abdelsaamad <kareemem@amazon.com>
Subject: [PATCH 5.15 004/279] ipv6: Fix signed integer overflow in __ip6_append_data
Date: Tue,  8 Apr 2025 12:46:27 +0200
Message-ID: <20250408104826.465504160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wang Yufen <wangyufen@huawei.com>

commit f93431c86b631bbca5614c66f966bf3ddb3c2803 upstream.

Resurrect ubsan overflow checks and ubsan report this warning,
fix it by change the variable [length] type to size_t.

UBSAN: signed-integer-overflow in net/ipv6/ip6_output.c:1489:19
2147479552 + 8567 cannot be represented in type 'int'
CPU: 0 PID: 253 Comm: err Not tainted 5.16.0+ #1
Hardware name: linux,dummy-virt (DT)
Call trace:
  dump_backtrace+0x214/0x230
  show_stack+0x30/0x78
  dump_stack_lvl+0xf8/0x118
  dump_stack+0x18/0x30
  ubsan_epilogue+0x18/0x60
  handle_overflow+0xd0/0xf0
  __ubsan_handle_add_overflow+0x34/0x44
  __ip6_append_data.isra.48+0x1598/0x1688
  ip6_append_data+0x128/0x260
  udpv6_sendmsg+0x680/0xdd0
  inet6_sendmsg+0x54/0x90
  sock_sendmsg+0x70/0x88
  ____sys_sendmsg+0xe8/0x368
  ___sys_sendmsg+0x98/0xe0
  __sys_sendmmsg+0xf4/0x3b8
  __arm64_sys_sendmmsg+0x34/0x48
  invoke_syscall+0x64/0x160
  el0_svc_common.constprop.4+0x124/0x300
  do_el0_svc+0x44/0xc8
  el0_svc+0x3c/0x1e8
  el0t_64_sync_handler+0x88/0xb0
  el0t_64_sync+0x16c/0x170

Changes since v1:
-Change the variable [length] type to unsigned, as Eric Dumazet suggested.
Changes since v2:
-Don't change exthdrlen type in ip6_make_skb, as Paolo Abeni suggested.
Changes since v3:
-Don't change ulen type in udpv6_sendmsg and l2tp_ip6_sendmsg, as
Jakub Kicinski suggested.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/20220607120028.845916-1-wangyufen@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Conflict due to f37a4cc6bb0b ("udp6: pass flow in ip6_make_skb
  together with cork") not in the tree ]
Signed-off-by: Abdelkareem Abdelsaamad <kareemem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h    |    4 ++--
 net/ipv6/ip6_output.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1000,7 +1000,7 @@ int ip6_find_1stfragopt(struct sk_buff *
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
-		    void *from, int length, int transhdrlen,
+		    void *from, size_t length, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 		    struct rt6_info *rt, unsigned int flags);
 
@@ -1016,7 +1016,7 @@ struct sk_buff *__ip6_make_skb(struct so
 struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 			     struct rt6_info *rt, unsigned int flags,
 			     struct inet_cork_full *cork);
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1461,7 +1461,7 @@ static int __ip6_append_data(struct sock
 			     struct page_frag *pfrag,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
@@ -1806,7 +1806,7 @@ error:
 int ip6_append_data(struct sock *sk,
 		    int getfrag(void *from, char *to, int offset, int len,
 				int odd, struct sk_buff *skb),
-		    void *from, int length, int transhdrlen,
+		    void *from, size_t length, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 		    struct rt6_info *rt, unsigned int flags)
 {
@@ -2000,7 +2000,7 @@ EXPORT_SYMBOL_GPL(ip6_flush_pending_fram
 struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
-			     void *from, int length, int transhdrlen,
+			     void *from, size_t length, int transhdrlen,
 			     struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
 			     struct rt6_info *rt, unsigned int flags,
 			     struct inet_cork_full *cork)


