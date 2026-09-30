Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09C7522EEB;
	Wed, 30 Sep 2026 18:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792623; cv=none; b=R8jnIlw613bCw2BrvBAqmQLja+deMNq2X32vh4UY3ph8nv61pA/lrFkOQHgsWao4OxqilmjMydP2grNXZwzAkl8lU+6Oh4wa1PinJPapOgXF6wM+LIqOoQjAhc3AT3fIULPnDh9bSUT2vl4oWq04tA/LEMaglUMNgWdR1UT9zJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792623; c=relaxed/simple;
	bh=hPBCuwBy6iaIVUtery8zFixHAJGx06de5SxV0aIOPB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B10gJkJu6QhHrtPUJTTQuFtFAPfo4NI8cx81FlBcTHxA+H0F1Rpym0vptch+s+UM+GDOt/TumnDtPMfk5GJB51wgnHoO1u8ZqrFpZCxRq0bVMGv6Ih1JA7phE6CKFIi9901qYAXWiiyr8xplMtSK1anKe0zUvRJB7zANV9dNLvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXzJXVYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXzJXVYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B68C1F000FF;
	Wed, 30 Sep 2026 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792621;
	bh=AQQ+yihgfRH0k0Vgvc6zRdzzzmoZwXeCH/5pS/jQxz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXzJXVYiQ58/NEhXGIrlhjIy4W6Yip8/eRS2MblOPK0n2ANP4hgk7bqaW/tEZiA8a
	 BoZ02mh/tUTDSz3t1DxZqeMr6JWhzQxnltnyE/2tPXkNG/UzOHSZTwta+RyFoF/gKH
	 mjLw/eN+Ni9ytGFZehSc0uiHCdCYttIsJxNc0Khw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Justin Iurman <justin.iurman@gmail.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 703/752] ipv6: sr: enforce exact attribute length for SEG6_ATTR_DST
Date: Wed, 30 Sep 2026 17:29:33 +0200
Message-ID: <20260930152413.445556802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


