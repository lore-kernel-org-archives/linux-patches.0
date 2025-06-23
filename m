Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FB919049B;
	Mon, 23 Jun 2025 21:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715514; cv=none; b=s6XoVfT6oI6oCbf1Q/DmJHBkD+pqN8o0uv61juEISJ3c83W8vAovZwiMLsbsPHIGbH5murbNFbEMNbsdYADX1ukirhwuRa/QDJ99IXizUIiLGZbSXIMYbkcTZCNbivxIXHrDsN1lG5243y9InP5K3p10t37AmuMJWntmgxCCuww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715514; c=relaxed/simple;
	bh=isD6UlRdCjiO57F6yBt1fVlpyeDjyfSCpkx8W/jj2lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skdjpsIoUa/JPMAzc5onbJRdpZ0xv2W3qCX7WB3Fg1p1sKX47b54upMeE/+GBnyepXOEVTryEye0KeloIaAay3mIuyC1kmDrIKuAW8dxSX8lo27bYdZ2YSER+64j3oMkZbDTgTp7XWfVYszCxaqqM4GcAikmdnXUYQAkMLdn72w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lB0/8nFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lB0/8nFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF5AC4CEEA;
	Mon, 23 Jun 2025 21:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715513;
	bh=isD6UlRdCjiO57F6yBt1fVlpyeDjyfSCpkx8W/jj2lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lB0/8nFaXiYZCpTx6qXtxl/8NH5/WsOMBrFzDXxe6zDbOHs2LIvc6XIANn9WALu2w
	 DGuy+oMgJb8VEN+anQqvbZlJ7vGSaQyuDWcKSx/FfNuX7loC5csy3XVwSypsFm8PpC
	 zUNz2q/RM9apdg89wRfOV0crnBsWEQ5azgTe+GZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarang Raval <tarang.raval@siliconsignals.io>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/411] media: i2c: imx334: Fix runtime PM handling in remove function
Date: Mon, 23 Jun 2025 15:07:06 +0200
Message-ID: <20250623130640.748563033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tarang Raval <tarang.raval@siliconsignals.io>

[ Upstream commit b493cd3c03641f9bbaa9787e43ca92163cb50051 ]

pm_runtime_suspended() only checks the current runtime PM status and does
not modify it, making it ineffective in this context. This could result in
improper power management if the device remains active when removed.

This patch fixes the issue by introducing a check with
pm_runtime_status_suspended() to determine if the device is already
suspended. If it is not, it calls imx334_power_off() to power down the
device and then uses pm_runtime_set_suspended() to correctly update the
runtime PM status to suspended.

Signed-off-by: Tarang Raval <tarang.raval@siliconsignals.io>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx334.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx334.c b/drivers/media/i2c/imx334.c
index 57b7416bbfab3..af09aafeddf78 100644
--- a/drivers/media/i2c/imx334.c
+++ b/drivers/media/i2c/imx334.c
@@ -1102,7 +1102,10 @@ static int imx334_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 
 	pm_runtime_disable(&client->dev);
-	pm_runtime_suspended(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev)) {
+		imx334_power_off(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 
 	mutex_destroy(&imx334->mutex);
 
-- 
2.39.5



