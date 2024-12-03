Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B81F756A;
	Tue,  3 Dec 2024 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239474; cv=none; b=IMK1USlN39EFH6yRaaZaXEdTe3JNfMCf2Zdv6bJ09o2P+/gOiyH3nFtXLABDUNRgy0/0cxNV+ToDMxuwUXoj2l+4e82rUSN3pOvHR/iaBizJxp9S8oX56z/U/YLDEXS6ZaYJQQWZ5EcKf5CovcXoV6a+Y3hW4VKD32TyW5tX/ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239474; c=relaxed/simple;
	bh=wwyrh390R9L9CnJ4Mu/xDRREYALoW3T48o3D3QS7DbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMr0jATkr+OzZAFAqvpE+FNFymC5CVN2zXCIDyAWgRvibHljLoF/prHp39uc9RvyK4N3sNu5IAtS06xdlp8zfcG8whoQpbRHzNbYiiP3l5O007wdu9EoB883WMhfEFELmw/kTHd+OXozX+QpIyNA54c4ZwEzLXdHOJbvCaHsDhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmNoVzdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmNoVzdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E91DC4CECF;
	Tue,  3 Dec 2024 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239474;
	bh=wwyrh390R9L9CnJ4Mu/xDRREYALoW3T48o3D3QS7DbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmNoVzdOZQBE77kh4Mgbd4PotdXm7LHGiqdPJ+l6EIzzd1hgrOuehjk49yQUroUa9
	 kOf4gsdHPZFJS8Yx1jWHj9ZjjI4ML5YNZn/HbYaeARgYwTLLJZm+LL+gruUCHgIdha
	 rCLpeoW+mAyxFMyUEH6YuX7ECG0kFmSSfSNCFq+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.11 627/817] xen: Fix the issue of resource not being properly released in xenbus_dev_probe()
Date: Tue,  3 Dec 2024 15:43:19 +0100
Message-ID: <20241203144020.412390073@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit afc545da381ba0c651b2658966ac737032676f01 upstream.

This patch fixes an issue in the function xenbus_dev_probe(). In the
xenbus_dev_probe() function, within the if (err) branch at line 313, the
program incorrectly returns err directly without releasing the resources
allocated by err = drv->probe(dev, id). As the return value is non-zero,
the upper layers assume the processing logic has failed. However, the probe
operation was performed earlier without a corresponding remove operation.
Since the probe actually allocates resources, failing to perform the remove
operation could lead to problems.

To fix this issue, we followed the resource release logic of the
xenbus_dev_remove() function by adding a new block fail_remove before the
fail_put block. After entering the branch if (err) at line 313, the
function will use a goto statement to jump to the fail_remove block,
ensuring that the previously acquired resources are correctly released,
thus preventing the reference count leak.

This bug was identified by an experimental static analysis tool developed
by our team. The tool specializes in analyzing reference count operations
and detecting potential issues where resources are not properly managed.
In this case, the tool flagged the missing release operation as a
potential problem, which led to the development of this patch.

Fixes: 4bac07c993d0 ("xen: add the Xenbus sysfs and virtual device hotplug driver")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241105130919.4621-1-chenqiuji666@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xenbus/xenbus_probe.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -313,7 +313,7 @@ int xenbus_dev_probe(struct device *_dev
 	if (err) {
 		dev_warn(&dev->dev, "watch_otherend on %s failed.\n",
 		       dev->nodename);
-		return err;
+		goto fail_remove;
 	}
 
 	dev->spurious_threshold = 1;
@@ -322,6 +322,12 @@ int xenbus_dev_probe(struct device *_dev
 			 dev->nodename);
 
 	return 0;
+fail_remove:
+	if (drv->remove) {
+		down(&dev->reclaim_sem);
+		drv->remove(dev);
+		up(&dev->reclaim_sem);
+	}
 fail_put:
 	module_put(drv->driver.owner);
 fail:


