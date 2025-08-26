Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB231E5718;
	Tue, 26 Aug 2025 12:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212829; cv=none; b=erzZNYJPgiBuFRCUX1q02EHyG+URbnMyI6Qp3SK5U7JwcxZGRTa1YISD7eoBKDlWgCBYDCWAIwp4SKg4Vqt9l51YEycYDnQmai7WMfxYUGUjRPnlwWsJDNd9fZOvTezDq8DbizHmejVQvOsB8ZPHtWcI6n+sHEpmd6jsWoXNnno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212829; c=relaxed/simple;
	bh=FNHyEi10fpSX6LJVlgIrObT2IkcHnp1tvvDcGto4MAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgsQXcuMDITXm/Tp2y8GTQB5MkHB0GLzGj5GU+Do2eho+DZrHdLLA7KxdKGVtY5SXLbkz0GrS2z5zjI6EpXXIcp1QkT/8l7nnXhkUsEGuCbXLLHlHJHJxSsmDWxzwQJHj8kCdy75PYRevxXkR/KdYtKz65td0lQ+LYnkLO8jdSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUDdJbO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUDdJbO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBA6C4CEF1;
	Tue, 26 Aug 2025 12:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212829;
	bh=FNHyEi10fpSX6LJVlgIrObT2IkcHnp1tvvDcGto4MAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUDdJbO2uTws4HWR4yCymCCF3wvyRJleqgcSeEa/GVOHf5H4sFbm+pxJ6ON5mv/7t
	 Zd6/ksdXWX8WPbPc/BFeitad2W2hAYfrnghZSsIBD/FCK3of1KokTiI/l0I6vP7KKm
	 wvKQaDJUYMoU2kRYHkKKcz/hBXWen2wFcm0ND0Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/587] char: misc: Fix improper and inaccurate error code returned by misc_init()
Date: Tue, 26 Aug 2025 13:04:26 +0200
Message-ID: <20250826110955.944808810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 0ef1fe4bc38673db72e39b700b29c50dfcc5a415 ]

misc_init() returns -EIO for __register_chrdev() invocation failure, but:

- -EIO is for I/O error normally, but __register_chrdev() does not do I/O.
- -EIO can not cover various error codes returned by __register_chrdev().

Fix by returning error code of __register_chrdev().

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250620-fix_mischar-v1-3-6c2716bbf1fa@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index dda466f9181a..30178e20d962 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -314,8 +314,8 @@ static int __init misc_init(void)
 	if (err)
 		goto fail_remove;
 
-	err = -EIO;
-	if (__register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops))
+	err = __register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops);
+	if (err < 0)
 		goto fail_printk;
 	return 0;
 
-- 
2.39.5



