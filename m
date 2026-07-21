Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BEA442118;
	Tue, 21 Jul 2026 22:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672593; cv=none; b=OKgz5z8yK5rVO+maUISfcdFxw1JcX01yalp7h9GO7uxNQ9VK8m2uF8rftVnTUshXdX0ISSw23+lgR+WnjPUAdeVkH7VDBkTkLqVgmSBQGi63vROnHNM91jQ8y1DVtArr2p87ht/j1PEO7XSI//B0LTixmuMNVejxdHSBvjL7t6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672593; c=relaxed/simple;
	bh=THvvgjkqLHoCFZTIuabm2EcDuIJOwq+UcKNfM4d7Kl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9gO1d6FqhafSvX9UIeCp1p4RL/KwFgBexdt8K6Po0SzURtLO7gT7YNx2TB+6VJsICVTIW1lo16hAKkyLJPcg2lW6M91WjsxonC6cX4v0gjvwyvjlbZQTrOa4TQ8iTNtEi5aDWm6yfI9IDGadelN+NiC4SfGDagkMDk6UoGm2jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5BD5lCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5BD5lCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7FB1F000E9;
	Tue, 21 Jul 2026 22:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672592;
	bh=gacTYZUib5ZIKofKOmGw6P5uZbsHv75VlRij8omj+zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5BD5lCzLSzVDRQDKhrd0hmzv/U9pzGhvIszpG7VYO6/Um/RvbgNQ5IjxFPR+2Geb
	 BPciLOOIkX3LNnVHZIva4IyPlTdeJmHbnxR8EQ84PUMifph7JhlZI2LQXIDwL1bH9R
	 Gy17EWqX5i8tw2v6LkJLk97ravSQkMxss2pfOr2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.15 639/843] xfrm: use compat translator only for u64 alignment mismatch
Date: Tue, 21 Jul 2026 17:24:34 +0200
Message-ID: <20260721152420.441749583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -2441,7 +2441,7 @@ int xfrm_user_policy(struct sock *sk, in
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	if (in_compat_syscall()) {
+	if (IS_ENABLED(CONFIG_COMPAT_FOR_U64_ALIGNMENT) && in_compat_syscall()) {
 		struct xfrm_translator *xtr = xfrm_get_translator();
 
 		if (!xtr) {
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2932,7 +2932,7 @@ static int xfrm_user_rcv_msg(struct sk_b
 	if (!netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	if (in_compat_syscall()) {
+	if (IS_ENABLED(CONFIG_COMPAT_FOR_U64_ALIGNMENT) && in_compat_syscall()) {
 		struct xfrm_translator *xtr = xfrm_get_translator();
 
 		if (!xtr)


