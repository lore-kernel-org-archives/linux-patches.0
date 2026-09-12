Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF05333F59A;
	Sat, 12 Sep 2026 11:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213396; cv=none; b=DANoftLfUlSCc7LaGofU5EOItyaPML+wJCTiX11P8n+VrbKveZclBOmYZArb6luhNO7Xu88tybG7HXJNy9g69KwbO7HBOj1uXVYUNeHADNrtN2a1OTYU1vrriZ8jTssGbiXbKZtxJdSB1GQKp3onXTJBXRz04THmsdepN57pzX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213396; c=relaxed/simple;
	bh=ufOhqCbEm/t0J0uDyxUMan/Ka5g0yyydC9SomXhpXBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5Jd+Gh8z3ZMLraYr9dkQdnAB0ihJHpMVsv+6O19VZUSJe5AfXBPSL8dKIami6ffBKcBXxnc2bmWI1iSwdnWEuc9yIh1hStYBVJk7ofUCKKSvwnbbIhnWvCm6413GiJYytXoxjnUCMHCwUYptqtQf9lmBTrf3e1un7r/5UoeoYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Md8jbcTk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Md8jbcTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC0B1F000FF;
	Sat, 12 Sep 2026 11:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213395;
	bh=OOR1Z3nDsdJbJ7ul3HaN2yWjTaQ7Hh74REut7nPQYtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Md8jbcTksx1Fo0hj5IZu+2DkBmlkypQ3zGVJ1ZguPquhd5bnA9HIcw0xCNYkJ7Wfs
	 s7xy5rjTL7Q/dtoeqHUg9gf/e8Q4/EJPy7yQbE44RJ2OVIx88yVxL1g6CDTtl3KElK
	 ojoZtZoEE3YiUlZmZAh2W4P4PjV3NMEhrPU60HCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0113/1376] batman-adv: mcast: ensure unshared skb for multicast packets
Date: Sat, 12 Sep 2026 08:42:19 +0200
Message-ID: <20260912065610.073095030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

commit 82bf207f48ebb7a38157f1d91dac884fc9b8cfd8 upstream.

When a packet is transmitted via a batman-adv interface and has already
enough room for the header then nothing will make sure that the skbuff is
unshared. But it is not allowed to modify a currently shared skbuff.

Always make sure that the pskb_expand_head() is not only called for a too
small header but also for shared skbuffs.

Cc: stable@vger.kernel.org
Fixes: 90039133221e ("batman-adv: mcast: implement multicast packet generation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/multicast_forw.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -1100,8 +1100,7 @@ static int batadv_mcast_forw_expand_head
 		return -EINVAL;
 	}
 
-	if (skb_headroom(skb) < hdr_size &&
-	    pskb_expand_head(skb, hdr_size, 0, GFP_ATOMIC) < 0)
+	if (skb_cow(skb, hdr_size) < 0)
 		return -ENOMEM;
 
 	return 0;


