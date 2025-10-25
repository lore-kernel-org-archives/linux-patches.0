Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270E3307AF4;
	Sat, 25 Oct 2025 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409216; cv=none; b=pmW/DNy7lwq6xqebLCP59kh9W3gpcBtcCu0qKGGphJQJR2v7jc5pkyA3JLvSA7BeOVREZWQP5+ayvFsvd92N+MJ7D2olvwlUUQo2aj3QE8g1Xj647jozG2J/TawObV2kTJFWT4X3vD6wZqDhH2B9CDdSJpJksVdW/3+z+vxEfvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409216; c=relaxed/simple;
	bh=dFOZ/g7NVQFO7jKXZtBK3uxcbbOqAQ2mxYtgxvk6JSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZsUThdsKAUI8aurxPMQLFV5JNftklAJuV4qtbIQRu/IfJHORKXhVZlb7yy3TRB5hdiV1IPw40ie9ELwqWJUZsC4S62AJVwLyHxJAv596zT9m3vHcUo1NtAGJGgPSEO3KlcEX8I4lgy6TfELOmEdfe7sqV6jUJk1QfnGgqgs8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rfd23nvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rfd23nvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1733C4CEF5;
	Sat, 25 Oct 2025 16:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409216;
	bh=dFOZ/g7NVQFO7jKXZtBK3uxcbbOqAQ2mxYtgxvk6JSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rfd23nvcXaVgZ9bfzYL51nxTh4a+V0ykMa34qhCrdoUHe5SVn33KwYs+c2yLUeAF2
	 Ai66GVHEZsj517zimR3ElvFF4QixSRJ+nt2XTLt3smBeyBJY92UDyNxLWcOQgZFsXR
	 b3qZujrdfxq2lKzKrrRXOitpn2wzVSr1xpTX/jiZhP8cGq+/a2qf512uCfyFpfLAH7
	 HNOImdQ9m4kasCVGtwyHquTjrjAPgexQiNf3uAtFkA9E1SbakGtyd74m9olDy9g39L
	 934S+diw6cvQjGUSmN4vH1m1LWTiRGFD51ZGve6Z8YQs8QRDN6axmK3l4Rjfgkd1Lz
	 BUbcqWjFATmcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charalampos Mitrodimas <charmitro@posteo.net>,
	syzbot+01b0667934cdceb4451c@syzkaller.appspotmail.com,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] net: ipv6: fix field-spanning memcpy warning in AH output
Date: Sat, 25 Oct 2025 11:57:56 -0400
Message-ID: <20251025160905.3857885-245-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Charalampos Mitrodimas <charmitro@posteo.net>

[ Upstream commit 2327a3d6f65ce2fe2634546dde4a25ef52296fec ]

Fix field-spanning memcpy warnings in ah6_output() and
ah6_output_done() where extension headers are copied to/from IPv6
address fields, triggering fortify-string warnings about writes beyond
the 16-byte address fields.

  memcpy: detected field-spanning write (size 40) of single field "&top_iph->saddr" at net/ipv6/ah6.c:439 (size 16)
  WARNING: CPU: 0 PID: 8838 at net/ipv6/ah6.c:439 ah6_output+0xe7e/0x14e0 net/ipv6/ah6.c:439

The warnings are false positives as the extension headers are
intentionally placed after the IPv6 header in memory. Fix by properly
copying addresses and extension headers separately, and introduce
helper functions to avoid code duplication.

Reported-by: syzbot+01b0667934cdceb4451c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=01b0667934cdceb4451c
Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this needs backport
- Fixes real runtime WARNINGS from FORTIFY_SOURCE that can escalate to
  kernel panics on systems with panic_on_warn. The warning cited by
  syzbot shows a cross-field memcpy detected at runtime in AH output
  paths.
- Impacts users of IPv6 IPsec AH (xfrm). Even if AH is less common than
  ESP, false-positive warnings in networking code are undesirable and
  can disrupt CI/fuzzing or production systems with strict warn
  handling.

What is wrong in current stable code
- In AH output, the code intentionally copies the saved addresses plus
  the extension headers by writing past the 16-byte IPv6 address field
  into the memory directly following the base IPv6 header. This is
  semantically correct for the packet layout but trips FORTIFY’s “field-
  spanning write” checks.
- Problematic restores in output paths (write beyond `in6_addr` field):
  - net/ipv6/ah6.c:304–310 writes `extlen` bytes into `&top_iph->saddr`
    or `&top_iph->daddr`, which FORTIFY sees as overflowing a single
    field.
  - net/ipv6/ah6.c:437–443 repeats the same pattern after synchronous
    hash calculation.
- Symmetric “save” path copies from a field address:
  - net/ipv6/ah6.c:383–386 copies from
    `&top_iph->saddr`/`&top_iph->daddr` into the temporary buffer. While
    reads don’t trigger the runtime write check, the pattern mirrors the
    flawed restore approach.

What the patch changes
- Introduces helpers to separate copying of addresses from copying of
  extension headers, eliminating cross-field writes:
  - ah6_save_hdrs(): saves `saddr` (when CONFIG_IPV6_MIP6) and `daddr`,
    then copies extension headers from `top_iph + 1` into the temporary
    buffer’s `hdrs[]`.
  - ah6_restore_hdrs(): restores `saddr` (when CONFIG_IPV6_MIP6) and
    `daddr`, then copies extension headers into `top_iph + 1`.
