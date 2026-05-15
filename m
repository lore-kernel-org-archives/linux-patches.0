Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B245F4C6EE3;
	Fri, 15 May 2026 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862406; cv=none; b=Ix1QsHdYijSz7scwHw9Yspu8WvS+FNFrrvgPYUzpaGEWh08yKm6znh5S+SJ3ogYx+VrTEeGeE85QpkOzjv5kQRCSyPcxKlAu5e8VUIWyBzTvYjKZRDq5uQ35s/NLxStSw64zqybLWteY1I64gwZuUfAgbr3Dik6qLqcqWiqfCuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862406; c=relaxed/simple;
	bh=yE7I/29KigPC4hM2VPdLQbQqlBiidtkxh/DUeCyVmFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDvetKQwqqwghg1lrOhJdTSgcG72KwSuBQLwLqFlohw6xXfBGO/OsftIjCThGjfyNrR7knFc/VdsjLz196ZFGgpbGGSXtCqf3+IxKzgdFpGdz55baWHxkolj6XgL0m0MjQLVITnQK5MH48UDotUT9JERqQAmF/o36KqbeG4rLF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaPsA89z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaPsA89z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D477BC2BCB0;
	Fri, 15 May 2026 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862406;
	bh=yE7I/29KigPC4hM2VPdLQbQqlBiidtkxh/DUeCyVmFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaPsA89zNJWAm7quEJN3igP+sj7PLon3dW7luqxHOSXnBPtvCMG1oqNjhezx9IIli
	 iNIkgUJrdTPyVT1Oi3d6nhg3VVGHalFxpbUlvIdJsHJ92eJtuStcykPejVZsl6goyJ
	 kSzbTdFemL1CJzCQ3229kdEFomv1oAHG246DWFq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 035/201] media: ti: vpe: Add missing v4l2_device_unregister in vip_remove()
Date: Fri, 15 May 2026 17:47:33 +0200
Message-ID: <20260515154659.295319013@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit f3e969a5b54304cab6891a58d9dd8b29072bde4c upstream.

The v4l2_device is registered during probe but was not being unregistered
during remove. Add the missing v4l2_device_unregister() call to properly
clean up resources.

Fixes: fc2873aa4a21 ("media: ti: vpe: Add the VIP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/vpe/vip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti/vpe/vip.c b/drivers/media/platform/ti/vpe/vip.c
index a4b616a5ece7..0e91e87bda9b 100644
--- a/drivers/media/platform/ti/vpe/vip.c
+++ b/drivers/media/platform/ti/vpe/vip.c
@@ -3641,6 +3641,7 @@ static void vip_remove(struct platform_device *pdev)
 	}
 
 	v4l2_ctrl_handler_free(&shared->ctrl_handler);
+	v4l2_device_unregister(&shared->v4l2_dev);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.54.0



