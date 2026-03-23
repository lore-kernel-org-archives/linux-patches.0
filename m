Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA91399352;
	Mon, 23 Mar 2026 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277074; cv=none; b=BF/dJdCm5kJhHOTZO15NZqyGFhZbDM1QdYvoG0lcjofIclB5nWfWvDHLe4D9528oyB+wb1M2RuGZvl0wCHaXAiI0ZYKRqJ+jDjeArnmSluTM9gUgYfHJuANU5u/c0hao3Pg4VnFDmBO/ZBXsuk8zMvKSAKlnDWYAVYUAM8HrTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277074; c=relaxed/simple;
	bh=6UNHPEdeI2X00Jy+YSXKQpImrZ2M6UD3AJ/+GWvffEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEQF/yZ07GEWpte3Ns+WEne1eseUVXLodKzuBsivNgTzzl9bdSnNqgeIGfAteTwRwMyaR5vwCFq6rdZo0bJQr7OAZDb0Vh+RTX+9LH7CuVRlMZLfSNoCLYxViPAR9e9AW+7Y2143MUyND7/dl9evzlidPk1crLmLAtOxqD9Q18k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I75k3unK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I75k3unK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C0CC4CEF7;
	Mon, 23 Mar 2026 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277074;
	bh=6UNHPEdeI2X00Jy+YSXKQpImrZ2M6UD3AJ/+GWvffEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I75k3unKcV3sfNMdMaTXxinTIVSjhatOxf3W3MDclniY1MlLCQe1WR9hMHLdznGLE
	 knm2a9QzpvMSag1HfurG5ceQOXnpKLNuTh3CVugVVQBaEb6mbu1AgvHchzlslw9ri7
	 1sGG0xGfhKuHF1Vy6uugIuZfykImmllej+HFb3q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dingisoul <dingiso.kernel@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH 6.12 311/460] nvdimm/bus: Fix potential use after free in asynchronous initialization
Date: Mon, 23 Mar 2026 14:45:07 +0100
Message-ID: <20260323134534.143925568@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Ira Weiny <ira.weiny@intel.com>

commit a8aec14230322ed8f1e8042b6d656c1631d41163 upstream.

Dingisoul with KASAN reports a use after free if device_add() fails in
nd_async_device_register().

Commit b6eae0f61db2 ("libnvdimm: Hold reference on parent while
scheduling async init") correctly added a reference on the parent device
to be held until asynchronous initialization was complete.  However, if
device_add() results in an allocation failure the ref count of the
device drops to 0 prior to the parent pointer being accessed.  Thus
resulting in use after free.

The bug bot AI correctly identified the fix.  Save a reference to the
parent pointer to be used to drop the parent reference regardless of the
outcome of device_add().

Reported-by: Dingisoul <dingiso.kernel@gmail.com>
Closes: http://lore.kernel.org/8855544b-be9e-4153-aa55-0bc328b13733@gmail.com
Fixes: b6eae0f61db2 ("libnvdimm: Hold reference on parent while scheduling async init")
Cc: stable@vger.kernel.org
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260306-fix-uaf-async-init-v1-1-a28fd7526723@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/bus.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -489,14 +489,15 @@ EXPORT_SYMBOL_GPL(nd_synchronize);
 static void nd_async_device_register(void *d, async_cookie_t cookie)
 {
 	struct device *dev = d;
+	struct device *parent = dev->parent;
 
 	if (device_add(dev) != 0) {
 		dev_err(dev, "%s: failed\n", __func__);
 		put_device(dev);
 	}
 	put_device(dev);
-	if (dev->parent)
-		put_device(dev->parent);
+	if (parent)
+		put_device(parent);
 }
 
 static void nd_async_device_unregister(void *d, async_cookie_t cookie)


