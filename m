Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BAE223C5A;
	Thu, 12 Dec 2024 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023707; cv=none; b=Xc2sEv0fGEsgWPhnrpay9/i9mitdhFH67pVsESgOyBRaJArxqFvCFnwChck4hJACI0C07oJ9RjuDxdnyNBpV3Y3icqB5TgwvT2HHHNyFMAUF6vLESS5cIjOxsWXy0iuIWN8bD2ggQazNFCFsfAOKrZx5j9My1cTou/QL6ceGqlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023707; c=relaxed/simple;
	bh=tHCrU6hWQx/nwdt+WYm7k5IVbvlMjP8ijLLQ478tXvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbsqVno7MdnHqXkCarGvojWDjK5nM5nQdVFJwTbZixct0EDViItBXByAceTOAwJ3b67kAKYct7CZCXZwe+yDGL0KSlhxmoUmbzyGoqtXvmvhH4saOFKLIE8jRv3Le1PGVkLB7vVkp89HopwNgM9WJgcmZTVPliUzoRPzrglzfyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIqitkOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIqitkOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CF6C4CECE;
	Thu, 12 Dec 2024 17:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023707;
	bh=tHCrU6hWQx/nwdt+WYm7k5IVbvlMjP8ijLLQ478tXvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIqitkOkq/okLsP3c5IyPSIjusXc/slgxSMhbc9kCagIwdk+makwyw5k3uC+eIsUC
	 DaVsFSmjSb406gDc7jgdLuj+Yua5n0HYGs6fy9lWnh4mUZE9zUpm6kUPFAzJ5zvKRJ
	 Fr+mpO1R6Sl9rf1Mjo0rGwx5Xt2S5+2mKURrdsF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 025/459] media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set
Date: Thu, 12 Dec 2024 15:56:03 +0100
Message-ID: <20241212144254.518175418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit a4aebaf6e6efff548b01a3dc49b4b9074751c15b upstream.

When CONFIG_DVB_DYNAMIC_MINORS, ret is not initialized, and a
semaphore is left at the wrong state, in case of errors.

Make the code simpler and avoid mistakes by having just one error
check logic used weather DVB_DYNAMIC_MINORS is used or not.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202410201717.ULWWdJv8-lkp@intel.com/
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Link: https://lore.kernel.org/r/9e067488d8935b8cf00959764a1fa5de85d65725.1730926254.git.mchehab+huawei@kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvbdev.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -544,6 +544,9 @@ int dvb_register_device(struct dvb_adapt
 	for (minor = 0; minor < MAX_DVB_MINORS; minor++)
 		if (dvb_minors[minor] == NULL)
 			break;
+#else
+	minor = nums2minor(adap->num, type, id);
+#endif
 	if (minor >= MAX_DVB_MINORS) {
 		if (new_node) {
 			list_del (&new_node->list_head);
@@ -557,17 +560,7 @@ int dvb_register_device(struct dvb_adapt
 		mutex_unlock(&dvbdev_register_lock);
 		return -EINVAL;
 	}
-#else
-	minor = nums2minor(adap->num, type, id);
-	if (minor >= MAX_DVB_MINORS) {
-		dvb_media_device_free(dvbdev);
-		list_del(&dvbdev->list_head);
-		kfree(dvbdev);
-		*pdvbdev = NULL;
-		mutex_unlock(&dvbdev_register_lock);
-		return ret;
-	}
-#endif
+
 	dvbdev->minor = minor;
 	dvb_minors[minor] = dvb_device_get(dvbdev);
 	up_write(&minor_rwsem);


