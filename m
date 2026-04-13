Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867B230ACE6;
	Mon, 13 Apr 2026 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097679; cv=none; b=rxveL9Fg92nQtdYIjtQct07/NftCUrEV9/Fwonsr6WexywGSb4amR3UKUZMQr51hanwLMFsg9z66/OMLHADNDfxKXsNOXhVXTwru36Ly8AcoL85X9wUZZVAD3Lr9InXUX7sSIAhSgDPAgw35urWYj/omW1s79BakFyalDSIwsko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097679; c=relaxed/simple;
	bh=8txmi2MCyvqx4Evu5bDVHEbSxR5oFI0jznIf586Yqn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJzEfFbSFVB9ScwYvuqnydzK7N0ink77eMdnomkZQKIwvtzLqn4EuYLFI66UFJm9NAfEVVSsPxFdU6pAyC9DAkp1CBzBXdld9aKVIgxP8xYiZMQK50ZeZwIn0kzK4j3bOLhbZ76tDpU1oLB7r2RRLHD0xCpVRfBuDt2+ieoyXek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDoWuand; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDoWuand"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA32C2BCAF;
	Mon, 13 Apr 2026 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097679;
	bh=8txmi2MCyvqx4Evu5bDVHEbSxR5oFI0jznIf586Yqn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDoWuandJ4vZfm/yMHehmH4Nswiv4ANmvB00lzZaygsy5ldf3cLhLzliTlPRc09rk
	 5DRnhzu/h7f66/Wlo4RoHYJ65WEEmh5Kx5l4/N+DhgQc++L2O7dFdA7KG7UxIJsc3t
	 yqs9Mv+jaOBHdQhxwwm7GCIwACSesg8FiD81B/fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dingisoul <dingiso.kernel@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH 5.15 198/570] nvdimm/bus: Fix potential use after free in asynchronous initialization
Date: Mon, 13 Apr 2026 17:55:29 +0200
Message-ID: <20260413155837.875795642@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -492,14 +492,15 @@ EXPORT_SYMBOL_GPL(nd_synchronize);
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


