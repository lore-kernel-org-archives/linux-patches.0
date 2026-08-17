Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6640B418344;
	Mon, 17 Aug 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978087; cv=none; b=mOOdtk7DdkDmBtcWtZBzO1cWvjGKOvlJJqbxSNGXoWljUr6On4vMoMblnOGsGjkJP97t29JSPR0KdZNUNfD3xpF7JcPObi29ZYq6/TYL+u8XQNl/ZeeOsgVkEZub1faFLgJd/8yGWQnl3inmD3RWWiMtbQZayoo0xKb5oJ/K1Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978087; c=relaxed/simple;
	bh=0KwaqOfNghZqtAN9JIE/akhRpKGQkZTalHi3S/4EOgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTED8MxjX26vE6FH7wo3MX0KonY2MWx8DgmUXnCORHqw8dmAmlgQp9dPW+Vd9vt97D6RZY46QoraC9CnpQ4TLBX7igT4QIaVJXPmXtv3Zk022m4W2aoOXhpK2lBMpLRN5/La60Nbqy5FCYa/q47fDZ+clRlRvsZ97TSOCGsubjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYeBWxYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYeBWxYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3C81F00A3A;
	Mon, 17 Aug 2026 14:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978085;
	bh=KzcPSeg1TMz910JrW+BgsvPsNcmGbvcvVPuGarpX1SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYeBWxYnBnHyQxqrsEDMq/RGcCMMGXKtHhU8pNSGCvowupoPMTKu8309LyYN4OOa5
	 PV8ErjC+0Jsq6Y6OlCA2JPZ0Xs7Gr8kv6QM63odTwgZcG7BywCHF2phoyGKZYDDIbU
	 CX1gWj72AvDF1Y3LHGmFpMFdh6Dd325kBW3o01vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 6.12 079/181] usb: gadget: f_ncm: Use unsigned int for ndp_index
Date: Mon, 17 Aug 2026 15:32:53 +0200
Message-ID: <20260817132538.552286376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonali Pradhan <sonalipradhan@google.com>

commit 6b1c8a9403a26cb0fed7a648916c74dc236da591 upstream.

The variable ndp_index is declared as a signed integer, but it stores
the return value of get_ncm(), which is unsigned.

A malicious host can supply a large offset that overflows the signed
ndp_index, making it negative. Because ndp_index is compared against
unsigned bounds, this negative value bypasses sanity checks and leads
to an out-of-bounds read when calculating the address of the NDP
block (ntb_ptr + ndp_index).

Fix this by changing ndp_index to unsigned int to ensure consistent
unsigned comparisons throughout the function.

Fixes: 370af734dfaf ("usb: gadget: NCM: RX function support multiple NDPs")
Cc: stable <stable@kernel.org>
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260720165654.2224591-1-sonalipradhan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1171,7 +1171,7 @@ static int ncm_unwrap_ntb(struct gether
 	unsigned char	*ntb_ptr = skb->data;
 	__le16		*tmp;
 	unsigned	index, index2;
-	int		ndp_index;
+	unsigned int	ndp_index;
 	unsigned	dg_len, dg_len2;
 	unsigned	ndp_len;
 	unsigned	block_len;


