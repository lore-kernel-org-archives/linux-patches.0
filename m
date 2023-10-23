Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689CB14F6A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QkoPjPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7697C433C7;
	Mon, 23 Oct 2023 11:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060160;
	bh=svQz0KNNSRy/u3jGLiIn6Hhzx8IEvXDbBQjoy1oYOTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QkoPjPgl2tTO59LeShEu322MSPGemH0M/DtBP/Hjn2DTBRF/ZXIDHI3pUMI0cWwy
	 pYM0GrBvgAC38G2MYggtYWttmORlAsJT4m3tenmb1iltee9vVDLoe9YR0Kdjcl89XX
	 Vhy7y1u/zxMvnyps2UhZpCOldunLPVSvRM3BPm+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.1 051/196] net: ipv4: fix return value check in esp_remove_trailer
Date: Mon, 23 Oct 2023 12:55:16 +0200
Message-ID: <20231023104829.967297421@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -732,7 +732,9 @@ static inline int esp_remove_trailer(str
 		skb->csum = csum_block_sub(skb->csum, csumdiff,
 					   skb->len - trimlen);
 	}
-	pskb_trim(skb, skb->len - trimlen);
+	ret = pskb_trim(skb, skb->len - trimlen);
+	if (unlikely(ret))
+		return ret;
 
 	ret = nexthdr[1];
 


