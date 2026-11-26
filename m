Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705163;
	b=usu5KInsMX7N1WJP6p8tNIp6LlVoq9bjOrA0IP2bxbqHbcIpPoAtLg8l/fA6mFZoXAJe
	 lOLKk5e9zIl73pSnPXx3J4IBt1mF2JL+eG12tBbccYBCEK24p1LJY9AV0Fo3N3h+wsqwj
	 PGJKa2hkaoAnFGI5BPs9MIyFiaU7Rd6Io7qa7wk8lwQ2C3mqMN64cBsEqzwDF04YlCT/5
	 YrS4MMuMdfi16hyLDfKqZQu9oTnoPFy90YNplA/BPSYrl/chmMY7vGe6Qh1jVum/7JZAg
	 rgbeFWutiKHeSour/Adjc21uuXBqSolQrGu8ioQxXRel0S4novghy1DOnPXD5PXv5Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=67ypva9povNL25uthcxTIT5E+8O4kG1YfjZqPeIJ85s=;
	b=oVulNA8n2iMiuDpdEUUDuorElbtPpuy5Qole0OWYtLA6NiUs7owKeMn8MN4LJHZ9K67i
	 tqNnenTstY48NjisZuaY9ucCM2jTkbdTNtfeegwr6lB6ikWTWDx1c71AYgSE08aaqw12f
	 hapex9ifPhvJIpDdQT1BbsebQGh19hvWPtg16juZ7IrDdnkwzj48K8uHnTwGfOmOyYezc
	 OvfCZ8WZiBjnec3PgqLEY5zTWf/RgJ8W+JfUm1cJVGNIpMclQ8VKat5IvPZXU9+rEyWeW
	 w06b3EV86UQnon6NALoKwOln2rh6g0IBTnJMfVd0b3Pg7bUlYx1YZQal1B4kv9BQS5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWBOxi7M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C11606A31C;
	Thu, 26 Nov 2026 14:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWBOxi7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F29A1F000C4;
	Thu, 26 Nov 2026 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705163;
	bh=67ypva9povNL25uthcxTIT5E+8O4kG1YfjZqPeIJ85s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWBOxi7MlG1BEQVr6OIecRrpqDRBt5pwFWIwGl4gwzsF0DVcg8mFn/naehxjBmPyu
	 +4rkvZq48RRnSbrLFnoRRLZ4Csp0jWU0lVtkv2zAg+osKRUP4IhP058eWNGCarsiXc
	 EpB2F3+TKdx1YMB2EOwR++XzeIprwsoEnq3EZDNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/319] netfilter: x_tables: check target name before accessing verdict
Date: Thu, 26 Nov 2026 15:37:52 +0100
Message-ID: <20261126144009.092230093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 2c39529769f19..0590ef05458e5 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -371,11 +371,12 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
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
index 15a9e303a1531..a71829a65cf63 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -423,11 +423,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
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
index 6fdd00ac2f84e..1ffd93f124a20 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -442,11 +442,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
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



