Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEA122A81D;
	Tue, 29 Apr 2025 17:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946203; cv=none; b=KHaYHfQ6G73J8lyHupKotiK89c7P8S0y/Ei1myhS6NeEwmIMNUBJLI7nIzboZ7CJgDXfPbZyuUpBKrhdxCRRLXJTQTW1DUasP6GXt3rgoJ38k47+dZD48nffp0Gr+Jtd2RfPkSJoDpXSxMrmEtx28Uk49WaINDmZf25pu4wWJlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946203; c=relaxed/simple;
	bh=26eq0U2NhX9baquq0e1+ES4OkqVxH4E8qDi1mEopq24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch+xNeraCiYNe6vBhl9dGkTyCktX/cHGus/lbchFbDVdSH9N10ZxJw3tJMbZ7+gijjsjXbtXQKLK8Xbnvmf+O7lz0y9Lnu/z9C8GFXJmjvHvnxOEPKYtvjfDDTNIAzFbTfnaNJEhMbthGl9836FrvgL/AJvqsklCG/4B7TGS1wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxLv/k7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxLv/k7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E15C4CEE3;
	Tue, 29 Apr 2025 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946203;
	bh=26eq0U2NhX9baquq0e1+ES4OkqVxH4E8qDi1mEopq24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxLv/k7UUtXMATYRUlY/cGYespL5qKBREBNroyyKg5hObI7I3mK/eqWD6HWM90lPA
	 G4QKoqliRcjMJRrkESA/s3+uGMK4PsybfXi+M9iGxbYYkONm99finFz932vD1jSMZH
	 /1v9428MVAWZTPGYwXx5sDyoi9Rxxmd+Zmu32MiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 190/311] s390/tty: Fix a potential memory leak bug
Date: Tue, 29 Apr 2025 18:40:27 +0200
Message-ID: <20250429161128.798696067@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



