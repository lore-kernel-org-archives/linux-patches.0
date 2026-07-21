Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A064544AB9D;
	Tue, 21 Jul 2026 21:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670011; cv=none; b=RHxrH0kn6F2iaSXiygaFaCBEcScLrNQYZ7zvrlS4BBSZhE9oZCsZrvEzD4Sd2rbk0xHPvMxq4/hTyk3p2OuZCaYYt5TyXMf00qlVxJunvx767Jymb9Dvtbq4GdUWxq/W40Cyh973wuu5BGn79wkjE003e6lSqbLzqbgQsTC0Imw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670011; c=relaxed/simple;
	bh=HuQ/cswb9EgxAxnqFvyZC6u8RhSTzhG0xa1Wut6dGlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2Tgk6AjDvZwc1UEMK/9GFmVYKWnwL/xuxgGmBUgNc/CNuVWa1V/A1j+U26OtJUtgz3e9J+uw8ReEj2ptBdWV7PwD4AYL6MUGqGaKcepO7/wu8fo9Nw4pB3PEdD6dtbNWeVuixMWo0ZOSMnNepZolsugde4JOPjEIw0vKbZdEFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbJ88WFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbJ88WFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120EA1F000E9;
	Tue, 21 Jul 2026 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670010;
	bh=qBODzCgZpSJx8J5ao0Gl2ZmVZ/pB1hPnIoWmdgM6E6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbJ88WFfgwXcyxRq5gdvh2bdg79ZfUQa1VBgUJ9Btg/KcLJ+A2SkJPPh1SCsza0uO
	 eqi+0oulV9gBSjEyUAcBYnh7mlg1pZ9ow6GIoXA+J4QrIgSuyxyOZnq5M9OMGQiggx
	 GQwngsSDo2AQ1h9Oh4gdIVntUtkN/eixrXAgiweY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0771/1067] batman-adv: frag: fix primary_if leak on failed linearization
Date: Tue, 21 Jul 2026 17:22:52 +0200
Message-ID: <20260721152441.819226994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -551,7 +551,7 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
 		ret = -ENOMEM;
-		goto free_skb;
+		goto put_primary_if;
 	}
 
 	/* Create one header to be copied to all fragments */


