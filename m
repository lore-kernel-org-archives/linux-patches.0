Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9D179F0;
	Mon,  8 Apr 2024 13:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583166; cv=none; b=jNN/BFR4ngWCtj0anIPfJ5mvrFIpFuRobEPJfK3RLtJMZMGs8jVwKlbcGXxsxq35zrroNDhIiJR54LY/zIKWchXTRa4W/nlJxtWOqmhbiVQ3fbwdVhbh8JIN1lLBgBwDzJEzDAM4EftSX+TqwEq9TpHXQw5kQy1k6TXLsa0jwY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583166; c=relaxed/simple;
	bh=UA77cvTxwd0u7vzaXLYCpoIu+vTywEtcpIMiWcZo+T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ir247HkUUNr3OfFSJWc4E845X0PTlENuaSsa/j3khMTiL59+MiG+LY2X+NDSRrcvZZjEQWURDYYZjlonS3IU0JpxksjuBaxrCY3Hbs7/gpMU2H+eqBlYRUE6x4Jn21VyWKISWoK2nV12orljRFnuJHQwiTcaUjmQwuVJnrOE0EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkKGz1EI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkKGz1EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCDAC433C7;
	Mon,  8 Apr 2024 13:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583166;
	bh=UA77cvTxwd0u7vzaXLYCpoIu+vTywEtcpIMiWcZo+T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkKGz1EIPgJWBrz2fqvGpuMftAxj+ExkSUTI6TiqTCM4lSzvkCdKwdyfmjKt6Ol/I
	 2szOsRW4hRJBocfsnHeHaCKejFZsluFoJ5jKGZdMclGJY9bXppP4jMPBaxdIcTU05u
	 PZ57QdGRRa8/jY07X9YIi6K48zw85KcX1uRsr8UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Steven Price <steven.price@arm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/252] drm/panfrost: fix power transition timeout warnings
Date: Mon,  8 Apr 2024 14:57:44 +0200
Message-ID: <20240408125311.771241876@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 2bd02f5a0bac4bb13e0da18652dc75ba0e4958ec ]

Increase the timeout value to prevent system logs on Amlogic boards flooding
with power transition warnings:

[   13.047638] panfrost ffe40000.gpu: shader power transition timeout
[   13.048674] panfrost ffe40000.gpu: l2 power transition timeout
[   13.937324] panfrost ffe40000.gpu: shader power transition timeout
[   13.938351] panfrost ffe40000.gpu: l2 power transition timeout
...
[39829.506904] panfrost ffe40000.gpu: shader power transition timeout
[39829.507938] panfrost ffe40000.gpu: l2 power transition timeout
[39949.508369] panfrost ffe40000.gpu: shader power transition timeout
[39949.509405] panfrost ffe40000.gpu: l2 power transition timeout

The 2000 value has been found through trial and error testing with devices
using G52 and G31 GPUs.

Fixes: 22aa1a209018 ("drm/panfrost: Really power off GPU cores in panfrost_gpu_power_off()")
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240322164525.2617508-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index eca45b83e4e67..c067ff550692a 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -387,19 +387,19 @@ void panfrost_gpu_power_off(struct panfrost_device *pfdev)
 
 	gpu_write(pfdev, SHADER_PWROFF_LO, pfdev->features.shader_present);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + SHADER_PWRTRANS_LO,
-					 val, !val, 1, 1000);
+					 val, !val, 1, 2000);
 	if (ret)
 		dev_err(pfdev->dev, "shader power transition timeout");
 
 	gpu_write(pfdev, TILER_PWROFF_LO, pfdev->features.tiler_present);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + TILER_PWRTRANS_LO,
-					 val, !val, 1, 1000);
+					 val, !val, 1, 2000);
 	if (ret)
 		dev_err(pfdev->dev, "tiler power transition timeout");
 
 	gpu_write(pfdev, L2_PWROFF_LO, pfdev->features.l2_present);
 	ret = readl_poll_timeout(pfdev->iomem + L2_PWRTRANS_LO,
-				 val, !val, 0, 1000);
+				 val, !val, 0, 2000);
 	if (ret)
 		dev_err(pfdev->dev, "l2 power transition timeout");
 }
-- 
2.43.0



