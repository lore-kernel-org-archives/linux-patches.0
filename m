Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816443B38A9;
	Mon, 17 Aug 2026 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978100; cv=none; b=MU+tJVQKDW2+uHZ70jS8mGR5Vbtf4YlsUeUktUix/sHD2N+ulzCNajV44JQCs2PzZUIXpdfZFJXc7b4NMsTvgIEWEMxZ9lvugUYNbw2sUbX1WsOdXXXZeDHcDQ6vKNw8CGopN/cbSiZcjR9hsUo6v5J7Z1oPveE2SHaogb4HQeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978100; c=relaxed/simple;
	bh=sooyQzVoptQVZ9PocjNfV8D6E14vZH0OrgtUFyZzyho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj2MPJRH2hXfykrREFXVCqUl45tkUNELCXQqA76tUCuFzoMNJP9j5+y2cU4mqz+9H7yQRPTuQiy56ErAcgVVYNQa5jC7nfrc0/iouJHvlp0P3gRfBKeTczAr7L1J/xdUEVEQ4lpEylHZ07tDnRXjSKgCiP1FeMCO2CvzzlPGj9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veAnpo/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veAnpo/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBAA1F000E9;
	Mon, 17 Aug 2026 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978099;
	bh=Pi4ScVHgpLFYbiWwxz/peUcxRmTqw/AO8wrZCYvqJAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veAnpo/dwELyy1C8H2ahEOc016ajNc6nxxPPOBhvlj4jbO8C7Q69UEMpM/ilycEwB
	 maUoet9+sd5b8m0S/3Y6LiR9E2vqW8hEUBm771weSHLV2athNgKGUoroPcbhcNSCO2
	 PhI8EK7w7j34+8jngO4TD4E2S5e0E/6IRtk7VoA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Baul Lee <baul.lee@xbow.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 101/181] net: bridge: mrp: fix uninitialised bytes on the wire
Date: Mon, 17 Aug 2026 15:33:15 +0200
Message-ID: <20260817132539.444823155@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

commit 63488dba65ef91373ef616575b32eb0eb21459f4 upstream.

br_mrp_alloc_test_skb() builds MRP test frames on an skb from
dev_alloc_skb(), which does not clear the linear data area.  On the MRA
ring-role branch the sub-option TLV header is appended with

	sub_tlv = skb_put(skb, sizeof(*sub_tlv));
	sub_tlv->type = BR_MRP_SUB_TLV_HEADER_TEST_AUTO_MGR;

so sub_tlv->length is never written, and the two trailing alignment bytes
are appended with a bare skb_put() that does not clear them either.  The
neighbouring oui and sub_opt regions are explicitly zeroed, so three
uninitialised bytes are left in every MRA MRP_Test frame that goes out.

Put the sub-option TLV header and the alignment padding in a single
skb_put_zero(), which clears both.  The AUTO_MGR sub-TLV carries no
payload, so the zeroed length field is already the value it should have.

Fixes: f7458934b079 ("net: bridge: mrp: Update the Test frames for MRA")
Suggested-by: Nikolay Aleksandrov <razor@blackwall.org>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260729131941.10254-1-baul.lee@xbow.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_mrp.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -224,11 +224,9 @@ static struct sk_buff *br_mrp_alloc_test
 		sub_opt = skb_put(skb, sizeof(*sub_opt));
 		memset(sub_opt, 0x0, sizeof(*sub_opt));
 
-		sub_tlv = skb_put(skb, sizeof(*sub_tlv));
-		sub_tlv->type = BR_MRP_SUB_TLV_HEADER_TEST_AUTO_MGR;
-
 		/* 32 bit alligment shall be ensured therefore add 2 bytes */
-		skb_put(skb, MRP_OPT_PADDING);
+		sub_tlv = skb_put_zero(skb, sizeof(*sub_tlv) + MRP_OPT_PADDING);
+		sub_tlv->type = BR_MRP_SUB_TLV_HEADER_TEST_AUTO_MGR;
 	}
 
 	br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_END, 0x0);


