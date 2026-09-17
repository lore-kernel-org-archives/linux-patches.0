Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BBF411FA8;
	Thu, 17 Sep 2026 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670646; cv=none; b=Pgbj2F9MWgHry0toubQ1uPOAkvVgbCFAq+Wzl62YImhwrZPJOuhLuljX/W8AM7I47/sdtoSeqDdqurQ5N7VKbOO1LdIIH+Ej+GJTeQ0p2geofvUUbGH1cxKADmCFk3gF96V/WmRAYRy7zKNapVauVpRztTVAv6Ty2uEJoBbdXFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670646; c=relaxed/simple;
	bh=Qzh0BFQ8RYOmH4Si0AeXhm0yujykQlacS1oP3IhrbU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoZqjwFWefeudy4E2b9Zc+BO5JQpF6V016ZsnpRjI2C8IOo8IQOlqhvOmQVBmojr1JKPqdIBD2iSso9SBwdvBP0jzOY3BgMZffoC2rP+mcYAEBA2DUNLzMtmcF0zKKLDaD/FcZhW+du0pVEdQQFiFXe7SYfOMPfj/ueghaMKRHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnssUmJc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnssUmJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570211F000FF;
	Thu, 17 Sep 2026 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670645;
	bh=NmFdMVda1ssySyclkNN5efJj9KdeOMWMSWn4wp2mABI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnssUmJcAfVfSn0JObR4VRv9qqbtwBUIDNIHCPm4AVVIPJRlyAUjNMKjiUIXlzcMG
	 SHEZQ5AoVX9H/LMZEptGjDvgcsEwCTKNoEIfTytqd8GlCxG+9YNYIHafKctba8v6jM
	 DdfMWiQE3Iynng15p+7pt/hmaeYmOKdHhrg0rBsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0728/1102] net: ethernet: cortina: No mapping is a dropped rx
Date: Thu, 17 Sep 2026 16:11:11 +0100
Message-ID: <20260917151558.646426426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 2cb156213093a62b80cf40b1ec71738e93491971 ]

Increase stats.rx_dropped++ even if this is the first fragment
(skb == NULL) so we are doing proper accounting.

Fixes: b266bacba796 ("net: ethernet: cortina: Drop half-assembled SKB")
Link: https://sashiko.dev/#/patchset/20260505-gemini-ethernet-fix-v2-1-997c31d06079%40kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260509-gemini-ethernet-fixes-v1-1-6c5d20ddc35b@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 6520198c430c ("net: ethernet: cortina: Count RX drops once per frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 612b18ebbd251..35d90543b388d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1495,9 +1495,9 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		gpage = gmac_get_queue_page(geth, port, mapping + PAGE_SIZE);
 		if (!gpage) {
 			dev_err(geth->dev, "could not find mapping\n");
+			port->stats.rx_dropped++;
 			if (skb) {
 				napi_free_frags(&port->napi);
-				port->stats.rx_dropped++;
 				skb = NULL;
 				frag_nr = 0;
 			}
-- 
2.53.0



