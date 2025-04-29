Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3E1253B71;
	Tue, 29 Apr 2025 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950539; cv=none; b=guMYow2kzEf+gu4d+GBuRaL8IS0VzzIF27lvWBKXMHSw7p+efJx5ZcAuE80LlUdISI1VxJUBpYcDn/nasWzSa8zjOUoSY6H53ioCVBF5Tq5sGz52IrDVjRSllO/k9mXQoI/AeyuXJQfY0VX0CYBbL9ONVqA/ZNiZLlYiwxAvIOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950539; c=relaxed/simple;
	bh=nLaq6WgnEYcOqlAuG0T80BJXCZ/1LxN0bGvXqwGGHto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rppi1zy7PzE213oHSyeZzwolDE1kl19f5fDs6dnx7Kgna2Z9uASrloyQ6f8iv1pI0uDpcdoaHm42+neuaDLOi2E5mjXkCzMjTzcKJ7XfEd8pYCfKMcpX1/BbCqqBISvm1zeSeySOFFhbfBd8s4u/kBypRkC/dxC1bYRtzZjhSLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBXowlaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBXowlaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A10DC4CEE3;
	Tue, 29 Apr 2025 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950538;
	bh=nLaq6WgnEYcOqlAuG0T80BJXCZ/1LxN0bGvXqwGGHto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBXowlaFEVo9EhMjCn38g04vf0OutHAksK/YJCx4kzvFfZl2L5ggR43aClXE0K0zI
	 sJOx4MQUi2/JoO25Et7Ld2dp6sVJ35IfwlkuQAGNqJLWRA7OcclljjeQk0CzCE3Xas
	 Cu3zaschDuv5+NvGvUEQ7Nhu61teVcHjWD3TY2Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/204] s390/tty: Fix a potential memory leak bug
Date: Tue, 29 Apr 2025 18:43:33 +0200
Message-ID: <20250429161104.545983420@linuxfoundation.org>
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
index 892c18d2f87e9..d3edacb6ee148 100644
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



