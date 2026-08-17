Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92A43C7DEB;
	Mon, 17 Aug 2026 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979540; cv=none; b=Zs0wuLhhMFMhgvWqAl08NWL3kIo4hC7yptDx7/5OPChyI3/aaeNofKxFsgmRn/nNCtfFOQ2V0S7TXCRZGNcsNb3NTyVaFs9Zxcxoq9QLVr23nhN7+hfPKWY9rcsJlr3KKVj7aY0iMGvgmCCOHvLNBcZSIGlJ1I6TdMs3ey+uuDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979540; c=relaxed/simple;
	bh=AAQ9HjK3EexArGMcdeq+0Md/dTPlyo/kMIKGNNLRTrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEOYUtpPaAUYdkvWDvKmN/iA0YLnoz4lbu6a3HB48BNjE+TxE8INngS0gN107dbDCGkC3guqughKiyQslI+pi1JsmHCibYiPUwwuC0q8WHsFiZs2UBwgj+yXgIsOJVbJ5VpLkCZkKoHcXFgx/pZ7i54lyze7BsG8rpXE31IDDwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJQLee08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJQLee08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267D71F000E9;
	Mon, 17 Aug 2026 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979539;
	bh=pcwlaovA74V5hzltAo9Vyev5voC6QuVHEwz5ze36Ll4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJQLee08fRX21QreD2xKRn1/yML9nend6OZ+U2QqMsg4pAz5Y5gOfkKxpAKWOCUSJ
	 N4vew3CynXtEJxii2zSi4aGAfy/KB+QPe93UTCXDQw52jhMatHMhthKD3F8tBZSkDW
	 LAyg4aX5U1ZkWLdrDy1Vlviu82mhU+5XIYMlzBbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 261/609] phonet: pep: fix use-after-free in pep_get_sb()
Date: Mon, 17 Aug 2026 15:29:17 +0200
Message-ID: <20260817132552.843148009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 0f71f852a96af9685858ce59fda34ecbf85c283d upstream.

pep_get_sb() doesn't consider that pskb_may_pull() might have relocated
the skb data, and continue to access the older pointer, causing UAF.

Reproduced under KASAN:

  BUG: KASAN: slab-use-after-free in pep_get_sb+0x234/0x3b0
  Read of size 1 at addr ff11000105510f50 by task repro/157
   pep_get_sb+0x234/0x3b0
   pipe_handler_do_rcv+0x5f7/0xa10
   pep_do_rcv+0x203/0x410
   __sk_receive_skb+0x471/0x4a0
   phonet_rcv+0x5b3/0x6c0
   __netif_receive_skb+0xcc/0x1d0

Refetch the header with skb_header_pointer() after pskb_may_pull(), so
the possibly stale pointer is no longer dereferenced. There are better
ways to solve this, but, this is the less instrusive one.

Fixes: 9641458d3ec4 ("Phonet: Pipe End Point for Phonet Pipes protocol")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260721-phonet_get_sb_uaf-v1-1-95fd7881cc4e@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -55,6 +55,8 @@ static unsigned char *pep_get_sb(struct
 	ph = skb_header_pointer(skb, 0, 2, &h);
 	if (ph == NULL || ph->sb_len < 2 || !pskb_may_pull(skb, ph->sb_len))
 		return NULL;
+	/* pskb_may_pull() may have reallocated the head; refetch ph. */
+	ph = skb_header_pointer(skb, 0, 2, &h);
 	ph->sb_len -= 2;
 	*ptype = ph->sb_type;
 	*plen = ph->sb_len;


