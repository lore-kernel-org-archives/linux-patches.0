Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA623C5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3Wy+b2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEAEC433C9;
	Mon, 23 Oct 2023 11:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060691;
	bh=WOahAUSTnltw/Bb/qqFXCdZ9lsAR9AuwGfZWRQfh4tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3Wy+b2F8L8IKLuZPEdO9+PbnQYJMugRUPVydjv8RrATAYvEA0OpKFeFlOI5qWULw
	 PLFdPFjDllU7L5ZfRPSn0yxBHmfjzBy+WhXzGS7mXYhrDSMg/t9ntd2jUzbMREGK7W
	 Q13bpLKAj1/AUVLp1H/xSYU3qf1rRQzOeBvcgRW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 060/123] net: ipv4: fix return value check in esp_remove_trailer
Date: Mon, 23 Oct 2023 12:56:58 +0200
Message-ID: <20231023104819.701114894@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

commit 513f61e2193350c7a345da98559b80f61aec4fa6 upstream.

In esp_remove_trailer(), to avoid an unexpected result returned by
pskb_trim, we should check the return value of pskb_trim().

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/esp4.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -567,7 +567,9 @@ static inline int esp_remove_trailer(str
 		skb->csum = csum_block_sub(skb->csum, csumdiff,
 					   skb->len - trimlen);
 	}
-	pskb_trim(skb, skb->len - trimlen);
+	ret = pskb_trim(skb, skb->len - trimlen);
+	if (unlikely(ret))
+		return ret;
 
 	ret = nexthdr[1];
 