- Replaces the field-spanning memcpy sites with these helpers:
  - In ah6_output_done(), instead of writing `extlen` bytes into
    `&top_iph->saddr`/`&top_iph->daddr` (net/ipv6/ah6.c:304–310), it
    calls ah6_restore_hdrs() to:
    - write addresses field-by-field, then
    - write extension headers starting at `top_iph + 1`, i.e.,
      immediately after the IPv6 base header, avoiding cross-field
      writes.
  - In ah6_output(), instead of saving `extlen` bytes starting from
    `&top_iph->saddr`/`&top_iph->daddr` into the temp buffer
    (net/ipv6/ah6.c:383–386), it calls ah6_save_hdrs() to:
    - read addresses field-by-field, then
    - copy extension headers from `top_iph + 1`.
- Extent calculation is preserved. `extlen` is unchanged and still
  includes `sizeof(*iph_ext)` when there are IPv6 extension headers; the
  helpers correctly use `extlen - sizeof(*iph_ext)` to copy only the
  extension headers into/out of `hdrs[]`.

Why it’s safe
- No functional semantics change: the same data (addresses + extension
  headers) are preserved/restored, just via safe destinations/sources
  (`top_iph + 1` for headers, explicit fields for addresses) instead of
  a single field pointer spanning into adjacent memory.
- Scope is small and entirely contained to net/ipv6/ah6.c; only
  ah6_output() and ah6_output_done() are touched plus two local static
  inline helpers.
- Config guards are preserved: when CONFIG_IPV6_MIP6 is enabled, `saddr`
  is saved/restored explicitly; otherwise only `daddr` is handled,
  matching prior behavior.
- Interactions with ipv6_clear_mutable_options() are unchanged; data is
  saved before zeroing mutable options and restored afterward as before.
- No ABI/API changes; only internal copying strategy is refactored to
  avoid FORTIFY warnings.

Stable tree criteria
- Bugfix that affects users: Prevents runtime WARN splats (and possible
  panic_on_warn) in IPv6 AH output paths. The commit references a syzbot
  report, indicating real-world triggerability.
- Minimal risk: Localized refactor with straightforward memcpy
  target/source changes.
- No new features or architectural changes.
- Touches a networking security subsystem (xfrm/AH) but in a very
  controlled way.

Version/dependency considerations
- The runtime “cross-field memcpy” WARN was introduced by fortify
  changes (e.g., commit akin to “fortify: Add run-time WARN for cross-
  field memcpy()”). All stable kernels that include these FORTIFY
  runtime checks and the current AH layout will benefit.
- The code structure in this branch matches the pre-fix pattern; the
  helpers should apply cleanly around existing sites at
  net/ipv6/ah6.c:304–310, 383–386, 437–443.
- No external dependencies; helpers are file-local.

Conclusion
- This is a targeted, correctness/safety fix that removes disruptive
  false-positive warnings with negligible regression risk. It should be
  backported to stable kernels that carry FORTIFY cross-field memcpy
  checks and the current AH implementation.

 net/ipv6/ah6.c | 50 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index eb474f0987ae0..95372e0f1d216 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -46,6 +46,34 @@ struct ah_skb_cb {
 
 #define AH_SKB_CB(__skb) ((struct ah_skb_cb *)&((__skb)->cb[0]))
 
+/* Helper to save IPv6 addresses and extension headers to temporary storage */
+static inline void ah6_save_hdrs(struct tmp_ext *iph_ext,
+				 struct ipv6hdr *top_iph, int extlen)
+{
+	if (!extlen)
+		return;
+
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+	iph_ext->saddr = top_iph->saddr;
+#endif
+	iph_ext->daddr = top_iph->daddr;
+	memcpy(&iph_ext->hdrs, top_iph + 1, extlen - sizeof(*iph_ext));
+}
+
+/* Helper to restore IPv6 addresses and extension headers from temporary storage */
+static inline void ah6_restore_hdrs(struct ipv6hdr *top_iph,
+				    struct tmp_ext *iph_ext, int extlen)
+{
+	if (!extlen)
+		return;
+
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+	top_iph->saddr = iph_ext->saddr;
+#endif
+	top_iph->daddr = iph_ext->daddr;
+	memcpy(top_iph + 1, &iph_ext->hdrs, extlen - sizeof(*iph_ext));
+}
+
 static void *ah_alloc_tmp(struct crypto_ahash *ahash, int nfrags,
 			  unsigned int size)
 {
@@ -301,13 +329,7 @@ static void ah6_output_done(void *data, int err)
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 	memcpy(top_iph, iph_base, IPV6HDR_BASELEN);
 
-	if (extlen) {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-		memcpy(&top_iph->saddr, iph_ext, extlen);
-#else
-		memcpy(&top_iph->daddr, iph_ext, extlen);
-#endif
-	}
+	ah6_restore_hdrs(top_iph, iph_ext, extlen);
 
 	kfree(AH_SKB_CB(skb)->tmp);
 	xfrm_output_resume(skb->sk, skb, err);
@@ -378,12 +400,8 @@ static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
 	 */
 	memcpy(iph_base, top_iph, IPV6HDR_BASELEN);
 
+	ah6_save_hdrs(iph_ext, top_iph, extlen);
 	if (extlen) {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-		memcpy(iph_ext, &top_iph->saddr, extlen);
-#else
-		memcpy(iph_ext, &top_iph->daddr, extlen);
-#endif
 		err = ipv6_clear_mutable_options(top_iph,
 						 extlen - sizeof(*iph_ext) +
 						 sizeof(*top_iph),
@@ -434,13 +452,7 @@ static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 	memcpy(top_iph, iph_base, IPV6HDR_BASELEN);
 
-	if (extlen) {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-		memcpy(&top_iph->saddr, iph_ext, extlen);
-#else
-		memcpy(&top_iph->daddr, iph_ext, extlen);
-#endif
-	}
+	ah6_restore_hdrs(top_iph, iph_ext, extlen);
 
 out_free:
 	kfree(iph_base);
-- 
2.51.0

