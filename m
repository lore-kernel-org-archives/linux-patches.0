Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96933B9927;
	Sat, 17 Oct 2026 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257536; cv=none; b=YqtX5gT0VwCnryQvCCoORWzMMjgYxeMSNa15TERQmeSJAQypstPJ8IzBrjG94lYBlDA3Ns9K8WiIXOVilQC/LX5Z9TuMzzExQhGWQeMktNkMQyJjRoccjFmDgLoZ+H+xL/SWhaE1mFosgBNx8LbLt4fOv3/2913gh6GAFqe00es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257536; c=relaxed/simple;
	bh=31nQc9Xd1mRAG6zv00sEFfGMLUNvSLfWo+thW7/bbwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pG2QnTly78q8iHnNSiUSZ0dZ+51ALEm9Jt6ja4HRDFZs5JybIXH/IZggm1GxurJCWDJNKZ5Bk0vU0hwiFJeCTUzUBAbe/BJ0R819gzneFlnO/o69g/+OgGtGXc/zktYN8OWBDrtNcWfWtT6yt9CkzrBAhJ1oXL9QkiuSHogF++U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/GAyoXa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/GAyoXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8D31F000C4;
	Sat, 17 Oct 2026 17:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257534;
	bh=diEvl+JagMtwgqnoaSM8k6qKnzXC0htcIvh2Sn1/jkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/GAyoXa0LQH94f7reE5rlXRUhRaG+v2NyxWcYOiKetHDraxvbWojhq5u3eI3yMZZ
	 zN5EDJXuWKU/bzigEG16v5n2UL/uhStfttP3Sej8SoLx/VXk7aVVD7ICUv1rlidL/4
	 V0UPXF9jh/TgEY+HwfxkmReY9ImS/KqeL0tVQZGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Navaneeth K <knavaneeth786@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0590/1674] most: core: fix resource leak in most_register_interface error paths
Date: Sat, 17 Oct 2026 17:47:42 +0200
Message-ID: <20261017160446.229075607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Navaneeth K <knavaneeth786@gmail.com>

[ Upstream commit 1f4c9d8a1021281750c6cda126d6f8a40cc24e71 ]

The function most_register_interface() did not correctly release resources
if it failed early (before registering the device). In these cases, it
returned an error code immediately, leaking the memory allocated for the
interface.

Fix this by initializing the device early via device_initialize() and
calling put_device() on all error paths.

The most_register_interface() is expected to call put_device() on
error which frees the resources allocated in the caller. The
put_device() either calls release_mdev() or dim2_release(),
depending on the caller.

Switch to using device_add() instead of device_register() to handle
the split initialization.

Acked-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20251127165337.19172-1-knavaneeth786@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/most/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/most/core.c b/drivers/most/core.c
index 5d073b3d27967..0fbf06d34e0b9 100644
--- a/drivers/most/core.c
+++ b/drivers/most/core.c
@@ -1286,15 +1286,19 @@ int most_register_interface(struct most_interface *iface)
 	    !iface->poison_channel || (iface->num_channels > MAX_CHANNELS))
 		return -EINVAL;
 
+	device_initialize(iface->dev);
+
 	id = ida_simple_get(&mdev_id, 0, 0, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(iface->dev, "Failed to allocate device ID\n");
+		put_device(iface->dev);
 		return id;
 	}
 
 	iface->p = kzalloc(sizeof(*iface->p), GFP_KERNEL);
 	if (!iface->p) {
 		ida_simple_remove(&mdev_id, id);
+		put_device(iface->dev);
 		return -ENOMEM;
 	}
 
@@ -1304,7 +1308,7 @@ int most_register_interface(struct most_interface *iface)
 	iface->dev->bus = &mostbus;
 	iface->dev->groups = interface_attr_groups;
 	dev_set_drvdata(iface->dev, iface);
-	if (device_register(iface->dev)) {
+	if (device_add(iface->dev)) {
 		dev_err(iface->dev, "Failed to register interface device\n");
 		kfree(iface->p);
 		put_device(iface->dev);
-- 
2.53.0



