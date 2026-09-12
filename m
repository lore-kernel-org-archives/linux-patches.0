Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E683B2F617C;
	Sat, 12 Sep 2026 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238635; cv=none; b=ukqWIhvZiJV+pw/1bQufXWpCtbgsYgMi454aAefY1Ghnt8lx8yx4dl+reSiQXakpGniGtdybe3pHSa79o8ZuvTeb4YIsbf9j7YofKAw8ZWDQKThM1QOHQEKLGfabEe4vC6TaN2VZFnNx1VjpcV+Jw4x6J7WI1brLpfs5+XR7z2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238635; c=relaxed/simple;
	bh=HfZpsaMyo3P0p2xeYJnIylYI6ItTScx9PtfrTlxE8nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAKSCBOOY8n+vxKk1GCQRBUXHArxXWRSPHzOr98+7C/Us+92Kn+MlmQZjSmqJb5ucptQMFSLZW3TnNv2DyBtKr5n3v9Ave1HHdy9FxYfdJ1DwGMRVQbBOB3o4LBxXE/GhB+cKC8zBazn4TAtmHay0WdIWDCfHEZ8DkVq7itsX5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvhWAeWe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvhWAeWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547D61F000FF;
	Sat, 12 Sep 2026 18:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238633;
	bh=gyuhDsCyxgfylsalTJb81m77YlO2GNA3hC5lTbVBNak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvhWAeWedIbX4hWe1Ak97xkRx4mOzLRkZydTFHlyIQKWFQJPAIOY3rLZNxLl8scpF
	 D1qVKXrdj6JHdZBKzBAgAx5GouB6Oep/9ZhE8x0E7g1EfiUl1Mok3/Z/mPVMNqGXHu
	 y93wyugKQ6vrTAgTNUkrVqXcW2bLNNEvcReTrWns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 503/935] xfrm6: fix out-of-bounds write in xfrm6_input_addr() when secpath is full
Date: Sat, 12 Sep 2026 08:58:53 +0200
Message-ID: <20260912065538.353531108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 5d9e3bf34fec9a5d237e4b7cef4a707bc2e091bc ]

The depth check in xfrm6_input_addr() is off by one:

  if (1 + sp->len == XFRM_MAX_DEPTH)
          goto drop;
  ...
  sp->xvec[sp->len++] = x;

xfrm_input() can leave sp->len == XFRM_MAX_DEPTH, and the transport-mode
receive path re-enters IPv6 input via xfrm_trans_reinject() with that
secpath preserved. If the inner packet carries a destination-options HAO
option or a type-2 routing header, xfrm6_input_addr() is called with
sp->len == XFRM_MAX_DEPTH; the check (1 + 6 == 6) is false, so
sp->xvec[sp->len++] writes one slot past the 6-element xvec[]. The write
stays within the sec_path allocation (invisible to KASAN); UBSAN_BOUNDS
flags it and panics under panic_on_warn.

Use "sp->len >= XFRM_MAX_DEPTH", matching xfrm_input(). This also
restores one chain level the old check rejected at sp->len == 5.

  UBSAN: array-index-out-of-bounds in net/ipv6/xfrm6_input.c:309:10
  index 6 is out of range for type 'xfrm_state *[6]'

Fixes: 9473e1f631de ("[XFRM] MIPv6: Fix to input RO state correctly.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 7dbefbb338ca5..9d52dffc10924 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -193,7 +193,7 @@ int xfrm6_input_addr(struct sk_buff *skb, xfrm_address_t *daddr,
 		goto drop;
 	}
 
-	if (1 + sp->len == XFRM_MAX_DEPTH) {
+	if (sp->len >= XFRM_MAX_DEPTH) {
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMINBUFFERERROR);
 		goto drop;
 	}
-- 
2.53.0



