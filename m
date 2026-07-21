Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA8142DFEC;
	Tue, 21 Jul 2026 22:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674241; cv=none; b=WF1i+U4XLkwW7gYiHyfMkNGQRq5aQIlAuW+lbp9XXFmBSyoPT0Cc7Ijv/0p6LLDdovMPWOzTYG/U/0Hx3zgldg2Uywhli0OWvKhMHn7JojoVCYygSExPD3MenSJz7ojOwaGFQc4OtTWG7Onwu1r2sT3we1VBzllOeXqkZVYbEOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674241; c=relaxed/simple;
	bh=+UgHsAKpmF9g9BAhcfJKisL4vdPcm8QAMVj47K2HaAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iS5u8BCK42rRL52dWTLXa/iIUsZJm+149fUKutp8V7HBmYYKG/fb1NvrHkAiQoUT9mbJeONBKKhXRCyndUVWPAD8fVWceUSgmPIrwsjAxcQLaA789D50KAdgyB9iFAeIRGoz4XqSPoa2YWjrhiex8QeJbEbDVfPO4oBGy/ngrb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqlShRIv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqlShRIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C34B1F000E9;
	Tue, 21 Jul 2026 22:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674236;
	bh=RQpSEN7uZAoupcvQMYErV+xxn9a9S5tLgBD5pHTMWxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqlShRIvx1byCI31Ul36z9kBbr7P8CcBSlLTx7x3K5UaX7CqcOqx80ZvyHiw531Fr
	 aLokGHINxcnCoVutkbI7Jxic7+pkcp0BGuQFBmpHosqB195+evfKPrNFcoi1YtfLpd
	 tYHfqGHXtK7wY7EyiZ8ylu0wOwAp9evu3cUuOYlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 466/699] batman-adv: fix VLAN priority offset
Date: Tue, 21 Jul 2026 17:23:45 +0200
Message-ID: <20260721152406.206788765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -420,7 +420,7 @@ void batadv_skb_set_priority(struct sk_b
 
 	switch (ethhdr->h_proto) {
 	case htons(ETH_P_8021Q):
-		vhdr = skb_header_pointer(skb, offset + sizeof(*vhdr),
+		vhdr = skb_header_pointer(skb, offset,
 					  sizeof(*vhdr), &vhdr_tmp);
 		if (!vhdr)
 			return;


