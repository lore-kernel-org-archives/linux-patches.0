Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F75017AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECB7C433C8;
	Wed,  9 Aug 2023 11:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580220;
	bh=Dx+GMRpnrb+FWn6zG/ZfBmQbicBDDcI1nE4EX4LqUOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNQgf71woJheqqDbU985oDlh7dHBjtCfmt4+gOmmliKUtAyQ1vknibLy1IHgvP4ev
	 SLY1APXR0y+0KHKiKEdD9t7B6ylXvtiJPvGGQzOAcgb2W+eZqHuOEBfbvrbeA8dOCF
	 oJ/qcNOAYp4WDMlpzqQ8ryesaYsBgLCoe0wDEuD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 240/323] ethernet: atheros: fix return value check in atl1e_tso_csum()
Date: Wed,  9 Aug 2023 12:41:18 +0200
Message-ID: <20230809103709.061790819@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 69a184f7a372aac588babfb0bd681aaed9779f5b ]

in atl1e_tso_csum, it should check the return value of pskb_trim(),
and return an error code if an unexpected value is returned
by pskb_trim().

Fixes: a6a5325239c2 ("atl1e: Atheros L1E Gigabit Ethernet driver")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230720144219.39285-1-ruc_gongyuanjun@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 3164aad29bcf8..e4d58c7aeaf82 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1651,8 +1651,11 @@ static int atl1e_tso_csum(struct atl1e_adapter *adapter,
 			real_len = (((unsigned char *)ip_hdr(skb) - skb->data)
 					+ ntohs(ip_hdr(skb)->tot_len));
 
-			if (real_len < skb->len)
-				pskb_trim(skb, real_len);
+			if (real_len < skb->len) {
+				err = pskb_trim(skb, real_len);
+				if (err)
+					return err;
+			}
 
 			hdr_len = (skb_transport_offset(skb) + tcp_hdrlen(skb));
 			if (unlikely(skb->len == hdr_len)) {
-- 
2.39.2



