Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12083286A4;
	Sun,  7 Jun 2026 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829126; cv=none; b=Nw62m5vNEKsk5T1wPqtu5kx8KzScI0bLu6QLNHEIAQY+mqrTIbxgsjVp5+7+Dmq33udlvEblE+FN1g6om0/ZH7R+iZcCuJe6nSSqDKkx7mzfmRGVtGwxwbTuNLM6rLb8KmOx/HWP2nvcXsqDtKI8F7R/Dm0ljHzdU3Pll/RqCMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829126; c=relaxed/simple;
	bh=/McWc8yAHE0qBvlnZkUxl04/Ndjso83G92JSb/UXSoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/KYO+VPx/0tofUhw5Yk7MkC/FAmNKQPOv3yP246Fo3VSptUcn995+ixJJHB1hHBVNVf/0YM2tckuA8HlNjP+q7sgW2oMfKBieSEUjCHAMSIbRAonp90BRtwpF07EeLs4qKETkgh4CaqDfRT0qRDEwgN7eVFnS5SdtNiGdOm3M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCmpy7Ka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCmpy7Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38F91F00893;
	Sun,  7 Jun 2026 10:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829124;
	bh=/mbSRVP2X8fcS4WBnCaGuueRgevSssDBxd525A1PnW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCmpy7Kaj46r0fbiVBKYYtgRqS9NWDhszqrQB6GHSALRs2vUvJ7KeWDM4Ds6PduxZ
	 Az10WLlPRbURiJqGbD6KYD+TrTyIPad8T9uj/Rf6maUyd3KZtC0fAbaIepMHH/UHwn
	 0hg3J4L9OrgeT/iJxWYWMxnoq5D/7tXkKTYUqu+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.18 219/315] counter: Fix refcount leak in counter_alloc() error path
Date: Sun,  7 Jun 2026 12:00:06 +0200
Message-ID: <20260607095735.623612327@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit d9eeb0ea0d2de658663bfaa9c26eccdd8fd64440 upstream.

After device_initialize(), the lifetime of the embedded struct device
is expected to be managed through the device core reference counting.

In counter_alloc(), if dev_set_name() fails after device_initialize(),
the error path removes the chrdev, frees the ID, and frees the backing
allocation directly instead of releasing the device reference with
put_device(). This bypasses the normal device lifetime rules and may
leave the reference count of the embedded struct device unbalanced,
resulting in a refcount leak.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix this by using put_device() in the dev_set_name() failure path and
let counter_device_release() handle the final cleanup.

Fixes: 4da08477ea1f ("counter: Set counter device name")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://lore.kernel.org/r/20260413134604.2861772-1-lgs201920130244@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/counter-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/counter/counter-core.c
+++ b/drivers/counter/counter-core.c
@@ -124,7 +124,8 @@ struct counter_device *counter_alloc(siz
 
 err_dev_set_name:
 
-	counter_chrdev_remove(counter);
+	put_device(dev);
+	return NULL;
 err_chrdev_add:
 
 	ida_free(&counter_ida, dev->id);


