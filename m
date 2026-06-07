Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28261E98EF;
	Sun,  7 Jun 2026 10:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829001; cv=none; b=kz2c9Sf1Ipetzubr0ofzoruPzl/iXtC9shKXh0Whu99ndyFo00shC6pA8A5ThFzZsA4yv3LJ9n2OxQBPZef+CpUbHeoGVvqx9qO6DuPh6o8eSwYjQF0Bx7uWTH2zOGYvx19inZ2zERu74aj2GLWXHkfCY84UQmWjsnf9jU5/YV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829001; c=relaxed/simple;
	bh=hd7IMPv6Sacz5h7+/GpaMDk5V4M35okDHdvqrKkq4nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzM0e5DMH2pOuci9Lxs+FjsxKy7UhZZRlclUm25M6qzc7Vq00SFUa8a62Q2OMEW58NahMOWgCUTpU0HLTTpkAacutFcp9gs5mPDDpMxVol/15E4vtiVpfoAE92MnvZVgIcgzpHSwaMncSk0DgwEK3Rdvyk6YTz8oi31j8H87YD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNcJEBuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNcJEBuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3236A1F00893;
	Sun,  7 Jun 2026 10:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829000;
	bh=jwDCZCg5CCqdldXG4uwzsQbfKqdTu53eLXs4fPZvu24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNcJEBuwmMANY0a/P+72iqiIIYU+o3vSCqOa38QC+oHwbltpnpDMzKHf4VYRHqR8W
	 3ZMUMp2H3S3c2n1Ke9PPR/mnYGWdhHScFXVwiVlTM9fVlzrOMnH99skKDBWutqUhPE
	 CrIe8mUC1q1/W5ii1YrHppDWRfrk0+cAvAcZ2VRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <malin89@huawei.com>,
	Chenyuan Mi <michenyuan@huawei.com>,
	Jingguo Tan <tanjingguo@huawei.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.0 233/332] xfrm: esp: restore combined single-frag length gate
Date: Sun,  7 Jun 2026 12:00:02 +0200
Message-ID: <20260607095736.612695227@linuxfoundation.org>
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

From: Jingguo Tan <tanjingguo@huawei.com>

commit dfa0d7b0ff1eb6b2c416b8fdb9b4f2cefba57a40 upstream.

The ESP out-of-place fast path appends the trailer in esp_output_head()
before esp_output_tail() allocates the destination page frag. The
head-side gate currently checks skb->data_len and tailen separately, but
the tail code allocates a single destination frag from the combined
post-trailer skb->data_len.

Reject the page-frag fast path when the combined aligned length exceeds a
page. Otherwise skb_page_frag_refill() may fall back to a single page while
the destination sg still spans the combined skb->data_len.

Restore this combined-length page gate for both IPv4 and IPv6.

Fixes: 5bd8baab087d ("esp: limit skb_page_frag_refill use to a single page")
Cc: stable@vger.kernel.org
Signed-off-by: Lin Ma <malin89@huawei.com>
Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
Signed-off-by: Jingguo Tan <tanjingguo@huawei.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/esp4.c |    4 ++--
 net/ipv6/esp6.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -419,8 +419,8 @@ int esp_output_head(struct xfrm_state *x
 			return err;
 	}
 
-	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
-	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
+	if (ALIGN(skb->data_len + tailen, L1_CACHE_BYTES) >
+	    PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -448,8 +448,8 @@ int esp6_output_head(struct xfrm_state *
 			return err;
 	}
 
-	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
-	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
+	if (ALIGN(skb->data_len + tailen, L1_CACHE_BYTES) >
+	    PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {


