Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC7339A07C;
	Wed, 23 Sep 2026 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174198; cv=none; b=HlozXGxkfYZiTDFgwN+L7r8XCy6wkG5soWtiI4/qelQ7Qa42hkdwBjeMRgz2HKGou2BXApkAk3+/2tdxV2jqxnwzpCtXs/56ErKp0T227uuyfcCXKfeLyFN7z+efGnhqTPsFUQWD3GOhZV7fxME22lfm88tPDJsF3YtARlWYCyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174198; c=relaxed/simple;
	bh=6M8QLswBip4uS9GtOglT0tTvel8MhWixRMFMMyepwbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr+Vf3GxCi3D5nw56jrZWd3xmppHVRXPclVUqfm3Rpfsgsm6mvovlpv4K02hg2wy6i74GNvN/c79HPwYudwov/N77xh3flPh1JMJh1iYVmYwz8zzK74b8gZNrLj6k8ojDjhjGDgCrWcEJmxUTy1utTgqxd+yY6Ht4TG72fto5AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKaiT6fx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKaiT6fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8861F00893;
	Wed, 23 Sep 2026 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174197;
	bh=f7Tz3Y+eeSMCTtAbhU1twHdy3y1j7JHHXhaEvjkgH6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KKaiT6fxLlvG5gYRyq8oRWvfsTLbuMrNTPIOlU+N0t7igwkzNb8mKZnWrw0t3VWJ+
	 wMY6uG6qBFBCVcwL2eB8RdXcFM+sewNAIRnYMX1WswxCyIGKnbahYaok/pHoNpXi0k
	 uki9lopNwP6GSgerYJLoPsCBrIm9AVOnSazD6aww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Azzouzi <maherazz04@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/398] esp: downgrade zerocopy managed frags before mutating skb frags
Date: Wed, 23 Sep 2026 16:01:36 +0200
Message-ID: <20260923140644.009262182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Azzouzi <maherazz04@gmail.com>

[ Upstream commit f89416eb3db151170a6f3c6dfc5239d26cdce4d2 ]

On the out-of-place output path (esp->inplace == false) ESP rewrites the
skb frag array: esp_output_head() appends a trailer frag and
esp_output_tail() replaces the frags with a destination page, both
referenced with get_page().

When the skb carries zerocopy managed frags (SKBFL_MANAGED_FRAG_REFS) the
payload frags are owned by the ubuf and must not be referenced or
unreferenced individually, but ESP mutates the frag array without ever
downgrading the skb.  This breaks the managed-frag invariant two ways:

  - esp_ssg_unref() walks the source scatterlist and drops a page
    reference for every frag, including the ubuf-owned payload frags,
    pushing their refcount below the GUP pin bias while the pages are
    still pinned, i.e. a use-after-free of the zerocopy pages;

  - esp_output_tail() installs its destination page as frag 0 with
    get_page() but leaves SKBFL_MANAGED_FRAG_REFS set, so
    skb_release_data() takes the skip_unref branch and never drops that
    reference, leaking the x->xfrag page at packet rate.

Fix this the way every other frag-mutating site does (__ip_append_data(),
__ip6_append_data(), tcp_sendmsg_locked()) and call
skb_zcopy_downgrade_managed() before ESP touches the frag array: it takes
a real reference on each existing frag and clears SKBFL_MANAGED_FRAG_REFS,
so the per-frag unref in esp_ssg_unref() and the frag release in
skb_release_data() are both balanced and no mixed-ownership frag array is
left behind.

Fixes: 753f1ca4e1e5 ("net: introduce managed frags infrastructure")
Signed-off-by: Maher Azzouzi <maherazz04@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 6 ++++++
 net/ipv6/esp6.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 513c8215c947f..346e78c23af00 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -438,6 +438,12 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 
 			esp->inplace = false;
 
+			/* Take real page refs and clear SKBFL_MANAGED_FRAG_REFS before
+			 * we mutate the frag array, so the per-frag unref stays balanced
+			 * for zerocopy managed frags (see __ip_append_data()).
+			 */
+			skb_zcopy_downgrade_managed(skb);
+
 			allocsize = ALIGN(tailen, L1_CACHE_BYTES);
 
 			spin_lock_bh(&x->lock);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 57481e423e59e..b26b85afb92ed 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -467,6 +467,12 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 
 			esp->inplace = false;
 
+			/* Take real page refs and clear SKBFL_MANAGED_FRAG_REFS before
+			 * we mutate the frag array, so the per-frag unref stays balanced
+			 * for zerocopy managed frags (see __ip_append_data()).
+			 */
+			skb_zcopy_downgrade_managed(skb);
+
 			allocsize = ALIGN(tailen, L1_CACHE_BYTES);
 
 			spin_lock_bh(&x->lock);
-- 
2.53.0



