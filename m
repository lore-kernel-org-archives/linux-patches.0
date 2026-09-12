Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79C9472F6C;
	Sat, 12 Sep 2026 11:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213340; cv=none; b=Nu96QiV9Ap1A0+Y0P9L6QjVc58mwejJFcrK0guF7YjQp8WWQG6gLbE+79/V6SZwnbu+aKjeHypqZXf7ElV20LMv1ByPu/FtSLLkZh0YhOppo16jjy4g+FFRqyc2FbWa3O4xUWpLZWdvcwQfblqNeIrgqfKCexPXYegMPUJXvT4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213340; c=relaxed/simple;
	bh=tw5LEjFaIU8KiM7UloIFOOZH1Rq+SfQsd9po5CNr/QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRiwN5f6n1HZMbzz/DkqzvxHyfQY6LEbpZ29tcVZzf+p3knfI+4MSE+3Ls4Snvv/f8t20rdFXzApld3bQDUOgqsljQEdkIAh8b+YY/Ue2C0+q5S4qHYiTvIh6gQHe6fmqQ/65C8R6sQ4Jk1s8JklosVMUbKtUhheTDK0UgNvjsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km28g3fB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km28g3fB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A130B1F000FF;
	Sat, 12 Sep 2026 11:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213338;
	bh=p9sHWZGzVa6d7wslPlmSds2wp/UlxaWS2IJXR+jHBfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=km28g3fB2zw9fOz0h2laec1zruXc/L6pKLAUwi+cHBR0BP7jFY0tmoTA3czuMm06D
	 sC2glzevhC+saeOrtAO86h48btPwmRm2S53lX3kTWhaWhGgTqXoPvlH1Yt2YOGIYV1
	 iukL2Jpmbk2qBr2QAx95c+oSzq5DUPN65unwXkI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 0102/1376] s390/vfio-ap: Fix stale do_remove flag across iterations in vfio_ap_mdev_cfg_remove
Date: Sat, 12 Sep 2026 08:42:08 +0200
Message-ID: <20260912065609.831210671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit b1f092d94f621307927f145e3cc31893da51fc08 upstream.

The do_remove flag in vfio_ap_mdev_cfg_remove() is initialised to zero
before the loop that iterates over the list of matrix mdevs, but is
never reset at the start of each iteration. Since do_remove is
OR-accumulated across iterations, a positive result from one mdev
carries over to subsequent mdevs.

The fix is to set the do_remove flag with the first call to bitmap_and;
for example: do_remove = bitmap_an rather than do_remove |= bitmap_and.

Fixes: eeb386aeb5b7 ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2549,15 +2549,15 @@ static void vfio_ap_mdev_cfg_remove(unsi
 	DECLARE_BITMAP(aprem, AP_DEVICES);
 	DECLARE_BITMAP(aqrem, AP_DOMAINS);
 	DECLARE_BITMAP(cdrem, AP_DOMAINS);
-	int do_remove = 0;
+	int do_remove;
 
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
 		mutex_lock(&matrix_mdev->kvm->lock);
 		mutex_lock(&matrix_dev->mdevs_lock);
 
-		do_remove |= bitmap_and(aprem, ap_remove,
-					  matrix_mdev->matrix.apm,
-					  AP_DEVICES);
+		do_remove = bitmap_and(aprem, ap_remove,
+				       matrix_mdev->matrix.apm,
+				       AP_DEVICES);
 		do_remove |= bitmap_and(aqrem, aq_remove,
 					  matrix_mdev->matrix.aqm,
 					  AP_DOMAINS);


