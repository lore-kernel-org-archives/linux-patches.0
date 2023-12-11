Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CF94F212;
	Mon, 11 Dec 2023 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4yU185e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825D9C433C9;
	Mon, 11 Dec 2023 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702318896;
	bh=eP2Rm+wksTxgqGvBYSDRf1mrrJd4dJzvQemm9zOCIL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4yU185eZCJTJU3mhbVYjr2Ndz9ehca+rLQ7IeieWPcAx+M0NBwuJi+DdjCnetxc+
	 WYXXA7DTiIEEk5Ny5Bu6GzGXXXQ2namQV4GpHv2MMIRs5Pb/yRV/EB3dzsxGzcbeEf
	 8RuBttabNgV4+GU4LMsWu5YKQ+USftUFS8hupEpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Pakhunov <alexey.pakhunov@spacex.com>,
	Vincent Wong <vincent.wong2@spacex.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/25] tg3: Increment tx_dropped in tg3_tso_bug()
Date: Mon, 11 Dec 2023 19:20:53 +0100
Message-ID: <20231211182008.753768890@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182008.665944227@linuxfoundation.org>
References: <20231211182008.665944227@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Pakhunov <alexey.pakhunov@spacex.com>

[ Upstream commit 17dd5efe5f36a96bd78012594fabe21efb01186b ]

tg3_tso_bug() drops a packet if it cannot be segmented for any reason.
The number of discarded frames should be incremented accordingly.

Signed-off-by: Alex Pakhunov <alexey.pakhunov@spacex.com>
Signed-off-by: Vincent Wong <vincent.wong2@spacex.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20231113182350.37472-2-alexey.pakhunov@spacex.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 96c7a452a4a97..dc27c81ad5129 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7872,8 +7872,10 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 
 	segs = skb_gso_segment(skb, tp->dev->features &
 				    ~(NETIF_F_TSO | NETIF_F_TSO6));
-	if (IS_ERR(segs) || !segs)
+	if (IS_ERR(segs) || !segs) {
+		tnapi->tx_dropped++;
 		goto tg3_tso_bug_end;
+	}
 
 	do {
 		nskb = segs;
-- 
2.42.0



