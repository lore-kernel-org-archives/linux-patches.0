Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE19533D4E2;
	Thu, 30 Jul 2026 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422598; cv=none; b=LcndL+gxm3NMAxNHweo8JYKnz+W3xKy4iaRm+nA7J2XuAcRH+XLZ5rO/BTP/isjEVUuekrcWQqnt5ldKvcj/XdiWPElSqdhVy00CmHlLBj6Dho+w1zDIl3iN1+d7OSW1BLOsXXmzoWDN3BmVXGPxNveyME3Ud5vbZuUPu7mc1Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422598; c=relaxed/simple;
	bh=D8/S1omtoSjEjOZEgLhLpWzb5a4j7FNdMdIB+UO1Fqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzMwkxkOZj3pPLXv/61NR3OmFjLR63xIDi0EdevoTAkgMNxE8Uk8T84gTcphufYgZIXh6y6Nk3I02Cucb6RCofwUwxqZYT8hPLHjBJkWFmiUXKCUAsBfsEb527VSSp8C0MUGzv/qrtd6PwgkZuSTh+1D0CyLbxDx1hNMShdXELA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiyU+BGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiyU+BGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CC01F00A3A;
	Thu, 30 Jul 2026 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422597;
	bh=BbTgrc8vzq4GYTNLeZskMonPkXGZJ5JKi6lTuk4SeZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiyU+BGbLU7fnvteeeINyVqma46SdNFUyQO4RyqC+dMOpFq6IHYAuzeI1Z1H/bdf9
	 ebHKUbPcV1LVGZm8OPcLj2bVg26tEdiYCiRpz3538Rehm8zxottDLRi4vV10OXfPof
	 ezBNbyrzn2JspASY2j/ofZyO8bmt+UYUnD0JWY4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 492/744] media: mali-c55: Power-off the peripheral in remove()
Date: Thu, 30 Jul 2026 16:12:45 +0200
Message-ID: <20260730141454.748771949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 2c9b9bcc2569f52e366ec71ca012542e161f1f8d upstream.

The Mali C55 driver doesn't depend on PM. For this reason, if pm_runtime
is not compiled in it is required to manually power-off the peripheral
during the driver's remove() handler.

Also pm_runtime_enable() is called during probe but mali_c55_remove()
never calls pm_runtime_disable(), leaving the device's runtime PM state
enabled after the driver is unbound.

Manually power-off the peripheral in remove() if the peripheral has not
been suspended using runtime_pm and disable runtime pm.

Cc: stable@vger.kernel.org
Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/platform/arm/mali-c55/mali-c55-core.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-core.c
@@ -860,6 +860,11 @@ static void mali_c55_remove(struct platf
 	struct mali_c55 *mali_c55 = platform_get_drvdata(pdev);
 
 	mali_c55_media_frameworks_deinit(mali_c55);
+	if (!pm_runtime_suspended(&pdev->dev)) {
+		__mali_c55_power_off(mali_c55);
+		pm_runtime_set_suspended(&pdev->dev);
+	}
+	pm_runtime_disable(&pdev->dev);
 	kfree(mali_c55->context.registers);
 	of_reserved_mem_device_release(&pdev->dev);
 }


