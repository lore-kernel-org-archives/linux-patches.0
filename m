Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF92223C43;
	Thu, 12 Dec 2024 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025643; cv=none; b=TIQ+5+478JpvhBJr8jCbIjfY1SPt0EPBIqoyUAtFgulQjRKuDXteNAOHtfay79ekY2KKAbRwsRj8CHXlT/PykmsdJww9/+snjugVFyN43q2VyPNM0iyg1EUTxLoy+2NiSh1fMz38QQK/bv2HrocrHm9sUpP7nK+Nchs7hZVGuk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025643; c=relaxed/simple;
	bh=11Mxjcs5D62YpM3hXQvyVGQ6J3CeeGxuRUI9h+hMF6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJWnaHTbHwHe245xZzdTGWMY4T+cjxPznK5iYgL+IIGTmTL2PzUqo9duKHu952us6wNIbh4KS4sF1kZgw5ZzWegdMC0LtFlsHbBVE0oRNiCZcQ5LRu+fqC/3hqxi/VKzOYczm7N2HTbmGz5odG4nj4tMbMNHtHglK/KQ1l+U8vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfjC7X5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfjC7X5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA02DC4CECE;
	Thu, 12 Dec 2024 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025643;
	bh=11Mxjcs5D62YpM3hXQvyVGQ6J3CeeGxuRUI9h+hMF6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfjC7X5ATgbL6HVzGqJM3zLpc4FVjxFZJwN5REO4EFKhzbHAVOK+Xh8nJeXWVv+Uc
	 IvFH2cQO2/EvOnBbWh+TWpKegoll4Y1m4gF2cCVKVNR27aOumkoKAVot0aoopzbJ55
	 Wbw3Q5tLb4XP3ny+NiIBqIwhrqLbyPRObns7XlIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Paul Durrant <pdurrant@amazon.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 237/321] xen/xenbus: reference count registered modules
Date: Thu, 12 Dec 2024 16:02:35 +0100
Message-ID: <20241212144239.334355977@linuxfoundation.org>
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

From: Paul Durrant <pdurrant@amazon.com>

[ Upstream commit 196748a276b4dee01177e6b7abcda27cd759de83 ]

To prevent a PV driver module being removed whilst attached to its other
end, and hence xenbus calling into potentially invalid text, take a
reference on the module before calling the probe() method (dropping it if
unsuccessful) and drop the reference after returning from the remove()
method.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: afc545da381b ("xen: Fix the issue of resource not being properly released in xenbus_dev_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index b911a91bce6b7..9215099caad61 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -233,9 +233,16 @@ int xenbus_dev_probe(struct device *_dev)
 		return err;
 	}
 
+	if (!try_module_get(drv->driver.owner)) {
+		dev_warn(&dev->dev, "failed to acquire module reference on '%s'\n",
+			 drv->driver.name);
+		err = -ESRCH;
+		goto fail;
+	}
+
 	err = drv->probe(dev, id);
 	if (err)
-		goto fail;
+		goto fail_put;
 
 	err = watch_otherend(dev);
 	if (err) {
@@ -245,6 +252,8 @@ int xenbus_dev_probe(struct device *_dev)
 	}
 
 	return 0;
+fail_put:
+	module_put(drv->driver.owner);
 fail:
 	xenbus_dev_error(dev, err, "xenbus_dev_probe on %s", dev->nodename);
 	xenbus_switch_state(dev, XenbusStateClosed);
@@ -264,6 +273,8 @@ int xenbus_dev_remove(struct device *_dev)
 	if (drv->remove)
 		drv->remove(dev);
 
+	module_put(drv->driver.owner);
+
 	free_otherend_details(dev);
 
 	xenbus_switch_state(dev, XenbusStateClosed);
-- 
2.43.0



