Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECFA347BC6;
	Tue, 21 Jul 2026 22:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674457; cv=none; b=S77fGvgyAdYK1/Q8z4mkhyacS0Xu8VvZb3i9TI8txkRhH2fejOu3xR46hroqNDiJic2+X1LtjuTK44icsFWE51vd7NRKJWz0U4/3wK6+1vHGlDPeO9DWC7lUnRXrFVjoY2xBkwn4fIffXdQloYontk0u18aPnD8kckx9aS6CydU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674457; c=relaxed/simple;
	bh=kf4mocPzJMNZsIH1UaMqtZDYS1aPCiYG2504FYZnkHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is4gUZe9cjcFqMYLtGz7cWV4zKrF6Cq4bCSo83U+S700OQR7E+Z4BA7kxJ36xOgcy6eq6Ns6pBB6XhoVzA+AtY2Mm8ckhk3xXJmVMSDvhv8a80EhOBJyZauTpqZTRsetKwqLvQP/l0GGH2TkCwf6EQd64HyXD17BIIxeOWyx8rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Zbzbto0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Zbzbto0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B891F000E9;
	Tue, 21 Jul 2026 22:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674455;
	bh=MPYESJYH3tlpLa3+QZJc0SdTxGRmttB83843eclPJvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Zbzbto0LWQ6nBhAVSwl9XjwtPAVUTF95JdoPU4ZZfy8rcpP3SAmhESI0hAoMSSmg
	 ifXzOrRbHLynKJFbJZh3ZJSq0LW8swbFVjVV3okBzZKS5ptr7uqQEAkPrHvoCMO6Ut
	 8+zyW2XieStjR0IqKzsGsU1zZhHs9gLc4o9ZgQCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.10 495/699] xfrm: use compat translator only for u64 alignment mismatch
Date: Tue, 21 Jul 2026 17:24:14 +0200
Message-ID: <20260721152406.861568138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit 355fbcbdc2539cca7890b0d0914d4ce0f985ad74 upstream.

The XFRM compat layer (CONFIG_XFRM_USER_COMPAT) translates 32-bit xfrm
netlink and setsockopt messages into the native 64-bit layout. It is
only needed on architectures where the 32-bit and 64-bit ABIs disagree
on u64 alignment, which the kernel encodes as COMPAT_FOR_U64_ALIGNMENT.

That symbol is defined only by arch/x86. XFRM_USER_COMPAT depends on it,
so the translator can never be built on any other architecture,
including arm64, which still provides a 32-bit compat ABI (CONFIG_COMPAT)
for AArch32 EL0 userspace. On arm64 the AArch32 EABI already aligns u64
to 8 bytes, identical to the AArch64 ABI, so no translation is required
and the native code path is correct for 32-bit tasks.

However, xfrm_user_rcv_msg() and xfrm_user_policy() gate on
in_compat_syscall() alone and then call xfrm_get_translator(), which
returns NULL when no translator is registered. On arm64 that is always
the case, so every xfrm netlink message and the XFRM_POLICY setsockopt
issued by a 32-bit task returns -EOPNOTSUPP. A 32-bit userspace process
on arm64 (and on any other arch with CONFIG_COMPAT but without
COMPAT_FOR_U64_ALIGNMENT) therefore cannot configure XFRM state or
policy through the XFRM_USER netlink API, and cannot use the XFRM_POLICY
setsockopt path, because both fail before reaching the native parser.

The translator series replaced the blanket compat rejection with a
translator lookup. That made the path usable on x86 when the translator
is available, but left architectures that cannot build the translator
permanently rejected even when their compat layout already matches the
native layout. Let those architectures use the native parser instead.

Gate the translator requirement on COMPAT_FOR_U64_ALIGNMENT instead of
on in_compat_syscall() alone. Gating on the ABI property rather than on
CONFIG_XFRM_USER_COMPAT is deliberate: on x86 with IA32_EMULATION=y but
XFRM_USER_COMPAT=n, a 32-bit task must still be rejected rather than
routed through the native parser, which would misread genuinely
4-byte-aligned x86-32 messages. COMPAT_FOR_U64_ALIGNMENT is the ABI
property that makes the XFRM translator mandatory.

Only the receive/input direction needs the guard. The send, dump and
notification paths already call the translator as "if (xtr) { ... }"
with no error on NULL, so on arches without a translator they no-op and
the kernel emits native 64-bit-layout messages, which is what an AArch32
task expects.

Tested on Juniper SRX hardware: with the fix, 32-bit IPsec userspace
netlink and XFRM_POLICY setsockopt operations that previously failed
with -EOPNOTSUPP now succeed; x86 behaviour is unchanged by inspection.

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Fixes: 96392ee5a13b ("xfrm/compat: Translate 32-bit user_policy from sockptr")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_state.c |    2 +-
 net/xfrm/xfrm_user.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2410,7 +2410,7 @@ int xfrm_user_policy(struct sock *sk, in
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	if (in_compat_syscall()) {
+	if (IS_ENABLED(CONFIG_COMPAT_FOR_U64_ALIGNMENT) && in_compat_syscall()) {
 		struct xfrm_translator *xtr = xfrm_get_translator();
 
 		if (!xtr) {
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2833,7 +2833,7 @@ static int xfrm_user_rcv_msg(struct sk_b
 	if (!netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	if (in_compat_syscall()) {
+	if (IS_ENABLED(CONFIG_COMPAT_FOR_U64_ALIGNMENT) && in_compat_syscall()) {
 		struct xfrm_translator *xtr = xfrm_get_translator();
 
 		if (!xtr)


