Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74ED3C8C65;
	Sat, 17 Oct 2026 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255334; cv=none; b=kGNrRDr5neBaSMimZVLychwEx4yMqMqGaYxcozY1gvjIHk03+7mAutQfJkrixpDCjvIQ/PE6XewqplMsBWXoa+JiXJdmwsrt+gTbgfBwj4/HqczLHbAsACcxgDODU8c0SqG0WF8cssYLQ2k4xgfoKJRA+OZibmPA05U8o3EE5lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255334; c=relaxed/simple;
	bh=9u6eXypB4Sg0UwzX/CuqooABuqfkmKym+Bc8Kko2sTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMZpcJHEdzOumMqZZR9C/cMXoKr+ZzqdmVWK32sripolT6P/qivdOoByPEGBiMP+hImaxe0R4yEqRchj00/v+4+MpwDox0HumkV4i+rUrF6pFzHGxu3piMOHB2PouNyQnaEK0AugTeHLzRGQv4Iq082pE4ZDN/cEUy4aA432MTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQ8YIPsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQ8YIPsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2341F000C4;
	Sat, 17 Oct 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255332;
	bh=1ylvzN96CFwOpUlu6Mtay98SfR/K2ulhoPSVjZTUc6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQ8YIPsRDWlyviItHV2k7u5YATaUJg8zVfs9pXnNgiBYUxAy8fvmG8Olz2VrVEHqw
	 rC8t3PBkvrqOdJu6yxwUyj6Gg8jT6o5Ss63ZmE9ghbUT3lLZUk6TdrKC7hD4CpJdN4
	 YEGLa1gkH2TU7hi5QtdABF5bwCtKO/cmSNatoNnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Azzouzi <maherazz04@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 704/869] esp: do not unref managed frag pages in esp_ssg_unref()
Date: Sat, 17 Oct 2026 17:59:05 +0200
Message-ID: <20261017160055.015556236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Azzouzi <maherazz04@gmail.com>

[ Upstream commit 21697720ff43b8dfa25b8e8d9ca7f56f4597fc80 ]

esp_ssg_unref() releases the page references held on the source
scatterlist after the AEAD operation completes.  It calls
skb_page_unref() on every frag page for an out-of-place transform
(req->src != req->dst), and in the error path of esp_output_tail()
(already_unref == true) on the request's own scatterlist.

This is wrong when the skb carries managed frags
(SKBFL_MANAGED_FRAG_REFS).  Managed frags are owned by a zerocopy ubuf
and the skb does not hold a per-frag page reference; io_uring SEND_ZC
with a registered buffer attaches the bvec pages this way via
io_sg_from_iter().  The rest of the stack honours this invariant:
skb_release_data() skips the per-frag unref when SKBFL_MANAGED_FRAG_REFS
is set, and skb_zcopy_managed() is the guard used at the other unref
sites.

esp_ssg_unref() is missing that guard, so for a managed-frag skb it
drops a page reference the skb never acquired.  This can underflow the
page reference count and free a page that is still in use.

Guard the function with skb_zcopy_managed() so both unref paths are
skipped for managed-frag skbs, matching skb_release_data().

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
Signed-off-by: Maher Azzouzi <maherazz04@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 7 +++++++
 net/ipv6/esp6.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index fb78dc6b7e148..8944f812e4b55 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -104,6 +104,13 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	struct aead_request *req;
 	struct scatterlist *sg;
 
+	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
+	 * per-frag page reference, so we must not drop one here.  Mirrors
+	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
+	 */
+	if (skb_zcopy_managed(skb))
+		return;
+
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 7411aac0707b2..3061e74799170 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -121,6 +121,13 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	struct aead_request *req;
 	struct scatterlist *sg;
 
+	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
+	 * per-frag page reference, so we must not drop one here.  Mirrors
+	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
+	 */
+	if (skb_zcopy_managed(skb))
+		return;
+
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
-- 
2.53.0



