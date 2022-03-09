Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7897D647A
	for <patches@lists.linux.dev>; Wed,  9 Mar 2022 04:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=jcOa1LRX3JQP1QkMneFsh+4SO/+4XFe4JCS+9MIdFQw=; b=fwgl6UBp5SJ6NbyrPIaQA+gU7+
	DdbkZDgibon2wMT+BNCQ6X+ZW8V0AEvSs9bRrqYDmU4NzOFYYPtqwkQWCqHB0Ewnz3OZ9fLTWKpVa
	JUoTL/J4E2nlrTQimQ0RlC+/hKEUtN4IHRn2rs9TcmxJCvjMLp3ul1p/F+r1nvtvMfsB+v1FKuM59
	OQR4zpoWnaArz9fo5aigCjNiGQ3CP1jjbnw5fINK/gVXGdywkNxeaQlg/RP1v9cJ0Kj0CYZlYmJSr
	tyaO6VEnoC0H4jwNLw3JwB/pNH5BY8rpcs5s3eduLQYf5Q7J0bqNY6OaZapo94wRN2xKGFkiapZaE
	fyAjQhjw==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nRnXS-007DKb-O8; Wed, 09 Mar 2022 04:03:02 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	John Stultz <john.stultz@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH] clocksource: acpi_pm: fix return value of __setup handler
Date: Tue,  8 Mar 2022 20:03:01 -0800
Message-Id: <20220309040301.25087-1-rdunlap@infradead.org>
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
kernel parameter and added to init's (limited) environment strings.

The __setup() handler interface isn't meant to handle negative return
values -- they are non-zero, so they mean "handled" (like a return
value of 1 does), but that's just a quirk. So return 1 from
parse_pmtmr(). Also print a warning message if kstrtouint() returns
an error.

Fixes: 60e3bf14d4e2 ("clocksource: clean up parse_pmtmr()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
From: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
---
 drivers/clocksource/acpi_pm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-next-20220308.orig/drivers/clocksource/acpi_pm.c
+++ linux-next-20220308/drivers/clocksource/acpi_pm.c
@@ -229,8 +229,10 @@ static int __init parse_pmtmr(char *arg)
 	int ret;
 
 	ret = kstrtouint(arg, 16, &base);
-	if (ret)
-		return ret;
+	if (ret) {
+		pr_warn("PMTMR: invalid 'pmtmr=' value: '%s'\n", arg);
+		return 1;
+	}
 
 	pr_info("PMTMR IOPort override: 0x%04x -> 0x%04x\n", pmtmr_ioport,
 		base);
