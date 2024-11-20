Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D281ABEB4;
	Wed, 20 Nov 2024 13:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107682; cv=none; b=fqvI+UJDoPnN4F42gUW3KpPI0Bg+X1u+6Hn9vxEiww4YOqrErrIzCnVc6hoBWtqLLxy6nT5DekVof70bDP1xlJ5z6EmDOftDb7wmvrhR6vZhvERwbDKmZ8O+XoKAQLzVxbCubmvMeBJqZ8At8IdMxjOswAWtPwHZk2yIf84n7so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107682; c=relaxed/simple;
	bh=KAu7goQGAdbl0um/gpbaUzSXhamYHLFYbRFoE3Era74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+MmI78KxnMy33ldrdvKTo6L6HcNc54TsH/Z+D4eKZSMhKYK50zV9q2VZMJKbbjd3RHLw2C+X/fqWM71gcpNaGrb+vwuJedSaZmjUmoQVuneGVNLjAZ66kixnxUKCgwAYHbxb4A5eabAa8TeL1uXAFj4GfTq4JjpvXVcuMQBGNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ga+8CY6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ga+8CY6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA46C4CECD;
	Wed, 20 Nov 2024 13:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107682;
	bh=KAu7goQGAdbl0um/gpbaUzSXhamYHLFYbRFoE3Era74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ga+8CY6hvuiu9VZk8jIx+ExCI7sszSwXQOSl8a+Y8LoTTiZwVtjWJrQau5e0JuDOV
	 SRsXscuZUL3t8whtJrsuI/uDzl4CVb5yecFrpG18lWTQN+KXI8sXVPMNhqGsy8c3v9
	 hGYvrVd5/YgU0EbTOqy6AuWCxYxm13VI+N50TuHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 40/73] media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set
Date: Wed, 20 Nov 2024 13:58:26 +0100
Message-ID: <20241120125810.574020574@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -534,6 +534,9 @@ int dvb_register_device(struct dvb_adapt
 	for (minor = 0; minor < MAX_DVB_MINORS; minor++)
 		if (dvb_minors[minor] == NULL)
 			break;
+#else
+	minor = nums2minor(adap->num, type, id);
+#endif
 	if (minor >= MAX_DVB_MINORS) {
 		if (new_node) {
 			list_del (&new_node->list_head);
@@ -547,17 +550,7 @@ int dvb_register_device(struct dvb_adapt
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


