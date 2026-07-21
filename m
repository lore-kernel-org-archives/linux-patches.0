Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC4E33689F;
	Tue, 21 Jul 2026 17:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654297; cv=none; b=AK8epHT8NGroOYxeLHuBAP28jQYjLIJW1oeA8dIJD0N6DbxD4MzCadWs4Q3ztoE/cMwJ5EzGXtp4R1a2flU79eskfylDD0YAe2B3dF9FxLVEoL7UMStfSEfUoYvxP9FTUdNwYngOktrFfsXrPZYzphakFOPrHokMNROjW82mtXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654297; c=relaxed/simple;
	bh=rt7NKjj+0OAjhyUfhsYJozf2G98A9E7wAhAJkmJuleU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loyAkwryiBCKUiit1p3AeUXl7OrcGONlo6n/y9jKraVPjAZxV03Du/PgDBy1JfyH/QueSkLFhfr7VYfLQ320guYEE7uJk3s8PS+e7zkRhkQggrqV9+qAgZyf6TMn6FmxB0fA5Qt/wLIG8dS69J8YVpQX6yhfDjx6Ymw+WVlQ/Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1x/wJ9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1x/wJ9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48631F000E9;
	Tue, 21 Jul 2026 17:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654296;
	bh=s4gW19/KvOKoxG+8jjvH8G42Jt65b0ihNvA5M9mPtS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1x/wJ9pMnLLHrWeQVU17WRUb6egufhUXFSzcapkcoD7qAtuOaB8g9ze1gzov2cCd
	 n3KlSUXZ27dk9Pddb76rvbjBcZk6Pw7hhb3I8FeZ4Y4JV7qBuy7WRWSzZEA722p5Sp
	 AWDWUIHxmdqg6ZnQ+/2dp+mFfk77bKv4p+1fsNnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1650/2077] batman-adv: frag: fix primary_if leak on failed linearization
Date: Tue, 21 Jul 2026 17:22:03 +0200
Message-ID: <20260721152631.666782063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -545,7 +545,7 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
 		ret = -ENOMEM;
-		goto free_skb;
+		goto put_primary_if;
 	}
 
 	/* Create one header to be copied to all fragments */


