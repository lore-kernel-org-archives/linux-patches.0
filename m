Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A46630D3FF;
	Tue, 21 Jul 2026 20:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667153; cv=none; b=s7Uq4GOeJ2bKyLUDe63s/XQ5I2cz1h1HyxFZ7hM1+RH1oXOCW9WK8jyvSfN+Ym7QpA5fXHZ57LDCxJAH1dX62xGMh9ixsqlES8i/HNQEOJNI6qBS6JohlbH0aA3/+KhChg5NVGl/Wu5ioHBgNmfkqjPxRU+ysc5xf7ZnqhzZdMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667153; c=relaxed/simple;
	bh=xTfhfbssXJBW1AHAMvMrS9rbh1NiK7alxja/v2O9dPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Arv9goxQDcuZOrnul/PYMixmnu4j9ZbrD3OU2Dalxvb0kmCXkvNdw/37hI5cN18n6e3P45fyI9FX05KnBKG/0a1waKZVwkGNkzt+m2/XBD7fGBq563tdWmRFV2r6cwvWfjE1B8KPDvF40GSiZHHmObdj20UVOJOep+aBm2gPF5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDrBMHJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDrBMHJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05681F000E9;
	Tue, 21 Jul 2026 20:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667152;
	bh=bamkjT11fhJB7PAq51cZbSu/8zgrfcuUkPJd31w2te0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDrBMHJ74wsti7ebbSW2Cu+q0Sfm0RB63G7iElgLhGmwC5CjYFaBxoI0UgbxoUlw8
	 6F8Ejdn+hTNof8ljDjzXQMAAfMIx1F7JmVex0exY1uHd2wh5vqGhifIBDJsAfrKi1i
	 dOfVfOIWzogMjA2Ly/GIz2ZMsnUxwriPeK9WxYGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0952/1266] batman-adv: fix VLAN priority offset
Date: Tue, 21 Jul 2026 17:23:09 +0200
Message-ID: <20260721152503.130503224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit fdb3be00ba4dafa313e699d6b5b90d13f22f3f25 upstream.

The batadv_skb_set_priority() receives an SKB with the inner ethernet
header at position "offset". When it tries to extract the IPv4 and IPv6
header, it needs to skip the ethernet header to get access to the IP
header.

But for VLAN header, it performs the access with the struct vlan_ethhdr.
This struct contains both both the ethernet header and the VLAN header. It
is therefore incorrect to skip over the whole vlan_ethhdr size to get
access to the vlan_ethhdr.

Cc: stable@vger.kernel.org
Fixes: c54f38c9aa22 ("batman-adv: set skb priority according to content")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -375,7 +375,7 @@ void batadv_skb_set_priority(struct sk_b
 
 	switch (ethhdr->h_proto) {
 	case htons(ETH_P_8021Q):
-		vhdr = skb_header_pointer(skb, offset + sizeof(*vhdr),
+		vhdr = skb_header_pointer(skb, offset,
 					  sizeof(*vhdr), &vhdr_tmp);
 		if (!vhdr)
 			return;


