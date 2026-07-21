Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8234C46AA67;
	Tue, 21 Jul 2026 15:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648162; cv=none; b=Tn/7gSM06UUeh5CoMQPKXdDmThD4PNdtzcX9LN7Xa5er9Ox4bKqqv4cOy2raGEjpPRda6RMil6bCQi6XFd/qW5er32doom5Dw4Gwko7zK9koBxV2cznMe9Bslnn4MUCCJ80sdeAbJIyni6MqdkUvm/eQW63pLkFl5EN13RKq4ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648162; c=relaxed/simple;
	bh=JPrXn3E2Asq5SjnuKhiUOBE1DkL+kBbwnszgAO4fBVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUKAJ2TWCBwkuZzszcQ7CejfdoZUQQpI0zym7XqplHddbraJPFOEagcXEwmFA4ozMbPmBfXHIgPAT80J7Pn+6MioghNNiPxw7TwUx1E6qC0D9YXwAEL9hIgMNnIgvTG+wszyCM/EibQgB+/Q36IEENtFCKdpPavOmiHhgu+fauU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lqygNgD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lqygNgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35DC1F000E9;
	Tue, 21 Jul 2026 15:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648161;
	bh=fySSSASGpHZO3/mySNdl6H3S6eHibA9yglB0J4u1kfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lqygNgDD522zJhXvio7EIJam3+nypIkO8mkuL67XT9DhXAWAQ/GLbi7XwA4ieYtl
	 hhsYJk5/Qgkp+PKlUUBs5XF51j5kB+GM4ToTPPpaFZf2UlHQKKcQg57SptBLlkop1h
	 fpQ8QQPtx8Vg/qMlO2LTcFAslFA09SDdY6nXUHu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0096/2077] pinctrl: pinconf-generic: fix properties bitmap leak in parse_fw_cfg()
Date: Tue, 21 Jul 2026 16:56:09 +0200
Message-ID: <20260721152554.957994589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 352f5621b8c472bf328f452446bce85c00837223 ]

In parse_fw_cfg(), if fwnode_property_match_property_string() fails with
-ENOENT, the code returns directly and leaks the bitmap.

Use __free(bitmap) for automatic cleanup to fix the leak.

Fixes: 9c105255108b ("pinctrl: pinconf-generic: perform basic checks on pincfg properties")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinconf-generic.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 64ed2830978871..07714912162809 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -225,10 +225,9 @@ static int parse_fw_cfg(struct fwnode_handle *fwnode,
 			unsigned int count, unsigned long *cfg,
 			unsigned int *ncfg)
 {
-	unsigned long *properties;
 	int i, test;
 
-	properties = bitmap_zalloc(count, GFP_KERNEL);
+	unsigned long *properties __free(bitmap) = bitmap_zalloc(count, GFP_KERNEL);
 
 	for (i = 0; i < count; i++) {
 		u32 val;
@@ -263,7 +262,6 @@ static int parse_fw_cfg(struct fwnode_handle *fwnode,
 			if (ret) {
 				pr_err("%pfw: conflicting setting detected for %s\n",
 				       fwnode, par->property);
-				bitmap_free(properties);
 				return -EINVAL;
 			}
 		}
@@ -295,7 +293,6 @@ static int parse_fw_cfg(struct fwnode_handle *fwnode,
 		pr_err("%pfw: cannot have multiple drive configurations\n",
 		       fwnode);
 
-	bitmap_free(properties);
 	return 0;
 }
 
-- 
2.53.0



