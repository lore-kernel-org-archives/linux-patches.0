Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036320;
	b=zlXW+x+bkwd+kMBdYiR/h9B50ZAsDxrcUXPa77QOZ8a5FrN1gl0SkP3KEKjX7d5WzKpG
	 0zk/u27lOfiBx30z2t+P81NeSnp4eT3qYaRQ4KpQauiRC5wN/WbMqZsWiEqh56q+aBEp9
	 Pdg9ZCDZcB8l7xzLsFtQbT8eT+7hAZRdfP6Cd43GKZGRPfjoQBd1eidIylDBV9XKSRZfQ
	 HrjDtUqaiieXwgbIWPloRHTQaimpJFtaoESaWXZokxw56iMGFXJNvWF4tWt9SqEo5Vlir
	 4LZWWNoXzT8rKihy9Bu23C2Y+C1S0a5iPPXsXuQ2wo9qj+D9rKySDRaoRYpx0C2jJbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVnUTqPAuRfiK+w6u/12QfymfXFGTAqahh+fey7BMHk=;
	b=HfFZ8Vk57NURz+yC0pRd9ZXyDOiKcUStBqluawKxeBj1SvZbcRlIQP0Zbz+S79gwSOZz
	 VavN7pZr5v4td/XCbHKJeI4TWsjEe5ILs1P1y/ozaIQQUzzDTe/GUlwCYfKOLcws6fsPx
	 SrzAd5zEtY+G+w3tQNNfuSihS32ZoMv8CCLEOD6DtM2wmx12QdD+40Ph4TxasF7Mdl3U8
	 no9BqCgJs9j/pbfiHO/FvRMpYXp3DQY27ertj1018V32OPNYZCHjV2EurngTdE6qkGE16
	 xtAPTQXXiJKim9b8W6s7kK9278upGOxFb6WyV0fZ61XnSAPUOj0N1VgmcSU//u0ZkMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJN3TiLB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CE2606A320;
	Wed, 18 Nov 2026 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJN3TiLB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E59A1F000C4;
	Wed, 18 Nov 2026 21:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036319;
	bh=oVnUTqPAuRfiK+w6u/12QfymfXFGTAqahh+fey7BMHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJN3TiLBGf+6U2HgGv1zzhOGNsPUoDc4AcXCEN0F+gBauONar+Eo02mi9MOJltJjZ
	 SCyoVu99/w7/DOtNdddF74AS9c842x3fnlohnbrbax6bUOrOGw7R52nVAWs4eyC0il
	 BcAuIEy3zdQ6BhDlxiudA1fWZA8Acq+hz2yP4Pvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0974/3318] media: pvrusb2: Fix USB parent device leak in class_dev_create()
Date: Wed, 18 Nov 2026 15:26:36 +0100
Message-ID: <20261118150348.935503181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 02421d7278e4a62c3daf37ad6c45d4af96ee4252 ]

class_dev_create() stores a reference to the USB device obtained with
get_device() in class_dev->parent, which class_dev_destroy() releases.
When device_register() fails the function only drops class_dev, so the
reference to the USB parent device is never released.

Drop the parent reference on the failure path as well.

Fixes: 28c4a5e6d324 ("V4L/DVB: pvrusb2: Fix USB parent device reference count")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index 3077399901aa1..dd6fcc6245afc 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -633,6 +633,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp)
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
+		put_device(class_dev->parent);
 		put_device(class_dev);
 		return;
 	}
-- 
2.53.0



