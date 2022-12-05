Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E51815C85
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A828C433C1;
	Mon,  5 Dec 2022 19:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269201;
	bh=4RdZk0Hp+hv423qFCqowbEDXoDRduCPob01/jzZO3kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFQ7nDJTXDGI0KTRFkGbqZX2Z41/nEy4RL+2/6NUC429EAqAtXyV2gxbVmtnkEXJp
	 SYcWoqzrn+oKazEZTsa2P6evY8j5nJhr75tq0ixTuh4TJJoos5zhwarZIW/NBJBEE/
	 PZ0ZSJoc/ywxCF2Hutm+g0pas+7o/G7WPqoLuZOA=
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
Subject: [PATCH 5.4 040/153] nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
Date: Mon,  5 Dec 2022 20:09:24 +0100
Message-Id: <20221205190809.872586789@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

[ Upstream commit c60c152230828825c06e62a8f1ce956d4b659266 ]

The first validation check for EVT_TRANSACTION has two different checks
tied together with logical AND. One is a check for minimum packet length,
and the other is for a valid aid_tag. If either condition is true (fails),
then an error should be triggered. The fix is to change && to ||.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Reviewed-by: Guenter Roeck <groeck@google.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index f25f1ec5f9e9..75f9a754b7eb 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -327,7 +327,7 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-- 
2.35.1



