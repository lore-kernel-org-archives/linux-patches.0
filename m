Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402B21360
	for <patches@lists.linux.dev>; Thu, 24 Feb 2022 03:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=pADByy9hHSCm6K1PtULkC4wcb5MipbuML4dpuyav+nM=; b=TKPlMNU3PLvsBPnIQZ69Bkt419
	neAuLTNybqugK8Q7ym1gCtfQEf8XVAF5V2Pa28Rj4p2iEctE5woJJ42cmOXSdIxGJcIVKUov4QALO
	XhsX5wCbw7Uv2QuFSd45Df/XstAQdYz1kH6kT2RUl41Yx8sQN6zaSO9bgITrlgFnLXqR9waa1AQ7e
	xpLNnF1ecdveBGecP6UNIF5BheSatOAAK9exKhrk0r7HsnbYp6EyV5ev2iDHFpWKFHUKOePX9mNEx
	yXfuyXCoub6q0k1oKRWKr90zX91FOKt2YpTCqRLtCYO1lniyvxj2AdKIDwLfZR76WY+s3aDcXp0e2
	sNgcXUlQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nN4um-00GeG7-Tf; Thu, 24 Feb 2022 03:35:37 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <i.zhbanov@omprussia.ru>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: stmmac: fix return value of __setup handler
Date: Wed, 23 Feb 2022 19:35:36 -0800
Message-Id: <20220224033536.25056-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__setup() handlers should return 1 on success, i.e., the parameter
has been handled. A return of 0 causes the "option=value" string to be
added to init's environment strings, polluting it.

Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
Fixes: f3240e2811f0 ("stmmac: remove warning when compile as built-in (V2)")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20220223.orig/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ linux-next-20220223/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7414,7 +7414,7 @@ static int __init stmmac_cmdline_opt(cha
 	char *opt;
 
 	if (!str || !*str)
-		return -EINVAL;
+		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "debug:", 6)) {
 			if (kstrtoint(opt + 6, 0, &debug))
@@ -7445,11 +7445,11 @@ static int __init stmmac_cmdline_opt(cha
 				goto err;
 		}
 	}
-	return 0;
+	return 1;
 
 err:
 	pr_err("%s: ERROR broken module parameter conversion", __func__);
-	return -EINVAL;
+	return 1;
 }
 
 __setup("stmmaceth=", stmmac_cmdline_opt);
