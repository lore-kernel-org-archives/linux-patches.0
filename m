Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFA83B776A;
	Thu, 17 Sep 2026 18:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671033; cv=none; b=V9lFEMNgpan3ea39ohPCZFnL6SNDoLev1F5+6bUvxPonSSPAFWssowH3BYDhQQqN6G74t+gB63FdxrY1ibK7SAq50B4sYunzDAfIhAM5SG4hLEQ7LryY2aGFdZrstor/p9Ifmke57dgFub6lz09S+GFxhm6W1abe8pUrYLMaous=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671033; c=relaxed/simple;
	bh=Xvqfh2dPTE1IUwPxkETfxVV1EG5LgqVTmgBBRArhb78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFg7a7YrdNUfHjOsUZP5zrl2/8PBnDZ/qSld97NOwYAoSp06HBNuJuXqzi2x8nlXi9W6bTG0LFE57Np0i22fsx5HIx9Bd7T4IHscZ8RNKNV1qLFX751os20ckMrHm8dkqX/WUP8kGUG5/UJIO4OFJ5edLV2/+CK531rn89Ke+q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcHj0frF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcHj0frF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9644C1F000FF;
	Thu, 17 Sep 2026 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671032;
	bh=JvXHtHjC1AROms98n+vUqlF9gTYt8jh8G8BuCRps94w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcHj0frFdXD4LW3R34aBDWLhFAOBnBNfzBKyaonBEXJcFoi0c5R/G/9dxPh5uOICP
	 KlE4vPe1droMK5r0+ctrHPjY+qlMEjMdHQo62qt2H3kz1Tp7XY2ivER4OdHT9wp5tz
	 qDI/sMfw1r1hghNtfgd7soTlkYfzVvb3jf7HIWfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.12 0848/1102] vdpa: ifcvf: Put device on unsupported feature error
Date: Thu, 17 Sep 2026 16:13:11 +0100
Message-ID: <20260917151601.822146633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -723,7 +723,8 @@ static int ifcvf_vdpa_dev_add(struct vdp
 		if (config->device_features & ~device_features) {
 			IFCVF_ERR(pdev, "The provisioned features 0x%llx are not supported by this device with features 0x%llx\n",
 				  config->device_features, device_features);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err;
 		}
 		device_features &= config->device_features;
 	}


