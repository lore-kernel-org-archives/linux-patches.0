Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E8C43E088;
	Tue, 21 Jul 2026 22:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672366; cv=none; b=dyKnmBY1LRfvv7wZCFQpDX9bz+4zPJOFDTD2yEmsNE02hAWYxhR7fFqV3cNd+PSDYetn5Hsgj1acvhIHVzNc+bSse4XBsiDgJ8gHrCKFp0lQqrSVv5ykTGEZYHGGXAkbPyzsUcADy887WdYeGCrlmAcvzLYoXb2DgYo41nxAOwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672366; c=relaxed/simple;
	bh=KVCEqCnr+46CcKcy0Ov/yg4gqJQSv550YdfBA2j/Q2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHgZ+9PXUMbvi4kCI7qIAMPyon6mlV66I7DsPdlU2PbZ5ezP2qHwXbke/e5i5jBXdZp9OE/z7yAGPIp399vz99mnqOWO6BLkVxwy+RBTohGmAI5o1jQIR9M2H/+Cc0FvPEBMPcFBFsZ/Y38A6jQUjTZ49GsE/m9QE6SrbobJmCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQ5hWEfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQ5hWEfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7561F000E9;
	Tue, 21 Jul 2026 22:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672365;
	bh=He1wK38o9m2OynQaCfpp60sQN9FeeLFEPFK+rHH4CSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQ5hWEfHhWEMijhPd0XMhXLZwkHelCPMymd85ckZiwK/ufDIuDGUOhe5NGmmJWu1C
	 eVyOxxT0Zfpvg6sSZYLgVAlbnuo2uJifKyq5mcgfl/v3u7Ati3Bt6O0ZEIjHDv6zdI
	 6axL15Hq3U6hicf5L3chmwKUy1/PAu+dXsw9iAQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 598/843] mfd: tps6586x: Fix OF node refcount
Date: Tue, 21 Jul 2026 17:23:53 +0200
Message-ID: <20260721152419.500070970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 3001ed2b4e06da2276c42ace6551617065a5b1f9 upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 62f6b0879304 ("tps6586x: Add device tree support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260521-pdev-fwnode-ref-v1-1-88c324a1b8d2@oss.qualcomm.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/tps6586x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -399,7 +399,7 @@ static int tps6586x_add_subdevs(struct t
 
 		pdev->dev.parent = tps6586x->dev;
 		pdev->dev.platform_data = subdev->platform_data;
-		pdev->dev.of_node = subdev->of_node;
+		pdev->dev.of_node = of_node_get(subdev->of_node);
 
 		ret = platform_device_add(pdev);
 		if (ret) {


