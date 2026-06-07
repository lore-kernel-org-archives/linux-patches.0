Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FD82C1595;
	Sun,  7 Jun 2026 10:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828811; cv=none; b=MCPOzzY8MVYv6QEy4BpFhxc8uMpjz0oftPu0YJmwH00ZTTVhW80Q6lE1SBNscEG4vGk/cYHogSRwcc6ehx0jYLDugQIgjlkRxvap9z0Uexs7m7R3aZMCDg65sA/i+q78gG2ZDh9tvq+YRd5z+5xghCNDOP66Bh7Cl6lztw7xbzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828811; c=relaxed/simple;
	bh=tLeRsDx9VCihsk06oXWs0sMJcbvcRfwcYfYGM8RL7JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcx+/4sxmCcwsAxV+qCv65DXwAXkoRHGHJ1QIV2bHobJQp33i/ZRd4crtIkQS+3fIFaC7YmphEBcid7F6ZioJNLpasGSHZl5Y6SwTRJMdEA84zSgAkvEhOcrC6G+pT+yGq2hzpAtQUGxX/quTiEulAEIyuJB2QzaxFmP8pZBnp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKc3aTrh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKc3aTrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CDE1F00893;
	Sun,  7 Jun 2026 10:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828810;
	bh=V66I3L1CUEz7T/aO1763HDu+55uy0rNYddolUnZA6cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKc3aTrhLwvWoFfiwaUtXOCLmGLcggRW0W2qMxwlQtsyFtoTedEu5cLTjYs3Oys2u
	 wPC1zxzxhQ1Zg5/5BJBcIzY3MgVhmm0h+Gh2Vk5+vCdP0f4QYDDtLeWVXS7KHJiSR/
	 r1dcgbw79L7WNhmgWBAtfTa2rUjYovMjtypqqvCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 211/332] ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()
Date: Sun,  7 Jun 2026 11:59:40 +0200
Message-ID: <20260607095735.818068605@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


