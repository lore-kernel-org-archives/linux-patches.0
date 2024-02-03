Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707DF171A4;
	Sat,  3 Feb 2024 04:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933910; cv=none; b=afQAHOU0KpGB1sxg2ezEGJt1fMecnCl5YhAjjOZxqX5ol6/QnZbqkQr2EonquK53dsZ8v0ntWjAYtECBX4W6V4lSNBL7wkUZwuCCEVt61neAHC3DAK8i3qjVEICp+z9ed50exx8895dCIUJdUKsrAu4oB7kEOLfPfShuOdWLuyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933910; c=relaxed/simple;
	bh=ksAoScyRnTaQ3QZ8PEXzWyzaZhM7xJPaFOLLZcq+YVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mtzqyf5f8KligJgWEcJy+W1oC+D0jKitE5co90l5U6l9BM7Jj5te1rCwjWC4C0LtABrX5pn3aRjTApMoQce4znwQ7HKjO3y0CG3zLod6oLEhYZex1HqrZDmF68zvgBTJTheCTge8y2Vo/3XgliOuoX9+p7wF2ktxVEKjx7dBijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQLd6fxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQLd6fxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33455C433C7;
	Sat,  3 Feb 2024 04:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933910;
	bh=ksAoScyRnTaQ3QZ8PEXzWyzaZhM7xJPaFOLLZcq+YVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQLd6fxoz+vDy5f8/pjAXMcikMvPseSFMsFMUFhcMKMkFpcXSTAx14EWMYk/hhlSD
	 LeDARQxFYr082HtcPQRWRuQ/+Pv4w9Dst0sG0Ccoe1qwmCTucEZdu+IqABH0a7Bck1
	 1ZvAasJmYBhOuvAA7IkU8HC295MHJV7Mv3iXYFJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaxiong Tian <tianyaxiong@kylinos.cn>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 254/353] extcon: fix possible name leak in extcon_dev_register()
Date: Fri,  2 Feb 2024 20:06:12 -0800
Message-ID: <20240203035411.774807163@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yaxiong Tian <tianyaxiong@kylinos.cn>

[ Upstream commit e66523c72c9aae0ff0dae6859eb77b04de1e8e5f ]

In the error path after calling dev_set_name(), the device
name is leaked. To fix this, moving dev_set_name() after the
error path and before device_register.

Link: https://lore.kernel.org/lkml/TYZPR01MB4784ADCD3E951E0863F3DB72D5B8A@TYZPR01MB4784.apcprd01.prod.exchangelabs.com/
Signed-off-by: Yaxiong Tian <tianyaxiong@kylinos.cn>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index 6f7a60d2ed91..e7f55c021e56 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -1280,8 +1280,6 @@ int extcon_dev_register(struct extcon_dev *edev)
 
 	edev->id = ret;
 
-	dev_set_name(&edev->dev, "extcon%d", edev->id);
-
 	ret = extcon_alloc_cables(edev);
 	if (ret < 0)
 		goto err_alloc_cables;
@@ -1310,6 +1308,7 @@ int extcon_dev_register(struct extcon_dev *edev)
 	RAW_INIT_NOTIFIER_HEAD(&edev->nh_all);
 
 	dev_set_drvdata(&edev->dev, edev);
+	dev_set_name(&edev->dev, "extcon%d", edev->id);
 	edev->state = 0;
 
 	ret = device_register(&edev->dev);
-- 
2.43.0



