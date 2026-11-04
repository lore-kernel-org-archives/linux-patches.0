Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829018;
	b=Fa9+OJIH+tj+wyAiOOeelSWwMRFWZ9t3AHMc5EBlznYwkab6d9diZhouxNYkwHISDdr9
	 JBr0Zf506907ORIaKpHzLop0ustkr1GS5TiWGSsWBX3J0a0howUPHak922qQ1VQ99geso
	 CYdagREfQn4IRQTIDkmHyI7wulkcRCqRtNfbmV8kdK0D2mHDL4+N3yb0wShRXj7IswoOx
	 KtfsrrQRpnLzF6DWia0xlNdjpCM6JGyGcrjlF2zZv0BGRYah8og085G1DaeUYonMEvDY7
	 leshJ5N5senIRxDUxm1NzBe0CVHe0kFEMUaKeuXDVxhNSHWbPSTEgo7mx82JbLfLRhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UusaPAZdcYc6yB6e9GZyiGpymWT0P2mYHneKosUSAmo=;
	b=t9mpordrlG0bvWMypKxGXVSH8rsNhnxNf6k5dv3WIl8Vzod7ystiX1VpciZ+2IOQeoti
	 Qcc/OmECNMD5xu0ie2rLnwHfIJouiYpfleSyhTPuVgx993h+YJ803AdobgDgwWAEFfUpb
	 qyFjcvk+dpdGY5LFjxSvMH7g66wr6V3mb3sF5BT63hN5n2p+IR0LyjZdiHtI3eOQA5iSn
	 oIEIIKO1gbfOSsUyUxr9R3966fViUCbahA/lLma4CQNPqLql3cmO9mtZ8atXJ6NzOPiyG
	 +RWR6b6Eb1YX62VXAs223vyRazShBOFryxsdxdAaIB4nQPuXTZSdWf0LvSLNVFE2Q5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxnZ9tqc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469ED607074A;
	Wed,  4 Nov 2026 21:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxnZ9tqc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB31F1F000C1;
	Wed,  4 Nov 2026 21:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829018;
	bh=UusaPAZdcYc6yB6e9GZyiGpymWT0P2mYHneKosUSAmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxnZ9tqcHxDL3dLomKIlKkZcOo68h+zIc0qB5OHW2gHDBpQqpbAJvNeqZDaL0+8pw
	 y56DBSn9KriAVNOCPFQlzzoArp+jPtCGluSDfV5nQiSfAWA2F62URmTdiIS3vk4jJD
	 6b903CDM3ogLcxCY3Og4B5VCO+32lfqFQD+Im/iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 352/547] xfs: clarify various parts of the bitmap API
Date: Wed,  4 Nov 2026 16:08:56 -0500
Message-ID: <20261104211048.273368648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 00f32fdf54983371d39162efef7df693e2842ffb upstream.

LOLLM pointed out some underspecified parts of the xbitmap{32,64} API.
Specifically, the behavior of set/clear/test functions when the length
parameter is zero is not well defined, nor is what happens when someone
tries to disunion a bitmap with itself.  None of these situations are
expected, but we'll define zero-length set and clear to be nops, and the
rest to be checked by assertions.

Cc: stable@vger.kernel.org # v6.8
Fixes: 6ece924b952262 ("xfs: create separate structures and code for u32 bitmaps")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/bitmap.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -77,6 +77,9 @@ xbitmap64_clear(
 	struct xbitmap64_node	*new_bn;
 	uint64_t		last = start + len - 1;
 
+	if (!len)
+		return 0;
+
 	while ((bn = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last))) {
 		if (bn->bn_start < start && bn->bn_last > last) {
 			uint64_t	old_last = bn->bn_last;
@@ -127,6 +130,9 @@ xbitmap64_set(
 	uint64_t		last = start + len - 1;
 	int			error;
 
+	if (!len)
+		return 0;
+
 	/* Is this whole range already set? */
 	left = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last);
 	if (left && left->bn_start <= start && left->bn_last >= last)
@@ -223,6 +229,8 @@ xbitmap64_disunion(
 	struct xbitmap64_node	*bn;
 	int			error;
 
+	ASSERT(bitmap != sub);
+
 	if (xbitmap64_empty(bitmap) || xbitmap64_empty(sub))
 		return 0;
 
@@ -287,6 +295,8 @@ xbitmap64_test(
 	struct xbitmap64_node	*bn;
 	uint64_t		last = start + *len - 1;
 
+	ASSERT(*len > 0);
+
 	bn = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last);
 	if (!bn)
 		return false;
@@ -357,6 +367,9 @@ xbitmap32_clear(
 	struct xbitmap32_node	*new_bn;
 	uint32_t		last = start + len - 1;
 
+	if (!len)
+		return 0;
+
 	while ((bn = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last))) {
 		if (bn->bn_start < start && bn->bn_last > last) {
 			uint32_t	old_last = bn->bn_last;
@@ -407,6 +420,9 @@ xbitmap32_set(
 	uint32_t		last = start + len - 1;
 	int			error;
 
+	if (!len)
+		return 0;
+
 	/* Is this whole range already set? */
 	left = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
 	if (left && left->bn_start <= start && left->bn_last >= last)
@@ -503,6 +519,8 @@ xbitmap32_disunion(
 	struct xbitmap32_node	*bn;
 	int			error;
 
+	ASSERT(bitmap != sub);
+
 	if (xbitmap32_empty(bitmap) || xbitmap32_empty(sub))
 		return 0;
 
@@ -567,6 +585,8 @@ xbitmap32_test(
 	struct xbitmap32_node	*bn;
 	uint32_t		last = start + *len - 1;
 
+	ASSERT(*len > 0);
+
 	bn = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
 	if (!bn)
 		return false;


