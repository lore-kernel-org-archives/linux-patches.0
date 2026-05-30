Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71F3341AB8;
	Sat, 30 May 2026 17:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162458; cv=none; b=FoTj6VDqS5Ed4QiTKiOF96hcko9srMAoiAZgfesHFk7Qihzt4mr2LNJpKtRnDWy5gkDsXcE1nhHFIaVaKs3NKPIZ+aSlYp5sKJ3cd8tbCDsZdQB7V9lQ+atuIXJ5u+peqMsx9fp+SAUW17ZFudm3vqjdS9z6z0fdjCfX8ENw1mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162458; c=relaxed/simple;
	bh=bWIXNSN/bfG8/kbfZ9sfW+vc0JyitiGiaTyH8LPi+pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DLdyvejZyZ0nXQ7rnYLPuemwxWeJMt6wWIeF4zlLOIOfMJONW6cdyePBJNTLD6qJlechSDVY9H+Nlq80VxGY4hGnfEjGCs+x1sdS/RhceuCXnImzOwoIKXvQRbYy94jsKClfKCGt1Zzm7XAvdS6HvL3wrufIlcBNgy/j1eEoyjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwlZCJrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwlZCJrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3551F00893;
	Sat, 30 May 2026 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162457;
	bh=NJ70OBXakCeK3ZneqksRmXZ4wKPBmNtUBUMJ+fEtXZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwlZCJrtRY6EZMcCc90u9ADvEOAZPP4q5s09nwV/6xbGPIImdI9iya1c7fSFXEto8
	 9g7Wyk0mJRv8dAdkTpj35T41bbO/EhCo8CQo2gmrzKM5JVU3pbCdqTgMJGNClxpPRf
	 9suxVKI4f31abopQqYe/+caaPoO8w4WaiIMfQjYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Haarmann-Thiemann <eitschman@nebelreich.de>,
	Linus Walleij <linusw@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 927/969] net: ethernet: cortina: Drop half-assembled SKB
Date: Sat, 30 May 2026 18:07:31 +0200
Message-ID: <20260530160326.339786939@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Haarmann-Thiemann <eitschman@nebelreich.de>

[ Upstream commit b266bacba796ff5c4dcd2ae2fc08aacf7ab39153 ]

In gmac_rx() (drivers/net/ethernet/cortina/gemini.c), when
gmac_get_queue_page() returns NULL for the second page of a multi-page
fragment, the driver logs an error and continues — but does not free the
partially assembled skb that was being assembled via napi_build_skb() /
napi_get_frags().

Free the in-progress partially assembled skb via napi_free_frags()
and increase the number of dropped frames appropriately
and assign the skb pointer NULL to make sure it is not lingering
around, matching the pattern already used elsewhere in the driver.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Andreas Haarmann-Thiemann <eitschman@nebelreich.de>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260505-gemini-ethernet-fix-v2-1-997c31d06079@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index dbfcbdb8d751a..51108bf65845d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1498,6 +1498,11 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		gpage = gmac_get_queue_page(geth, port, mapping + PAGE_SIZE);
 		if (!gpage) {
 			dev_err(geth->dev, "could not find mapping\n");
+			if (skb) {
+				napi_free_frags(&port->napi);
+				port->stats.rx_dropped++;
+				skb = NULL;
+			}
 			continue;
 		}
 		page = gpage->page;
-- 
2.53.0



