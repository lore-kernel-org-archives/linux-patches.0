Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6D97E
	for <patches@lists.linux.dev>; Sat, 12 Mar 2022 06:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gF9Fh93eUmwlUNXUVNP+MriQszOUPD+2acN/4x71rMY=; b=SrcSNo3uj6Ms0K7AuiKX22hDYv
	WoLZyFYfurHm+zdI54AMhAryUKrIhWpPBk6c3myARPVsj7/Gap4VbQFaXVFKshizECBVuC9IvHrUi
	t8ruiE2eRseopsfm3sELLJqgXk1DxQDLttAs6L8WCU0axkupVK3NqgpRQXSA1vo6Mp7nKvdxOdhi7
	7aV0/Pkk4kWFpTFrAhFuGFxD8YYfs2E4A9DMvnfBcDHy9PMxSKNo41rmDXK8DxjNc8QqjPIID1P/X
	KS0lRX/xTGa4VXNOzP0cdgLRBRStgRywR68DfwtMnd71/MBqXJaNTO+3Hu/WKvnB13D0JnjRWRt6S
	rllj0vzQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nSvMI-000pzT-HM; Sat, 12 Mar 2022 06:36:10 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Ben Dooks <ben-linux@fluff.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	patches@armlinux.org.uk
Subject: [PATCH] ARM: JIVE: fix return value of __setup handler
Date: Fri, 11 Mar 2022 22:36:09 -0800
Message-Id: <20220312063609.19362-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from jive_mtdset().

Fixes: 9db829f485c5 ("[ARM] JIVE: Initial machine support for Logitech Jive")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: patches@armlinux.org.uk
---
KernelVersion: v5.17-rc7

 arch/arm/mach-s3c/mach-jive.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20220310.orig/arch/arm/mach-s3c/mach-jive.c
+++ linux-next-20220310/arch/arm/mach-s3c/mach-jive.c
@@ -236,11 +236,11 @@ static int __init jive_mtdset(char *opti
 	unsigned long set;
 
 	if (options == NULL || options[0] == '\0')
-		return 0;
+		return 1;
 
 	if (kstrtoul(options, 10, &set)) {
 		printk(KERN_ERR "failed to parse mtdset=%s\n", options);
-		return 0;
+		return 1;
 	}
 
 	switch (set) {
@@ -256,7 +256,7 @@ static int __init jive_mtdset(char *opti
 		       "using default.", set);
 	}
 
-	return 0;
+	return 1;
 }
 
 /* parse the mtdset= option given to the kernel command line */
