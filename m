Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BCE38655A;
	Tue, 21 Jul 2026 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654289; cv=none; b=nBWoVu9WsU0SnbWgIbCBsTa1qiAvHKhzjZp1D/vVCYUi4LXP4doLMch3AFmsf8oqSLi5BCdQPQoXzB6oWO/yv7H6iNzA0oDRxCbgYfHGUxxwbr8/wqKqEUN6cjWNW03EFFH+HHc+iSyF2kmQHPZuJHbGQGQY6otN0wIhPONhktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654289; c=relaxed/simple;
	bh=t94pq3TkgtOEmPp+RndesQ4LW18qgJIRHC7Ki950Mno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BD4G92iv32Cng3kY+sQmDod0jhDLKhLUSpxXxMSRdo9IrkqXs3wYR0wKEUzZn7WYsMybp/COiEN1aTQMSnoW1agE+uekqL4WrY0AuU7irg0bJpe8TlpxBkUY9amRdNuVb/ssxYTzJPseBOe6qY+B0p5pSK1m02/a7FHdEgnor9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8mSJ4aB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8mSJ4aB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B652C1F00A3A;
	Tue, 21 Jul 2026 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654288;
	bh=lM1/qdX2pjgaEAF1C8ko2XEaqfnFSb51mTZKQlPr1KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8mSJ4aBoFpcDqFWVbKdKqvB8wnTq1GHIvrZW82KzL+Q6Pj/3ZLCJ9XEDY7oBBKIr
	 WqzfkQ00vu9+Qlp3zJ0KlgZnPXNoJNfKew9z4YlU0fnD+Kp9auNy3JTwmbifQUiqc9
	 vq0knVX7Rez9gGtnp9eVyinGUNUnwjXsz4VIY2vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1647/2077] batman-adv: fix VLAN priority offset
Date: Tue, 21 Jul 2026 17:22:00 +0200
Message-ID: <20260721152631.597509997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -354,7 +354,7 @@ void batadv_skb_set_priority(struct sk_b
 
 	switch (ethhdr->h_proto) {
 	case htons(ETH_P_8021Q):
-		vhdr = skb_header_pointer(skb, offset + sizeof(*vhdr),
+		vhdr = skb_header_pointer(skb, offset,
 					  sizeof(*vhdr), &vhdr_tmp);
 		if (!vhdr)
 			return;


