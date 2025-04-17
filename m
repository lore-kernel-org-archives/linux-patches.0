Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE6F256C79;
	Thu, 17 Apr 2025 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915825; cv=none; b=SIRdGmmp8tglLEoLXEU8xMvSFuR2k8bBKQuRbzb5/oL+qDAQkhvh8Gsc8SQWESjLag7TJUmc4/Q9HAPtmkf/kGUovSoH75LMDWlMnNHHmRDCLiWcHMyNcrZIvaYV23GCnFqfvNgs24iTKe10GRdSSHjC18A5T3OPu6Z/tcAyXzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915825; c=relaxed/simple;
	bh=Q90m5EDc/V900k092uWcOCcW7JYcjBLlK0tQ/fHQETQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kl4QUIAUXfqNr4s4GSf9JM4al8gQsPpT/DOhTNeSE1nvlDAZejXClr8NxlZBRZ+M5aRJJo56BREGopqxk1M1gm3pwnUv7zXi8T7D1SyXxhtcMqM+A4p7Q5iKcM75QJuGPlTAYm4YyaHD+ziQzfpbatjLIi8NK9WBhMbusWvxguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5JOY4D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5JOY4D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB71C4CEE4;
	Thu, 17 Apr 2025 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915825;
	bh=Q90m5EDc/V900k092uWcOCcW7JYcjBLlK0tQ/fHQETQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5JOY4D+7qJDLQFUC2h1RThvOnPFjGmhj1kzCmL44FSvl8BgIn7Zm99OhOd32YEdZ
	 k3FH4/o4KgZmx2kG3qrLLprpIsqikH8Idr1P84iYDN201ncaLQxHQelXeO7Af8+enB
	 8RAHL7v/VwFUGNdMnf5m2RHGF4rJ7boDtIMR99Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 223/393] media: nuvoton: Fix reference handling of ece_pdev
Date: Thu, 17 Apr 2025 19:50:32 +0200
Message-ID: <20250417175116.553431631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 453d5cadab1bde8e6fdd5bd05f4200338cb21e72 upstream.

When we obtain a reference to of a platform_device, we need to release
it via put_device.

Found by cocci:
./platform/nuvoton/npcm-video.c:1677:3-9: ERROR: missing put_device; call of_find_device_by_node on line 1667, but without a corresponding object release within this function.
./platform/nuvoton/npcm-video.c:1684:3-9: ERROR: missing put_device; call of_find_device_by_node on line 1667, but without a corresponding object release within this function.
./platform/nuvoton/npcm-video.c:1690:3-9: ERROR: missing put_device; call of_find_device_by_node on line 1667, but without a corresponding object release within this function.
./platform/nuvoton/npcm-video.c:1694:1-7: ERROR: missing put_device; call of_find_device_by_node on line 1667, but without a corresponding object release within this function.

Instead of manually calling put_device, use the __free macros.

Cc: stable@vger.kernel.org
Fixes: 46c15a4ff1f4 ("media: nuvoton: Add driver for NPCM video capture and encoding engine")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nuvoton/npcm-video.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -1671,6 +1671,7 @@ static int npcm_video_ece_init(struct np
 			dev_err(dev, "Failed to find ECE device\n");
 			return -ENODEV;
 		}
+		struct device *ece_dev __free(put_device) = &ece_pdev->dev;
 
 		regs = devm_platform_ioremap_resource(ece_pdev, 0);
 		if (IS_ERR(regs)) {
@@ -1685,7 +1686,7 @@ static int npcm_video_ece_init(struct np
 			return PTR_ERR(video->ece.regmap);
 		}
 
-		video->ece.reset = devm_reset_control_get(&ece_pdev->dev, NULL);
+		video->ece.reset = devm_reset_control_get(ece_dev, NULL);
 		if (IS_ERR(video->ece.reset)) {
 			dev_err(dev, "Failed to get ECE reset control in DTS\n");
 			return PTR_ERR(video->ece.reset);


