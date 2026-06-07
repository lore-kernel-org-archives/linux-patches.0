Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D3C286A4;
	Sun,  7 Jun 2026 10:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829122; cv=none; b=B+9Ui5mEetOv3gvBheBcB2uddrrE6WSraRbzDn3FiW6aeYnlSPmSrvQwrA4u+9A3v+lhrB91rkNFe8dMOgTqg8B+cMgY7ozvr1yYNHfWY+l7/ZkeDrKGe/1gvalXgsFnB238WUnRd4WPyJn3104hx/p0wJ5CtjgDrit9FwwQqvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829122; c=relaxed/simple;
	bh=vDbn8OqL2Wv/r2/qdvVENrHMxPN1jGKCLb6UF8+AQ9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsF8elIrGgrh8kfx0kVIH8k2YadzybM4jETc7nxWXa9FCb8997ehUCyh3SZ7mHIcIq9rLWBB/BIyh14fNFqnEFvKqP2P/Z3fm41D1jytAu9QL2HQ10gQl8m9O8fBdiuckXVwE1dj2AAbAmu65ZmVbZSp1cZ+6b2EPVReMrZErNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xw3SZjGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xw3SZjGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732A11F00893;
	Sun,  7 Jun 2026 10:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829121;
	bh=noSTU6EBNYtvriaj1AfBBEJkIK1Ve8rDSSBJCuHBXbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xw3SZjGOGOEqKzFCvLFEWLx6WAHRZ3Gvkb5DfOL18xiOdUBD9S0K4chE+eidmmafO
	 PL17HKwVdvs4owd7D6r+LJEDTE/M1Vk/vzxjE2UsOgM6HAq77LH26v1oU1LI7pkaD4
	 Xw2x9LLDRRSv4/obs3XR/7dETHtfAEfZS0j3QbC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 7.0 247/332] counter: Fix refcount leak in counter_alloc() error path
Date: Sun,  7 Jun 2026 12:00:16 +0200
Message-ID: <20260607095737.121791215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


