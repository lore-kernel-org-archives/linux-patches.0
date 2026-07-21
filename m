Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FFC3B7B6B;
	Tue, 21 Jul 2026 20:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667008; cv=none; b=sUgtebWkmFM+5SB/nqpeR7RYkeJ+rJxNboWogM1s71bxBGAmDeb+iEWYif1b+Ew0c48AncFdKen2Tq3NsKv4bkxrum+YaFDtjTY4yy4qFGaS9o+blG9emqf2XsasGygM1ciiSP3ZdWtAGKU8i5VLiwhHry3vq6FLIOH4wzh90Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667008; c=relaxed/simple;
	bh=E3BadIsidnu5mAwRy1HjBLsYQeMjmKuF0kwLrMpqQa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9yndl8fkGlJ4x4kZg3pzeDhbq5XDqwFFjivS5DaZr99lErjz6+oCgVGTCXD6PaFSuTuOnDIs+SNxZvPYx380y3fqAXb8hQN1XzLC1OdZsZRoFln8L7XfSwYm192hnT/pInGy661JEBb6iLoC34Oretv+yZmygr7mFHyRyhgAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+9AmJbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+9AmJbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6739C1F000E9;
	Tue, 21 Jul 2026 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667006;
	bh=RoQKmTXvJrwBKyVnue5r6prT6TZq2plpAiBiTOQGrwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+9AmJbsv8bExgyHqOXIdA4cKsRMoub8jldzP84uxRK2G/1CiNCjlXMYZ45yo2GED
	 1Dc1edmw4ZTz8vhAKPgx4Fx6hnkEj7aicRnkA1U7+LYWijzwNhXFmdfiiNJEyIYnsc
	 9HL9U/6r8z+yJ2dNGWiqTU2ljrhoB4cEMTCRlpuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yong Wang <edragain@163.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0898/1266] net: ife: require ETH_HLEN to be pullable in ife_decode()
Date: Tue, 21 Jul 2026 17:22:15 +0200
Message-ID: <20260721152501.943278798@linuxfoundation.org>
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

From: Yong Wang <edragain@163.com>

commit 9406f6012b7343661efb516a11c62d4db2b62f75 upstream.

ife decode may return after making only the outer IFE header and
metadata pullable. The caller then passes the decapsulated packet to
eth_type_trans(), which expects the inner Ethernet header to be
accessible from the linear data area.

With a malformed IFE frame, the inner Ethernet header may still be
shorter than ETH_HLEN in the linear area, which can lead to a crash in
the original code.

Fix this by extending the pull check in ife_decode() so that the inner
Ethernet header is also guaranteed to be pullable before returning.

Fixes: ef6980b6becb ("introduce IFE action")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yong Wang <edragain@163.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260610183814.1648888-2-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ife/ife.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ife/ife.c
+++ b/net/ife/ife.c
@@ -79,7 +79,7 @@ void *ife_decode(struct sk_buff *skb, u1
 	if (unlikely(ifehdrln < 2))
 		return NULL;
 
-	if (unlikely(!pskb_may_pull(skb, total_pull)))
+	if (unlikely(!pskb_may_pull(skb, total_pull + ETH_HLEN)))
 		return NULL;
 
 	ifehdr = (struct ifeheadr *)(skb->data + skb->dev->hard_header_len);


