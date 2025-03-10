Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DC2156861;
	Mon, 10 Mar 2025 18:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630915; cv=none; b=TaHvP5Yf2urhNOTxuJGt/RDDAjU7VK2w3wJJUebPThACX7QCtTeDnWNLeMdM6c+NDsyWMoYg0kwDEcjnhCwF9ww+FrXs+nU1lYUewARRPvRsiKp48mIzfxz3ihSAhZxZCkB2Tudv+phsnP258hh9kzgAO6A90RXXQ4nllXDGd1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630915; c=relaxed/simple;
	bh=4V79ixrOHDd2/gbG2iveDW2pk9gPTJlvK1wkdc2QTmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWWAimj7PSbOXpPJ5LOewJ8urHf6cICRXhmrFuWwfMevfq825pUIymfJco9y9xvswkAk9H9GLutzM7Vhhnnvo2du4Szd06OCaTIuEiraQUaqbAxPaNnZqIUZvput4LsO/azIo8liLHYboNfnd10aCWr2iai3Ihnmx9vBMPjRcN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xX1C3G71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xX1C3G71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B00AC4CEE5;
	Mon, 10 Mar 2025 18:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630915;
	bh=4V79ixrOHDd2/gbG2iveDW2pk9gPTJlvK1wkdc2QTmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xX1C3G713hn4vlXRqi7A1WEc2eK7h99htww+dK0D3G+wQuK2fwNFpD7rkN1DrNUdB
	 0D9604JffBWzexfuxfNxg61hgtqU2YMkMykUiR6uMLm1k4DuIqTzeSKoNzYPRXC/z8
	 Kb1Suo2ju7Rh1ctM57C4sxD0UeHQoIH/MPqr7uCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 578/620] net: ipv6: fix missing dst ref drop in ila lwtunnel
Date: Mon, 10 Mar 2025 18:07:04 +0100
Message-ID: <20250310170608.355257302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 5da15a9c11c1c47ef573e6805b60a7d8a1687a2a ]

Add missing skb_dst_drop() to drop reference to the old dst before
adding the new dst to the skb.

Fixes: 79ff2fc31e0f ("ila: Cache a route to translated address")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250305081655.19032-1-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_lwt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index 6d37dda3d26fc..7397f764c66cc 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -96,6 +96,7 @@ static int ila_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
+	skb_dst_drop(skb);
 	skb_dst_set(skb, dst);
 	return dst_output(net, sk, skb);
 
-- 
2.39.5



