Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC4F1E98EF;
	Sun,  7 Jun 2026 10:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829005; cv=none; b=awMuVAwIhfgyFXaBl0+g/dSEq2Fl1mtOgLYd7Jm1s/v8ZPEu3+X84627YJSWb0qirOc5U4z3IHnJDXFtzpbWBCcL6KsFrwPmet84HngymPkLuNlTARV//k3sEb1uaoK8t578qLpCzoi2oICXdfWz88gejh5hQxV2XIHYlHcu24I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829005; c=relaxed/simple;
	bh=I6Bdj8AD4V+I79JZ6o6IMig3jQSYDrWCd6vrjAg64PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVLitEw3eK4wjmttCU5xf+7xIv6/p5ei/GPXxYjjqawh05V5rU/dBcl+BGF5PvpLIfRONknIbSBP3fZ8k6DXvScPeH7m5f0dB7VKjAj6WTlyFQRSa1+M3Zuw7+H7hI37kBKxdNDicF3BqVkW5lolQGym2S4Awfhj6/h9WEgZnbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOQeZY3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOQeZY3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF811F00893;
	Sun,  7 Jun 2026 10:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829004;
	bh=+zcdGxaVN+HhNRTQb+8BSXcA5WHGH8Mx0aDcFbExOCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOQeZY3k4B97fcxGF4UjQzi1V5ulgSt/DvF+i/f3dfW6pxviHyFudlaQwb2HFDfA7
	 fWOe7reFflBYZBQ7lS2ZpQtMlH2he6NWlTlnnlk2u92cys+EA9ifxr1sJhSTtJmR+y
	 KcmxJmz8Y8zCf4W97RrnB0NBkNLbc3/EaaiUTpRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 186/307] ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()
Date: Sun,  7 Jun 2026 11:59:43 +0200
Message-ID: <20260607095734.549260978@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -184,6 +184,8 @@ static bool ip6_parse_tlv(bool hopbyhop,
 				case IPV6_TLV_JUMBO:
 					if (!ipv6_hop_jumbo(skb, off))
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 				case IPV6_TLV_CALIPSO:
 					if (!ipv6_hop_calipso(skb, off))


