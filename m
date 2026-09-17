Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16484B7A3D;
	Thu, 17 Sep 2026 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660329; cv=none; b=XcXAHgSmdFk+ZERGuXjqG7umFFMFVRgwtW3/seiVwnP3FZ2eXztHeUfNxCebsvVAw/CIc6Q+2SYZA0nmXew8vvtTWprkGsIi33lWSUfWgvF8dbXeeaQzPSDs5e2/AwLegVb0O3XXAlBeZ9WwxYf10gKyIl27RX88L4y0nTxqh6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660329; c=relaxed/simple;
	bh=CrZ5wjbU5chhoHAfS+mAp+Ej6dB8IzCNTC5Dw+nVmsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYOOgpMgqLM269Z2XG6HmUxE3YsW9M3HneQSly+Ix9OSWFVLgtUPL8ulDvENE/+GC00OBNm9CTxYSpZBTIa7ns1G/54aksFubeZXwkyY9tJOk0z3dXzKjFuYYcZT1IQZbXM9j4XN5HnOodt72XxpNvOcE1YSolQGZJJWXLbwySU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUBNQT87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUBNQT87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3248C1F000FF;
	Thu, 17 Sep 2026 15:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660327;
	bh=aEr6iGyRDXcTwAotc2TJcrLjE/ylIssyoHDCGBJL/qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUBNQT87gLjwMXSagBFP5l2otSIzHgiN5vPnnGDxGM3eL811ZbiBX/fX/UCPVNJVY
	 BnrTOtYbh42y+2/pGvz/6Mnezi7BS0rg51GL1ovuaKKC27G0s3ngMpRsKJSgpgq9y8
	 bXKKHEGdem1SNPFFj0xf3kiA+h/7N3zOsCVkaHh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 7.2 555/733] vdpa: ifcvf: Put device on unsupported feature error
Date: Thu, 17 Sep 2026 16:14:23 +0100
Message-ID: <20260917151406.111423937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -724,7 +724,8 @@ static int ifcvf_vdpa_dev_add(struct vdp
 		if (config->device_features & ~device_features) {
 			IFCVF_ERR(pdev, "The provisioned features 0x%llx are not supported by this device with features 0x%llx\n",
 				  config->device_features, device_features);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err;
 		}
 		device_features &= config->device_features;
 	}


