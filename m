Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8628023CEF9;
	Tue, 29 Apr 2025 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947991; cv=none; b=aXh71q3j6yD0w34NOjwH14f9bd0/nygsUYcZbYpCviX/9o0I5k1O+sl0pY5hoKdbmqBAoVfr+l0xsHGRIXJ41Kor6AzK3kiJWzSTeaaGBOJwHa7vJsO0wC8BWxAfsrBLfF9jXrLWX5/jAjyIZc21svJODxiamjhcMhbDGoZQKWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947991; c=relaxed/simple;
	bh=MdusGSW4yAuKZ1hyB0hn0H6Ogk8wLgIvDEM2ASx+apI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHiEzJPEBDs58GGRgMXQPxfrXeb4LC0zwELhqMrP87uVEWSVHTRL0GB1AuBj/t8LUMEMne4SyXON+BR9KsE04l33GHBFoYBdwRmPHuRB5X6J2AD+ugyrYjBKcxlCcBWT+svFHIqFppahkEaR6khvh79HFyyt7cKHQVHyy2oOmxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7HA3M14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7HA3M14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FECC4CEE3;
	Tue, 29 Apr 2025 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947991;
	bh=MdusGSW4yAuKZ1hyB0hn0H6Ogk8wLgIvDEM2ASx+apI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7HA3M14ggjNacqmNf+993+EP0iwmo+PgdAo8cGIdy5sDYHlTn3HroRZBjyFicC/1
	 pl/PftOictr5Olm3oTXRvtMWbgYIDiVuLMqpIxGhvRh3fHpi77AfmVSRYZkQ+LH30h
	 eX94B2aEeqy5eNZiDiIca5nAp8JuqCVpLaT3UmK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/280] s390/sclp: Add check for get_zeroed_page()
Date: Tue, 29 Apr 2025 18:41:44 +0200
Message-ID: <20250429161121.783438688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



