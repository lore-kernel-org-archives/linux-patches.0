Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFD83D3002;
	Wed, 30 Sep 2026 19:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795897; cv=none; b=N0veribFQvFt3zImiCbl+AX/gf6s6shEkFligR0iLWty/qwI1pGUyVlLTSknWMxOUdy7doD9dAIiBeuGdv+xp6tTRP7vXoZrCK1FcFyuBDGkNwtRBzu/WQXfy5Ax/8kMHUbFRVWkQKQeK9tZRtvCcWCSY0/igT32xqFh1K3rgqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795897; c=relaxed/simple;
	bh=fUgeWiqqmOBl4xb+bctr3uR66d6hV5uWqkEWVIg9ido=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG4jQHCvtJstoaPlNgQzWP5LcPT1JrkmdA5ij40QVFiicS4GKNgAVsUhT/z3VCFIQs+zm7z/aS1QweXte/QiDhamgupwgFUgnYqXNwNKRLXvEy1vGYlSbbwlz/8AT2vu4PBnQqAcAOfRv4hcjH83k9Ot5J0q6aYjMDTiCg513zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXhxbIW9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXhxbIW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC391F000FF;
	Wed, 30 Sep 2026 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795896;
	bh=+eqWugk7z1d/KQPzwdZh0xmo+fAVSAtGqFQe/cHFJyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXhxbIW9252kggGtYpyLw3e4LDOnoF+Yu4jr26IU6RDHxsNr1/wABWNWonK8dvdTz
	 wM3TG/lan75qQX4TZkvk8EikEiRPtiMICcxCJX8MArEYHLQURrmDVudg3wtyd2i1Mu
	 ibW0UzmvkHmEAdiFo9KmRx1BMkPXMTMurZVBb1jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Azzouzi <maherazz04@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0723/1193] esp: downgrade zerocopy managed frags before mutating skb frags
Date: Wed, 30 Sep 2026 17:23:27 +0200
Message-ID: <20260930152450.314941262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3fb7b07c7c8f9..8850a1dc8c339 100644
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
index 843f5682f1215..66a4d37bc0f9a 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -473,6 +473,12 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 
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



