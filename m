Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5983F0A8C;
	Mon, 17 Aug 2026 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976360; cv=none; b=iMGNGxyAfpy9N3eN68uvoTCjHcMoBnl1RgfT/i5s32lOMlMyeyNvf/1RgnAQF16Z0d8YkMfSsRf0+A8hVzBaHzB/eNVp621vQcQ3uGZF8zoWtrB6cBlGRk3n5gbl8AQpSfwyQBxZmnJUDhMmcINTTWKrl09WhuSCNSg9HvqLZX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976360; c=relaxed/simple;
	bh=k9LHVxwDVrtkjB55ERm/UOk6hBwncl7UeFu5NTFXl5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etv4MVEz+HJ5wDMMjIauBL9rkGr5OmeWa1uFQ43Tz42kbw3dtn27qrSGnQFqEmSst4kfwpmKDH5mkE5cZWEnWT6XZabYN5zuN+nD0KmIIUQkZEnxIykZhigk4tbsj4/Jgjh3/SPfIQ+SokAbSC03gD2S1p0stWJulnnVrFHTXIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XB3SKgBi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XB3SKgBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243721F000E9;
	Mon, 17 Aug 2026 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976359;
	bh=6I1lgMu3jqfb0mOIQi865b+coRCDFRtkgqgJ1+oBnjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XB3SKgBirRygOXt5dxsFz8YMCp1xGYH2xxbl8glMqKCLmydmjf6sXUrH9DojEdWAP
	 tNIjn0IklEkFKN9X60a68RiX8BRyOfivQK1kutPjFf5CZyhnLUq+dicb8gOXm4lvDW
	 cQL0Lsnw/RwVyq0vE8Og6+rPYwAK4mGyiddni4gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 5.10 346/389] usb: gadget: f_ncm: Use unsigned int for ndp_index
Date: Mon, 17 Aug 2026 15:33:05 +0200
Message-ID: <20260817132552.303981103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -1183,7 +1183,7 @@ static int ncm_unwrap_ntb(struct gether
 	unsigned char	*ntb_ptr = skb->data;
 	__le16		*tmp;
 	unsigned	index, index2;
-	int		ndp_index;
+	unsigned int	ndp_index;
 	unsigned	dg_len, dg_len2;
 	unsigned	ndp_len;
 	unsigned	block_len;


