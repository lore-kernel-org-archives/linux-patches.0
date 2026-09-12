Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A39364049;
	Sat, 12 Sep 2026 07:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198694; cv=none; b=p8RBI9BlAGbsO4QHmKgDR+Ob3QljZwckVRwzTery5SWvYmRp7CyREd0vfKfxHQ7zDuJaIgKd3NTocKHjf+1ql0F1JtpMJ1Dp96sqMxUkL6lsbgym0zlnr/CNrrvw8/U1FHxk7h3zgAQyPPqZYi+hhvGiW3KxNoIVinq4veuOEAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198694; c=relaxed/simple;
	bh=bljkVx3MMusHQK8oIFZgCGSO2UjAUOQtoxWpxBIek9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uybzZ7VdzlAUY6Rd4Pu1W10iJQDKuKiamEYPj0tnoECwGITZX9zPnlTdjXUAkZETjU02y8+av6i+cpfvvtjOsmkH9kNdQrULXYIrnJvRkiq7mXKLd7/pB4+3pd+AscWXvzfkFcc0ZvkUP2zHYSwF+HJ9leU2yVkddd3BrLshDPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTY3g39k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTY3g39k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD411F000FF;
	Sat, 12 Sep 2026 07:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198692;
	bh=u54msIacinI2UFTIXg5byLA2x1kjfpq+6XLy3u50BX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTY3g39kxwxJ6VVDe0QBJO3clfqRAB5HKhL3DPVzUIdhXyoxGG2OBiAqN5nHd+Vkk
	 7m5NDIPt4a8sm0NIiaS2dvBXQ0voVdXxoPAF5hlau6QjVp4V7AbMAVM34oeoVLVv4m
	 uCmSmhOuJTH9m+ONdY5mml3SAkRGd2P0aKZCfOPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0433/1815] OPP: Fix cleanup ordering
Date: Sat, 12 Sep 2026 08:36:23 +0200
Message-ID: <20260912065659.059881736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregor Herburger <gregor.herburger@linutronix.de>

[ Upstream commit ce46fede7792cedd247e34b48bc8a02eb90c7848 ]

Commit 173e02d67494 ("OPP: Initialize scope-based pointers inline")
added initialization for all pointers. In some cases, the ordering was
changed so that *opp_table was initialized after *opp. This also changes
the order of the registered cleanup functions.

When the cleanup happens, this can cause use-after-free errors when the
last reference is released and the release function _opp_kref_release
tries to access the already freed opp->opp_table.

Initialize *opp_table before *opp again to fix this and ensure the
correct cleanup order.

Fixes: 173e02d67494 ("OPP: Initialize scope-based pointers inline")
Signed-off-by: Gregor Herburger <gregor.herburger@linutronix.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index ab0b0a2f85a17..b6966e509f7dd 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1412,13 +1412,12 @@ static int _set_opp(struct device *dev, struct opp_table *opp_table,
  */
 int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 {
+	struct opp_table *opp_table __free(put_opp_table) =
+		_find_opp_table(dev);
 	struct dev_pm_opp *opp __free(put_opp) = NULL;
 	unsigned long freq = 0, temp_freq;
 	bool forced = false;
 
-	struct opp_table *opp_table __free(put_opp_table) =
-		_find_opp_table(dev);
-
 	if (IS_ERR(opp_table)) {
 		dev_err(dev, "%s: device's opp table doesn't exist\n", __func__);
 		return PTR_ERR(opp_table);
@@ -2870,11 +2869,10 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_add_dynamic);
 static int _opp_set_availability(struct device *dev, unsigned long freq,
 				 bool availability_req)
 {
-	struct dev_pm_opp *opp __free(put_opp) = ERR_PTR(-ENODEV), *tmp_opp;
-
 	/* Find the opp_table */
 	struct opp_table *opp_table __free(put_opp_table) =
 		_find_opp_table(dev);
+	struct dev_pm_opp *opp __free(put_opp) = ERR_PTR(-ENODEV), *tmp_opp;
 
 	if (IS_ERR(opp_table)) {
 		dev_warn(dev, "%s: Device OPP not found (%ld)\n", __func__,
@@ -2932,12 +2930,11 @@ int dev_pm_opp_adjust_voltage(struct device *dev, unsigned long freq,
 			      unsigned long u_volt_max)
 
 {
-	struct dev_pm_opp *opp __free(put_opp) = ERR_PTR(-ENODEV), *tmp_opp;
-	int r;
-
 	/* Find the opp_table */
 	struct opp_table *opp_table __free(put_opp_table) =
 		_find_opp_table(dev);
+	struct dev_pm_opp *opp __free(put_opp) = ERR_PTR(-ENODEV), *tmp_opp;
+	int r;
 
 	if (IS_ERR(opp_table)) {
 		r = PTR_ERR(opp_table);
-- 
2.53.0



