Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA083CF039;
	Wed, 30 Sep 2026 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795641; cv=none; b=jW6P7LEAIQq77uRg158lUd4k1QgfwexffVs6dvxIB2yQtvMGPkl95HtGzEKPWFTb9DZSV7c9HsH7U2sntFIhIZbuXMeBxZwmOHcMur60qsIeWlll+JPRFJ0hxEeOMUzb3j73J+vCpeYjdGaxpqIc6XmPITCpFZkyoTYrw0Md9OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795641; c=relaxed/simple;
	bh=MmMk+X+9iUmtS4cWPL0Jkh+jeGWZJsGRnORATWA+6I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptPUSuvK7HtaY8aIc3ts8KtsnrYHvXn71IWK7WCPkZqvxeOX9NXNWUt9u8XdTfM7brQ2Y0YvMHLieuP+IfTE+jIULYl7EOcE9tohbW5WdC//jfMluOE7ZKDqjbcBh8D0HcLPPbwICG1Skn0SxAXNS96vff/JcUfx1rgmrC7+lq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcdeYSCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcdeYSCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54791F000FF;
	Wed, 30 Sep 2026 19:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795640;
	bh=enmqfIzaYL7meK9X/XmZyyqT3AInNNKWIxAAx1n+EDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcdeYSCun+8qQSYeq4E7NbS5B6N4blYYuBDHAfu89K8rn4+STzXt32O+xKmkGIAVU
	 yyrUsdt9d5vdy8sWf30uuSNPeP/r1TC5cwuF1oU5MnrUUtPi8y+WxbUmJNxiUzgXfO
	 WXB2YK3oO9Ymfmh9zbqQTHR1VW3bKtGpypDHZJHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.6 0632/1193] vdpa: ifcvf: Put device on unsupported feature error
Date: Wed, 30 Sep 2026 17:21:56 +0200
Message-ID: <20260930152448.285188537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Xiong Weimin <xiongweimin@kylinos.cn>

commit 4d470be71196ca0ce302e6623454533dc31b465b upstream.

Route unsupported provisioned features through the common error path after
vdpa_alloc_device() so the allocated device and adapter pointer are
released consistently.

Fixes: 46fc0917bbab ("vDPA/ifcvf: implement features provisioning")
Cc: stable@vger.kernel.org # v6.3+
Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <178589471294.1556376.4816776800128323034@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -708,7 +708,8 @@ static int ifcvf_vdpa_dev_add(struct vdp
 		if (config->device_features & ~device_features) {
 			IFCVF_ERR(pdev, "The provisioned features 0x%llx are not supported by this device with features 0x%llx\n",
 				  config->device_features, device_features);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err;
 		}
 		device_features &= config->device_features;
 	}


