Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0FD46E005;
	Tue, 21 Jul 2026 19:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663615; cv=none; b=TvLIeyw3Oz+l92IUt0LelSWy1XVYdd6ub5VIbfx8ndZzd63qofPYxpIYG3wPfW5dAmuoNymPwrjXSPseBkF8eroj/lufXfzLceMuxGat5CPpEb2pGCmLv0V5EPED78EzAfEeysW73bHEsupAQXO+ksCIY8+u/jxSNmEvJhEahgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663615; c=relaxed/simple;
	bh=XbRFpNxCS9H9c/v5x60wS1u3rfT74fq3BvfR6/ceRPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8KdaQojOxEYh9bjh3GDuMRlS6DuacB1V+GBds323AWqlX2JZO50CzN1jiRpiieo7dxG5kCSeAv38IYnxmKf4o+9xPYCdAhX4ounY986WySYBfrKxkn7Z+wBzEuCYoCf4SDQpiq3kEskLGwdWlUnBUVKXOgQ1uLFijgWHPdXDms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLqlmt7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLqlmt7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A931F000E9;
	Tue, 21 Jul 2026 19:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663613;
	bh=p5nlPGfkHce7h0MZ2fh0Dv83lUSR6JIT+PZcODZx6G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLqlmt7CojHh1cj8g6OWoFfHINPFAif1/cTXHXQCly8VrW3/O90d/XYTgkXzYaTG0
	 ZlwA3wdTU/fG30borbY3VgD8HRNys8w1AnefCAx/mL72IOefDS4duSFgYJlNDOr+dz
	 IAhL3PYUNpDAJtX4dWeZei9fHNldgiOHa6F/KCt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0890/1276] batman-adv: frag: free unfragmentable packet
Date: Tue, 21 Jul 2026 17:22:13 +0200
Message-ID: <20260721152505.962274289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 6b628425aed49a1c7a4ffc997583840fc582d32b upstream.

The caller of batadv_frag_send_packet() assume that the skb provided to the
function are always consumed. But the pre-check for an empty payload or the
zero fragment size returned an error without any further actions.

A failed pre-check must use the same error handling code as the rest of the
function.

Cc: stable@vger.kernel.org
Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -516,8 +516,10 @@ int batadv_frag_send_packet(struct sk_bu
 	mtu = min_t(unsigned int, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
 	max_fragment_size = mtu - header_size;
 
-	if (skb->len == 0 || max_fragment_size == 0)
-		return -EINVAL;
+	if (skb->len == 0 || max_fragment_size == 0) {
+		ret = -EINVAL;
+		goto free_skb;
+	}
 
 	num_fragments = (skb->len - 1) / max_fragment_size + 1;
 	max_fragment_size = (skb->len - 1) / num_fragments + 1;


