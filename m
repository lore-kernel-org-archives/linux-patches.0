Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4B9221FAE;
	Tue, 29 Apr 2025 18:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950532; cv=none; b=a9FZZACfyvo5nWUpw616ZKKuUwd7EYW/dgq6/MGmn5Ds6dNnhcB3FEn10Y7pMMG12bIG/4Qfu2yk8xjxZtE20PCQfuTkTsM4iVDKFxVcFsi/20Ysm/TYb4fxdC6m+KvGWNd8gpfREkl5DpQzW2Fdn9FD4bdVoa24mw7269hxJAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950532; c=relaxed/simple;
	bh=rmkqtzDQzT0ZyeXp19ckIK08w1bvKezHDU9C2dMF+us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftgtppTn2KZGsiXW3gXWvVtkbglhurbZh20VCIpov62tl8YQvL1QSXT5CdXDaRryQo4FXretHGBMkeNH4fyTzXoM1+JmmKJTAs3vbdOYYT7FR5yKwXAqQ9v3bSDlDiI+VEFGMFvJV5h4tx0ANfnL03TVlvG22/ly2kwtSs/FBHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWbkq3Qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWbkq3Qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C218C4CEE3;
	Tue, 29 Apr 2025 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950532;
	bh=rmkqtzDQzT0ZyeXp19ckIK08w1bvKezHDU9C2dMF+us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWbkq3Qqwpz2DsEEdJ6fd6cFo70ZHGuLTJtW6VqUg+UV0DS6BdQnRlMY7KOM2cYTz
	 CCOvYF/V0jhbAivgmRp8DQfsG7AR1ZSFmD5M4aHYrNucnpTaJHl1GOZSQbYcTP21Q+
	 /YkFPinqGT4NT6ENhKkvZul/67qKAGHQB9ZH6j94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/204] s390/sclp: Add check for get_zeroed_page()
Date: Tue, 29 Apr 2025 18:43:32 +0200
Message-ID: <20250429161104.506069463@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 3db42c75a921854a99db0a2775814fef97415bac ]

Add check for the return value of get_zeroed_page() in
sclp_console_init() to prevent null pointer dereference.
Furthermore, to solve the memory leak caused by the loop
allocation, add a free helper to do the free job.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20250218025216.2421548-1-haoxiang_li2024@163.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/sclp_con.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index e5d947c763ea5..6a030ba38bf36 100644
--- a/drivers/s390/char/sclp_con.c
+++ b/drivers/s390/char/sclp_con.c
@@ -263,6 +263,19 @@ static struct console sclp_console =
 	.index = 0 /* ttyS0 */
 };
 
+/*
+ *  Release allocated pages.
+ */
+static void __init __sclp_console_free_pages(void)
+{
+	struct list_head *page, *p;
+
+	list_for_each_safe(page, p, &sclp_con_pages) {
+		list_del(page);
+		free_page((unsigned long)page);
+	}
+}
+
 /*
  * called by console_init() in drivers/char/tty_io.c at boot-time.
  */
@@ -282,6 +295,10 @@ sclp_console_init(void)
 	/* Allocate pages for output buffering */
 	for (i = 0; i < sclp_console_pages; i++) {
 		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		if (!page) {
+			__sclp_console_free_pages();
+			return -ENOMEM;
+		}
 		list_add_tail(page, &sclp_con_pages);
 	}
 	sclp_conbuf = NULL;
-- 
2.39.5



