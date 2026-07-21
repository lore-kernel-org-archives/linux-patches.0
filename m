Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7C403AE9;
	Tue, 21 Jul 2026 22:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674243; cv=none; b=sFetZvDUrCrq+GrFivUXYqJQ3vP6l6cRyMWjEc56GC7x03YNLpYW/azDlJut786gh9ciKmYarZLWOuBWxeso7V0Tv+ygLAyH7htQF+QJewbTPQ3Da/5Fs1+/pZuJ+nau9VQ6cssNZPrY8J+oSzaNQQ2RhBRt9trZtQKnNuClTcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674243; c=relaxed/simple;
	bh=Nc8S8WAVtjFihE9XfRKrEY008EicjAdSLR+OZ01bUhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpsiIeknCgEj+QchOSqwkHVXncHxbpRo+wVAqLQ9w3S87FqXR7Uyx2L9fockCbqQq3twzkp1cROfy7HzRSiOJ12wAydhIWAt42H1ztlMNxUrU5VPW3lVE+Kb1/sUvFSebmhsX6H4k9COeZf2tOZnFSZtCY9cQPA79gk1j9D7Cqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OltAds1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OltAds1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C381F00A3A;
	Tue, 21 Jul 2026 22:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674242;
	bh=rjiLdg9N5GbvFpSgwo6WZkVuEw0cnCw9BcKi3E0ZoxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OltAds1SvL9xnhsBLWf0E55TFEtEu6dF5ofbir5jzHb1l4s+QgXM8miXS5fQb8sX
	 BgyKJWpfViOcV2kJF7fTrIzT0XlEfwQX74oDjPU+YL3t9oAVq4qPw0XrTBg9b7IOm8
	 1ZvjX46w+7BckfBpyN8TzPuStakmoRrRoiEblGAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 468/699] batman-adv: frag: fix primary_if leak on failed linearization
Date: Tue, 21 Jul 2026 17:23:47 +0200
Message-ID: <20260721152406.253933772@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 353d2c1d5492e53ae34f490a84494124dc3d3531 upstream.

If the skb has a frag_list, it must be linearized before it can be split
using skb_split(). But when this step failed, it must not only free the skb
but also take care of the reference to the already found primary_if.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a063f2fba3fa ("batman-adv: Don't skb_split skbuffs with frag_list")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -554,7 +554,7 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
 		ret = -ENOMEM;
-		goto free_skb;
+		goto put_primary_if;
 	}
 
 	/* Create one header to be copied to all fragments */


