Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DDC175A6B;
	Mon, 17 Aug 2026 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977688; cv=none; b=Lx55brzxLakLp9NXpadElZ6Hblgdy3WP8/74h8Au9DXJjYiepR3lgLNYuFRjLHWNCbBg5XQ8x1RoNuaep4uCn1Jky+WU+m1aWc1gGpJ2YJNQ5poDMGhjCn51D+GQOYafF3ssnUZ+1L039qjhB5svu1WxaWEGbM9KZCU6/VuJprY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977688; c=relaxed/simple;
	bh=m+SVT2zEHfW+WcVrqkwb9/HNdBCgWjgBP1Oh/KMzE8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRTmUmVelhG4icdU/wFkkj1MBe4cGQJLdLCMSL1YKE7K04TFyIOfw7Vm7JrxAJZTg975gTRoDL68ZVL8ZeAzClMI9XiBhWRK4EJ0iIQBS8xDJbRiUbtRvZBg3aIweQ4i7MqXGkvyev69DacBuZwmd8p1G32Tfr6zKQUmbOSkRPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/xix8cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/xix8cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F139A1F000E9;
	Mon, 17 Aug 2026 14:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977687;
	bh=ZBHgDIIPwe+CCmI7ZxuIPvNjEJnhn+RhOUnX5BuEEEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/xix8cmaoQKcZAleLEBSFExUky10S9JZhLqvmpG3xEPDdyVQs2JlhkcyFRdY1lia
	 L6+gkDHnf0EUyUhCU118eAqkMe1iAakU0hX0TqjMiK0WH/QeqbfOxiPiX8AZTbyq79
	 /aOb4O2G8jwRASOEoPguOGp1482SLzTT3dAN1u5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Baul Lee <baul.lee@xbow.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 415/456] net: bridge: mrp: fix uninitialised bytes on the wire
Date: Mon, 17 Aug 2026 15:33:25 +0200
Message-ID: <20260817132555.464280132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


