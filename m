Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240AD1E5B9A;
	Wed, 30 Sep 2026 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786771; cv=none; b=c/MDbnUY6Yb65aA0dZ2QxT74c9BBAoSi+0YmZXur9TiAu4WMOQJL8yPEdUAAezi3V27gGhMKWXrBSDBWBCQq5pm2jkuSvvgSDIdEwXWtvW5DCTczH88rVKOXM7mwbx1Xzhba51ba3EEei9cqLUwMyJaI7bflMdJZTikyF9Sflt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786771; c=relaxed/simple;
	bh=Mm4kk6iyo4qvmE3x92yuUW526UzhcSeHf+nNEwUzw3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5R4VpE7lytY9lX0F25o/cjwpgjeOF3b/EaJYIjeP3lwp1IIjWrS+u/+ca/SIe626SVGNP6lQqet/4mqi8W59CKRcuM3BaT5BuWFNAIv9HCsMuld18vOHZy6wgeTVSfRh9T4P9T/0xkiovtxq3ML1eH6E+Rxq4h/R1r5d6YbRrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/GQ/eOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/GQ/eOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1681F000FF;
	Wed, 30 Sep 2026 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786770;
	bh=Ae0/zJsC4w7+2fc/l1OqVKihQK1TTcaVs2u9NkHk6o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/GQ/eOMvd8SzR03dey7ghzKRf68X7rhZujuTJyRn7OS1RTNIweAqzOGj1jxlITOR
	 2+6WYPuBcWni4sJ4MBUt9ydnii5i18e6w0AKTpKwzIBBpLhE0loek7Vkr+Huz/NetU
	 jbEhPFjqjksRZ0E+iXpmY3tSMVnsNL6xse4Nyayg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Justin Iurman <justin.iurman@gmail.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 934/982] ipv6: sr: enforce exact attribute length for SEG6_ATTR_DST
Date: Wed, 30 Sep 2026 17:27:50 +0200
Message-ID: <20260930152436.802678043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit 2d959c75c27f90e9ec489d18ce5ee6b852ad4741 upstream.

In seg6_genl_policy, SEG6_ATTR_DST is defined with .type = NLA_BINARY and
.len = sizeof(struct in6_addr). For NLA_BINARY, .len only enforces the
maximum payload length and permits shorter payloads (e.g., 0 bytes).
When seg6_genl_set_tunsrc() copies sizeof(struct in6_addr) bytes via
kmemdup(val, sizeof(*val), GFP_KERNEL), a short SEG6_ATTR_DST attribute
triggers a 16-byte out-of-bounds read past skb->tail into uninitialized
skb->head memory, which is stored in sdata->tun_src and leaked back to
userspace via SEG6_CMD_GET_TUNSRC.

Switch SEG6_ATTR_DST in seg6_genl_policy to
NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)) so that generic netlink
validation rejects any attribute whose length is not exactly
sizeof(struct in6_addr) with -ERANGE.

Tested in QEMU against Linux 7.3.0-rc3 by sending a SEG6_CMD_SET_TUNSRC
Generic Netlink message with a 0-byte SEG6_ATTR_DST attribute followed
by SEG6_CMD_GET_TUNSRC. On the unfixed kernel, SEG6_CMD_SET_TUNSRC
succeeds (err = 0) and SEG6_CMD_GET_TUNSRC leaks 16 bytes of
uninitialized kernel heap memory (tun_src =
836a61ecc4d25a1042a8d60411cfb378); with this patch applied,
SEG6_CMD_SET_TUNSRC is rejected by netlink policy validation with
-ERANGE (-34) and tun_src remains zeroed.

Fixes: 915d7e5e5930 ("ipv6: sr: add code base for control plane support of SR-IPv6")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Peng <benquike@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260921044025.1535982-1-benquike@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -140,8 +140,8 @@ out:
 static struct genl_family seg6_genl_family;
 
 static const struct nla_policy seg6_genl_policy[SEG6_ATTR_MAX + 1] = {
-	[SEG6_ATTR_DST]				= { .type = NLA_BINARY,
-		.len = sizeof(struct in6_addr) },
+	[SEG6_ATTR_DST]				=
+		NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 	[SEG6_ATTR_DSTLEN]			= { .type = NLA_S32, },
 	[SEG6_ATTR_HMACKEYID]		= { .type = NLA_U32, },
 	[SEG6_ATTR_SECRET]			= { .type = NLA_BINARY, },


