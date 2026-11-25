Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621636;
	b=20rb1woLw5KsY82aQ0KRfrByHx4k3tP1IcSxc37or5yiyS38FmvBkC/YMGmUx4S+BRJZ
	 YvmPqO+08I7tZRqh08sP3JOBBQ3B6cuLQMwVKJtZWWqS9rPp2L7sbrp1q9/MpdbIpV4TX
	 QziitGfklQtELflh5oHIi7PJ50y9IvOHbND1CePBToag4qNp1u/HmySHDuvcNrnYkMlHx
	 u3ldVJM3Z55gse151HHSXWRhMC015/kJcxW4vDES2xp+1hKkcUfI+pZDaWUYlJDw0abrc
	 QZ3wNoypP3DvGBn/2e+Fnv4Ppy8wIjvApQVZMebBK0z4lN2dAGWLup3bwygz3Dfrfxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7OmR4w4yzbhEweCfiXryx4l19FALzc5TgqwJy9hXiWQ=;
	b=KAeLdVik4nmOoRnLM6hHKHLojnTKc+iTVvhtp7RMhjPGEzCFtoUPjrrxd7DKu9SvEbgZ
	 MvS8mI3+1+PKweFnwVt8YdtZujnMJlUdTuFxkkMQxEiHsv2avuOPzMAegs/OWy+hQDiFP
	 pyMMQlGvJxLYA6JjjG97KqKaO+0yye59kGQTKdzB+N7AzhNn0EmFlN1hBlVxEyh/5nsLI
	 Jki2P37nM+ipCPpntB+S2y4TBvrPocS9Hytaxs6PNLH3saR2RVtYlpWIHdMhoFRvZwvFh
	 Xkzu50u+LkF2QvboLDxpYPiczdsQtmYinm1pLSyeNh3KuZIIsvMvrP7MnSx6h7Todig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kO+l8gET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B61606A32D;
	Wed, 25 Nov 2026 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kO+l8gET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43BC1F000C6;
	Wed, 25 Nov 2026 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621635;
	bh=7OmR4w4yzbhEweCfiXryx4l19FALzc5TgqwJy9hXiWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kO+l8gET0QPV40hRAV6hCvs3+4kqFwt89eg2tA5jKQTmMGU8FDHOHQD5FFAZx/gFm
	 vKP2Z8CYSopTT4DBT+HsWCQC4jccCfF8N780NqbFE1NCjnN0QyTJ6tQXdYvJB3Bfcc
	 lRbkaY+b/qBuBAq7cgpnMXamszcQKiTk87xtblIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 287/990] netfilter: x_tables: check target name before accessing verdict
Date: Wed, 25 Nov 2026 15:27:34 +0100
Message-ID: <20261125143828.810994368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 364b200285bb2cc518e3c5efe6591951c05b8e01 ]

Non-standard targets may contain only struct xt_entry_target.
mark_source_chains() nevertheless reads the target as an
xt_standard_target before checking its name, potentially reading four
bytes beyond a header-only target.

Check that the target is standard before reading its verdict.
Non-standard targets remain handled as fallthrough rules.

See the following KASAN trace:

BUG: KASAN: slab-out-of-bounds in translate_table+0x1660/0x1a40 [ip6_tables]
Read of size 4 at addr ffff88800ed56ff8 by task rep/432

Call Trace:
 kasan_report+0xfa/0x120
 translate_table+0x1660/0x1a40 [ip6_tables]
 do_ip6t_set_ctl+0x667/0xa76 [ip6_tables]
 nf_setsockopt+0x77/0xd0
 do_sock_setsockopt+0x118/0x490
 __sys_setsockopt+0xe4/0x160
 __x64_sys_setsockopt+0xbd/0x190
 do_syscall_64+0xde/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Allocated by task 432:
 kasan_save_stack+0x2f/0x50
 __kasan_kmalloc+0x7f/0x90
 __kvmalloc_node_noprof+0x1b1/0x5c0
 xt_alloc_table_info+0x3c/0xa0
 do_ip6t_set_ctl+0x5ee/0xa76 [ip6_tables]
 nf_setsockopt+0x77/0xd0
 do_sock_setsockopt+0x118/0x490
 __sys_setsockopt+0xe4/0x160
 __x64_sys_setsockopt+0xbd/0x190
 do_syscall_64+0xde/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arp_tables.c | 5 +++--
 net/ipv4/netfilter/ip_tables.c  | 5 +++--
 net/ipv6/netfilter/ip6_tables.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 0ea513bf77fb6..197d1dfa07d61 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -372,11 +372,12 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index ca8ff0ae6cdb9..b7749048e1461 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -422,11 +422,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 22db263682bda..9353e9105f4ac 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -440,11 +440,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
-- 
2.53.0



