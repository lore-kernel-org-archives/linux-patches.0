Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D042D541B;
	Thu, 15 Jan 2026 17:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499047; cv=none; b=duMOwRk+sELnkBOyRKlAWifU+hvoTTD1bCQdNHvyaBFA9IR3l2ihGbPfsjxTfsT4V0oblPuHRjMlZFk3Rw2PaHYCLaJBzJs3rfzR3IJnz3GcpAK/OUxunK2MQRrK55xXsucfD2yUeMyIK86rViVQ/H1cLkLBEx6ss16naDowu2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499047; c=relaxed/simple;
	bh=LmOevlg9aZ+c4xXUnJv0DTpum6gNNYzYfHWdytnxmT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vqy+QtgHDL3NV6htOcJ0+iPmr1JMI6SkdM/8vPSUezxZuWaYU97LHE5Oa9fYi/1OX+10ebakGzFQ0sYjO8Ra6772dVcgxJ77rQjJ+xMejoZAV+Gx5vGGk0ZEf0Zj+eDX780limGmsSz0s9VlUYqWaDt7RIdtJIJK+BWVQbhBGfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VYQTmZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VYQTmZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0582C116D0;
	Thu, 15 Jan 2026 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499047;
	bh=LmOevlg9aZ+c4xXUnJv0DTpum6gNNYzYfHWdytnxmT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VYQTmZ5GzUq7IF9Q+VzG+7t/PregDDXXp/gp2lhpnw3NHeden3z2htP0K9DST2KN
	 18pG9HmrSDjVpGnliYQX/xns0i7j8zRpqXv3hiLSOGWpsOZv+3U5yMeIQ8gNhF0SO9
	 UBwVAxZKx0hdEhfA3rmdN8A9o/Aci8Sw7Xw/61tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/451] mfd: da9055: Fix missing regmap_del_irq_chip() in error path
Date: Thu, 15 Jan 2026 17:44:17 +0100
Message-ID: <20260115164232.925348180@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1b58acfd067ca16116b9234cd6b2d30cc8ab7502 ]

When da9055_device_init() fails after regmap_add_irq_chip()
succeeds but mfd_add_devices() fails, the error handling path
only calls mfd_remove_devices() but forgets to call
regmap_del_irq_chip(). This results in a resource leak.

Fix this by adding regmap_del_irq_chip() to the error path so
that resources are released properly.

Fixes: 2896434cf272 ("mfd: DA9055 core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251010011737.1078-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9055-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index 6d0af8486269a..4f57766b42496 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -410,6 +410,7 @@ int da9055_device_init(struct da9055 *da9055)
 
 err:
 	mfd_remove_devices(da9055->dev);
+	regmap_del_irq_chip(da9055->chip_irq, da9055->irq_data);
 	return ret;
 }
 
-- 
2.51.0



