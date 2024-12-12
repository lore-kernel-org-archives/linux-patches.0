Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358B720A5EE;
	Thu, 12 Dec 2024 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025045; cv=none; b=VxP8+19uFC0/vqdCpFcXsc5q1IkIsJMo60B8OVotMA+vbvgXAXL6ywiWCMKiBD8+sLYR+xGW6NnKSUviDN8tgNHW008IX5+y2VXFtkD1yJeqms8R4YAo3aKso7pmabYB4J2fdygkUhFKKIGu//HEreKIdoWIGe9Kxkp3xmD1nsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025045; c=relaxed/simple;
	bh=nv/ia1enaYT/771fxRb7R7qddBYw1czBP8ByUyJp46U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXvZSwhgUGDq9mzhoyTcYjaAVunFR5SS2CRErC+tdI9jWF9uFxCBAlutzN/7qMFaFHPYO7arnon4MqJIHKuQ6fkKeWpx+bcupLVtUZYj1lR0ztpzCEkBn63P/Kz+K4bf05SBdXtvt3d/5502Gqj9WKTUdksNDvkp9zBjXJHnu2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLKGLa6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLKGLa6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E3EC4CECE;
	Thu, 12 Dec 2024 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025045;
	bh=nv/ia1enaYT/771fxRb7R7qddBYw1czBP8ByUyJp46U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLKGLa6XXUGbNeRGSEN1VTv3oK7n4D47xKpVUEcGY4isyYN4m/OnHG9H1R5GK/VXQ
	 vvhMFcgswxFzpu3NBScQWFjhIhAqZaTzk24Y23xJC3XzwczbCaivf0Vte8+s3gMb/P
	 GMkFTy4ooOJbfZtt1OSdkcfeW3GBUdOXt5+WFlhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 010/321] media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set
Date: Thu, 12 Dec 2024 15:58:48 +0100
Message-ID: <20241212144230.053945943@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


