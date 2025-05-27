Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736EF3C01;
	Tue, 27 May 2025 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367280; cv=none; b=maK1Ju59xlj19cVzYt9ulgyW+0jkshkFtUzKeIFbYtD3+ERD6dOG48Ua2arAiQYWKSilC7R9A1J9GZ5tOS0SVICciy0fbff0hzdGV4fTiZa299IWSzlDSwo80zxavqPfIlTd645Oix/bS52NruBSVF3Yuk9iWLRYfOWiUhdBJJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367280; c=relaxed/simple;
	bh=lA/+wO4qfs5S6T75s34/sO35fJ2rK9atjJPdxHeuvfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcscGYBPJ5ldq4YGd67KCawRPxnoO27/5xkNf3NzT+odxJmDd31m1Eg6V5vskxN6jAkGT+cflhooxP8Fs0BiDzUHrvHEejEP7bAPWfKYKphSyTVJkYIbo1MEVxNxgpZp69CAXYSLtBt0NlVsBSGTblS1JIfONVTGUyKCRSaC6eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xI1Z0rhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xI1Z0rhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D245CC4CEE9;
	Tue, 27 May 2025 17:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367280;
	bh=lA/+wO4qfs5S6T75s34/sO35fJ2rK9atjJPdxHeuvfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xI1Z0rhdqv9Lo2BbSlz0RtynORJJH0Ps7x4196ZZgtJcUKALvV/SS3EuFkWiVPjtZ
	 2opu+VkAQW45m/PIyQ+I8LlxFuxZWIsc7NAmlb7BBAL6k+sxdERLTjgbnmS2oEc9qz
	 DdM7DB+yt3HZatUGMzCEdBghlnq2wbuf+V9y5yaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 336/783] leds: pwm-multicolor: Add check for fwnode_property_read_u32
Date: Tue, 27 May 2025 18:22:13 +0200
Message-ID: <20250527162526.743768250@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 6d91124e7edc109f114b1afe6d00d85d0d0ac174 ]

Add a check to the return value of fwnode_property_read_u32()
in case it fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://lore.kernel.org/r/20250223121459.2889484-1-ruc_gongyuanjun@163.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-pwm-multicolor.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/rgb/leds-pwm-multicolor.c b/drivers/leds/rgb/leds-pwm-multicolor.c
index f80a06cc31f8a..1c7705bafdfc7 100644
--- a/drivers/leds/rgb/leds-pwm-multicolor.c
+++ b/drivers/leds/rgb/leds-pwm-multicolor.c
@@ -141,8 +141,11 @@ static int led_pwm_mc_probe(struct platform_device *pdev)
 
 	/* init the multicolor's LED class device */
 	cdev = &priv->mc_cdev.led_cdev;
-	fwnode_property_read_u32(mcnode, "max-brightness",
+	ret = fwnode_property_read_u32(mcnode, "max-brightness",
 				 &cdev->max_brightness);
+	if (ret)
+		goto release_mcnode;
+
 	cdev->flags = LED_CORE_SUSPENDRESUME;
 	cdev->brightness_set_blocking = led_pwm_mc_set;
 
-- 
2.39.5



