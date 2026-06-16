Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC10A331A44;
	Tue, 16 Jun 2026 18:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635558; cv=none; b=inGh2M3+sum9qrdrKWEzWYVLDF73u15ZWO8XO7jY4bvRkTUC+S4FiN8hY32XGTZOB8lJvkMIFJWbxYqhD/CCwaS2c3oQ+nwPWCKul5pGWP0tWYkQX1eYXSNeQnags+D49jEUhiRp1u8w/pC7M0RAWvQU1KIw+DyJ2+/dCMSH30g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635558; c=relaxed/simple;
	bh=K9livzCbYihpEE/GXmzrT2URNp4J+43vcRgvrFdC48s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NU1joIj1CVZFhZEo0Uk5iijMz+/W5qyeVbTRDTaCgtnd9kf1vA7PSQZgxUOPu0B+5y2Etnbocxu1kDQtRcwOShUkm3EhQI+HNVioCSJMNotH8esrX9A1eoonWmT4ZM6+p5g+s+HRCQ0H8u5Uw2IGfvSsZVkKpsrxlDFYmzJluQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StCF6Yrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StCF6Yrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6D31F000E9;
	Tue, 16 Jun 2026 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635557;
	bh=UsTaJ98iTFRr6Nv5gT7A5eMvPECUItBWKcLTolF+CYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StCF6Yrq5hxrp0TXT1TQhWMBjKLAzmlyqRRPd65pB97uxhZwk/2nqxBkgPD/pfAbb
	 zpyn09c+siHu5VUtVd7dP7DI7MpXnXX3217QJJDBAN9088q94WdEe0UABGowYXIoPU
	 4++FMtMHULrhoehEZHgMPhcjwMiRvHeNr4mwEiC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 071/342] ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()
Date: Tue, 16 Jun 2026 20:26:07 +0530
Message-ID: <20260616145051.552189303@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Justin Iurman <justin.iurman@gmail.com>

commit d47548a36639095939f4747d4c43f2271366f565 upstream.

ipv6_hop_jumbo() calls pskb_trim_rcsum(), which can change skb pointers.
Let's recompute nh pointer to make sure any change won't mess things up.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260522112013.12342-1-justin.iurman@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -180,6 +180,8 @@ static bool ip6_parse_tlv(const struct t
 					   func(). */
 					if (curr->func(skb, off) == false)
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 				}
 			}


