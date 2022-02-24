Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640F2ED6
	for <patches@lists.linux.dev>; Thu, 24 Feb 2022 03:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=5qVRiRQ1fakGyuNc8Z/9WokyXr4VLcs48iNwvOhGg5Y=; b=jQVw/wnj442gAYHJ/eszf18JSF
	3v2qrRq2flYc3JuwkpHs8YIKXrL1k1yXWu2rAerj0s4WIcfWtsGh4PjYeCisQG92NrQwarCVDt7MX
	OkZQ/6Xa7DsX6LHX6crmUuJWmKXaXLBcUYjj8sMwl7XgagkrHyMR32OTXKYLHGA/4ya9Wc4my5SJU
	0KR59LQbSd+rBPnCNnBzRE7yyM2S0L+hGQmIpVJGU1ZZx8oZ1D+gzQOhGv62rQrqofnHRyPgfBIRv
	KGLoVWCPTdyFwHm0479o9snZDvomVjJ/yYzo8wGQazRSVgpt3lAkqnSfFhqMX6HVrYE9KSFJrDERN
	LMUIUVvQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nN4uf-00GeED-4V; Thu, 24 Feb 2022 03:35:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <i.zhbanov@omprussia.ru>,
	Siva Reddy <siva.kallam@samsung.com>,
	Girish K S <ks.giri@samsung.com>,
	Byungho An <bh74.an@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: sxgbe: fix return value of __setup handler
Date: Wed, 23 Feb 2022 19:35:28 -0800
Message-Id: <20220224033528.24640-1-rdunlap@infradead.org>
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

Fixes: acc18c147b22 ("net: sxgbe: add EEE(Energy Efficient Ethernet) for Samsung sxgbe")
Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Siva Reddy <siva.kallam@samsung.com>
Cc: Girish K S <ks.giri@samsung.com>
Cc: Byungho An <bh74.an@samsung.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20220223.orig/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ linux-next-20220223/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2285,18 +2285,18 @@ static int __init sxgbe_cmdline_opt(char
 	char *opt;
 
 	if (!str || !*str)
-		return -EINVAL;
+		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "eee_timer:", 10)) {
 			if (kstrtoint(opt + 10, 0, &eee_timer))
 				goto err;
 		}
 	}
-	return 0;
+	return 1;
 
 err:
 	pr_err("%s: ERROR broken module parameter conversion\n", __func__);
-	return -EINVAL;
+	return 1;
 }
 
 __setup("sxgbeeth=", sxgbe_cmdline_opt);
