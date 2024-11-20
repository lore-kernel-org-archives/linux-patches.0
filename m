Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4571B3B28;
	Wed, 20 Nov 2024 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107609; cv=none; b=IWNjiXezEqyygIjZ6tnzd5L8J/nZKXGDIIw/wmvLswBQp7QlaGr/MiNfaPg6CPfpnNwrUoUUUcxVz1YKYwfpck95HTPxFBHAqwqKmtLkJ62E7zrYct1Lt8TwVNrlkzyTvTqWn+zRVleoCUcIkIOMaG35s5sncTtbE3ikiB6OQRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107609; c=relaxed/simple;
	bh=7bDZCEgWrnYmWFHtidhxWAdAeRHPPiL5uGZfgERUJ8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBoC8/Xwsri+PCORnbyLCC8JZi7PX/ExrxxAzp6mIda0ZoR+9b3p1plXVgT6hDu1ldWBKo9cqmloFe70W2jN8qP5U0Jbo6dUuKWJNPi9c1oaT8+pp3kLakQLmOnO0mNmR6b4fmYqUEFs73mquQiydQFDjubXP1+PjV/bVspRYK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuZg4yGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuZg4yGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68640C4CECD;
	Wed, 20 Nov 2024 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107609;
	bh=7bDZCEgWrnYmWFHtidhxWAdAeRHPPiL5uGZfgERUJ8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuZg4yGtmqEoWixEWHSK0ZteDAM25Nx1TJiPHRFGnbSH+UoNaE1oeP1NgOXVPXTIm
	 91PgN7h3LSN9dXd1K7t3hDGBTPilsmiGWSgxOYKqRYkpBF8G7f1mYu3vronYPFa4JQ
	 lkRIseRjFiZjVRcKNE0Mx5AD1DaF5kbCE4KnQfp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.6 60/82] media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set
Date: Wed, 20 Nov 2024 13:57:10 +0100
Message-ID: <20241120125630.964490786@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -530,6 +530,9 @@ int dvb_register_device(struct dvb_adapt
 	for (minor = 0; minor < MAX_DVB_MINORS; minor++)
 		if (!dvb_minors[minor])
 			break;
+#else
+	minor = nums2minor(adap->num, type, id);
+#endif
 	if (minor >= MAX_DVB_MINORS) {
 		if (new_node) {
 			list_del(&new_node->list_head);
@@ -543,17 +546,7 @@ int dvb_register_device(struct dvb_adapt
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


