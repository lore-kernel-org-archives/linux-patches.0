Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BC21FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191F4C433C8;
	Tue,  1 Aug 2023 09:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882399;
	bh=MeO4VOxWkoKF+a1dMi/IpGydodY8BNRvcxWDvkhcdO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KX+PjGwjig0IQRqikCpBYtQEZfYv2obSr3VQC/yEicizKKt0iUh6olFUX0IM88IXm
	 R2x4Qn90HnhDmjk5gZW7U4igmENdXtrv2wvTYc98X9kSeccPRoiOo0DVphdVRRjqSe
	 AOyOYGxwGOkPaAD7ijUHzwF/E0eIlUe5mlwvmkSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/228] atheros: fix return value check in atl1_tso()
Date: Tue,  1 Aug 2023 11:19:10 +0200
Message-ID: <20230801091926.172055684@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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

[ Upstream commit ed96824b71ed67664390890441b229423a25317f ]

in atl1_tso(), it should check the return value of pskb_trim(),
and return an error code if an unexpected value is returned
by pskb_trim().

Fixes: 401c0aabec4b ("atl1: simplify tx packet descriptor")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://lore.kernel.org/r/20230722142511.12448-1-ruc_gongyuanjun@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/atlx/atl1.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index c8444bcdf5270..02aa6fd8ebc2d 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2113,8 +2113,11 @@ static int atl1_tso(struct atl1_adapter *adapter, struct sk_buff *skb,
 
 			real_len = (((unsigned char *)iph - skb->data) +
 				ntohs(iph->tot_len));
-			if (real_len < skb->len)
-				pskb_trim(skb, real_len);
+			if (real_len < skb->len) {
+				err = pskb_trim(skb, real_len);
+				if (err)
+					return err;
+			}
 			hdr_len = skb_tcp_all_headers(skb);
 			if (skb->len == hdr_len) {
 				iph->check = 0;
-- 
2.39.2



