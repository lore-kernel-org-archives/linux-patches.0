Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DEC6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048EDC433EF;
	Mon,  3 Apr 2023 14:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532662;
	bh=JcILdQd0OmJT9lXLLAMILCz+XMba2aucdyQ7Wd+IxDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOFJakAsJvFsQVPNkKD+V9aLyj52EZtgtq1D3uVdZY+GGJmfFFAKwNkhQIYboKF+y
	 v7Zcpdtor5jxRiaWfDJ7hEaDwFcIjKHO4vpA7iC2kzVVALD44+6k2d8RY3Oa+GkARg
	 nFsxE60DoUQwgSjepbyZxFrxWI7djzFi1qSIiHiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Alexander Aring <aahringo@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/181] ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()
Date: Mon,  3 Apr 2023 16:08:24 +0200
Message-Id: <20230403140417.376562167@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 748b2f5e82d17480404b3e2895388fc2925f7caf ]

mac_len is of type unsigned, which can never be less than zero.

	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
	if (mac_len < 0)
		return mac_len;

Change this to type int as ieee802154_hdr_peek_addrs() can return negative
integers, this is found by static analysis with smatch.

Fixes: 6c993779ea1d ("ca8210: fix mac_len negative array access")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 0b0c6c0764fe9..d0b5129439ed6 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1902,10 +1902,9 @@ static int ca8210_skb_tx(
 	struct ca8210_priv  *priv
 )
 {
-	int status;
 	struct ieee802154_hdr header = { };
 	struct secspec secspec;
-	unsigned int mac_len;
+	int mac_len, status;
 
 	dev_dbg(&priv->spi->dev, "%s called\n", __func__);
 
-- 
2.39.2



