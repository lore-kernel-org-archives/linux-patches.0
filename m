Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FD96FBD
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51151C433D7;
	Wed, 30 Nov 2022 18:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832915;
	bh=9xTXb2yhB4Wuygg0fvBxzrDmnQ/4y28Si1owxgAxoq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZYR0eRB1XJTAogG5ROICCtVffeK0hvlDf9p89W2h9rDuCJR3FpWDzucIS1FXOFXO
	 plPudJW4uPj3fTny/ZOynM1f3TNDB1FzPEIQFhHjwDw+LePkyiOyPkNYs3u7DB7RPI
	 klbzbJwdXi2WjWyXwtFO/w29wr08u2FR88ZyD544=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Efremov <denis.e.efremov@oracle.com>,
	Guenter Roeck <groeck@google.com>,
	Martin Faltesek <mfaltesek@google.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/162] nfc: st-nci: fix memory leaks in EVT_TRANSACTION
Date: Wed, 30 Nov 2022 19:22:47 +0100
Message-Id: <20221130180530.827760286@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Faltesek <mfaltesek@google.com>

[ Upstream commit 440f2ae9c9f06e26f5dcea697a53717fc61a318c ]

Error path does not free previously allocated memory. Add devm_kfree() to
the failure path.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Reviewed-by: Guenter Roeck <groeck@google.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/se.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index b1ee5a38f964..37d397aae9b9 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -340,8 +340,10 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 
 		/* Check next byte is PARAMETERS tag (82) */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
 		memcpy(transaction->params, skb->data +
-- 
2.35.1



