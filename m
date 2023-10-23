Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B39125CA
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7s68Wbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110D1C433C8;
	Mon, 23 Oct 2023 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058821;
	bh=Hz9gBX4NkWqm65S8ZP2PHR2F5X6KXh4H7sDMgjr5V7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7s68WbjT/cfb6pL5bXdRG8icU5TONpd8+df2e/4kFsmTF1cPMZDQMsPOEbsJdrpS
	 ChNNRz9wBJ7zoh5DXsWxfQdvpnwm8n03GPNU4k/yq251LgPpwKncXsiOo4wSiVZttc
	 I6Q540fo2BmtJoPKyqzLQisfLk8cz2mNMXmQejlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.14 38/66] net: ipv6: fix return value check in esp_remove_trailer
Date: Mon, 23 Oct 2023 12:56:28 +0200
Message-ID: <20231023104812.263433768@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

commit dad4e491e30b20f4dc615c9da65d2142d703b5c2 upstream.

In esp_remove_trailer(), to avoid an unexpected result returned by
pskb_trim, we should check the return value of pskb_trim().

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/esp6.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -499,7 +499,9 @@ static inline int esp_remove_trailer(str
 		skb->csum = csum_block_sub(skb->csum, csumdiff,
 					   skb->len - trimlen);
 	}
-	pskb_trim(skb, skb->len - trimlen);
+	ret = pskb_trim(skb, skb->len - trimlen);
+	if (unlikely(ret))
+		return ret;
 
 	ret = nexthdr[1];
 


