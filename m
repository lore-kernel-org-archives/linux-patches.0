Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D149219A63;
	Tue, 29 Apr 2025 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949465; cv=none; b=GF6Db6ADtEOwgCGkcQn7sTcL/05KD8NwdGPhK+9kgKBKeNsSBtycBddsAWyuiz1B+ytrDYq4RIsbumuBoJbi0lQ5ikr3p3tRaLG48AJWiywlaxmL9owYsLnTbteyRk5Znp6d56fa8sON7TZg6r08QgHoR/+ZZScudsvgFGeiIfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949465; c=relaxed/simple;
	bh=aS+QxCVRwQRRzXaKAVQppsrHMHsnH6OxI5fAg42y8Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWKwmtrLt3uXqReuUPjcowkJkAutO0rML1eLHFcLA+xsKnjXuCZx88r87H/ed497ZLoQzsYTgwQfJRUvwa20F51GvUD4yNdxNxljS3f/Eu7wLdfEETv0Y3itLOQrJoV9IVybWFC3tsoMtMse/lcH1mQxmy3UvLBPIytt8p1ADnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZaGFphK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZaGFphK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A67C4CEE3;
	Tue, 29 Apr 2025 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949465;
	bh=aS+QxCVRwQRRzXaKAVQppsrHMHsnH6OxI5fAg42y8Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZaGFphKkv+vzbk+g5PmJF5zpymL2xzGFmj8f98mH8IbYsaxTyfdS2O6vEufUezpV
	 hOTdgeiob9OzHUpv3xTwRDRPg+PJZocVnKMlOXEwaz/hKmitNSZ9BzSqBQKdghv8Ak
	 tivEJKNsDStKRaBDh4rFsCPQlFhTU9EklnFMmOnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/373] s390/tty: Fix a potential memory leak bug
Date: Tue, 29 Apr 2025 18:43:25 +0200
Message-ID: <20250429161136.625671006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit ad9bb8f049717d64c5e62b2a44954be9f681c65b ]

The check for get_zeroed_page() leads to a direct return
and overlooked the memory leak caused by loop allocation.
Add a free helper to free spaces allocated by get_zeroed_page().

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20250218034104.2436469-1-haoxiang_li2024@163.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/sclp_tty.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 971fbb52740bf..432dad2a22664 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -490,6 +490,17 @@ static const struct tty_operations sclp_ops = {
 	.flush_buffer = sclp_tty_flush_buffer,
 };
 
+/* Release allocated pages. */
+static void __init __sclp_tty_free_pages(void)
+{
+	struct list_head *page, *p;
+
+	list_for_each_safe(page, p, &sclp_tty_pages) {
+		list_del(page);
+		free_page((unsigned long)page);
+	}
+}
+
 static int __init
 sclp_tty_init(void)
 {
@@ -516,6 +527,7 @@ sclp_tty_init(void)
 	for (i = 0; i < MAX_KMEM_PAGES; i++) {
 		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
 		if (page == NULL) {
+			__sclp_tty_free_pages();
 			tty_driver_kref_put(driver);
 			return -ENOMEM;
 		}
-- 
2.39.5



