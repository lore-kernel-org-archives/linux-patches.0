Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F5763A8
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3JM9wA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBE0C433C8;
	Mon, 23 Oct 2023 11:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061858;
	bh=VyyBvpasvmIWvin6KnPex7WifGhdiyDpBUzFeOLj/J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3JM9wA6Kv+fSrFwJeEe39/n9nrjvCi7FbGMZfy1kvlUtpTwz7M2nwCKaAFRW8DHE
	 B28CV3OYPswu1oDD5SLhgwUKLXu/eCRijt9Ws1y3DKHQHpYUisK3hq1Y0zt4PHA5fN
	 2voyB2ZcfhpJ4m4t5VZBhVohkLyxgC72DSknveDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 181/202] Revert "pinctrl: avoid unsafe code pattern in find_pinctrl()"
Date: Mon, 23 Oct 2023 12:58:08 +0200
Message-ID: <20231023104831.750000821@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 62140a1e4dec4594d5d1e1d353747bf2ef434e8b upstream.

The commit breaks MMC enumeration on the Intel Merrifield
plaform.

Before:
[   36.439057] mmc0: SDHCI controller on PCI [0000:00:01.0] using ADMA
[   36.450924] mmc2: SDHCI controller on PCI [0000:00:01.3] using ADMA
[   36.459355] mmc1: SDHCI controller on PCI [0000:00:01.2] using ADMA
[   36.706399] mmc0: new DDR MMC card at address 0001
[   37.058972] mmc2: new ultra high speed DDR50 SDIO card at address 0001
[   37.278977] mmcblk0: mmc0:0001 H4G1d 3.64 GiB
[   37.297300]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10

After:
[   36.436704] mmc2: SDHCI controller on PCI [0000:00:01.3] using ADMA
[   36.436720] mmc1: SDHCI controller on PCI [0000:00:01.0] using ADMA
[   36.463685] mmc0: SDHCI controller on PCI [0000:00:01.2] using ADMA
[   36.720627] mmc1: new DDR MMC card at address 0001
[   37.068181] mmc2: new ultra high speed DDR50 SDIO card at address 0001
[   37.279998] mmcblk1: mmc1:0001 H4G1d 3.64 GiB
[   37.302670]  mmcblk1: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10

This reverts commit c153a4edff6ab01370fcac8e46f9c89cca1060c2.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231017141806.535191-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/core.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1007,20 +1007,17 @@ static int add_setting(struct pinctrl *p
 
 static struct pinctrl *find_pinctrl(struct device *dev)
 {
-	struct pinctrl *entry, *p = NULL;
+	struct pinctrl *p;
 
 	mutex_lock(&pinctrl_list_mutex);
-
-	list_for_each_entry(entry, &pinctrl_list, node) {
-		if (entry->dev == dev) {
-			p = entry;
-			kref_get(&p->users);
-			break;
+	list_for_each_entry(p, &pinctrl_list, node)
+		if (p->dev == dev) {
+			mutex_unlock(&pinctrl_list_mutex);
+			return p;
 		}
-	}
 
 	mutex_unlock(&pinctrl_list_mutex);
-	return p;
+	return NULL;
 }
 
 static void pinctrl_free(struct pinctrl *p, bool inlist);
@@ -1129,6 +1126,7 @@ struct pinctrl *pinctrl_get(struct devic
 	p = find_pinctrl(dev);
 	if (p) {
 		dev_dbg(dev, "obtain a copy of previously claimed pinctrl\n");
+		kref_get(&p->users);
 		return p;
 	}
 


