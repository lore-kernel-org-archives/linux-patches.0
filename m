Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D576D10965;
	Sat,  3 Feb 2024 04:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933649; cv=none; b=kQR5xArrlXVGBhRwslN1yu+2Ac1tpSLL9v4w2Mxr6RaDJR7I7QZNe0CvpXMtPCQBL2XWdg1dSGOSFcC6/gAH5z+BBr5oxu58MgHw5ALIyXVj7t3qw5Sn5ufVfgyI3E3HjJ1vztKCanj2p8UFA3uGJZY/WZis72MtYtXOzZ5mcU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933649; c=relaxed/simple;
	bh=LuTKsXiec32VQxbd3Pi7pvzg1FHlVQjhE8mw3FqVpPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX7j/oQF78zkEe87oOlFOofxRRA6YFVVptWcI5wIBnKu81sfK6xqZxweicUKfayapkSBSbyTTjRtDrcsElPxULzCMTYAwv86ix/6V6TTUn1P2Dz306dcuYWnDVZy0xLW4EGqbjXKmm62NPEX3Q6rhedApSzOQ5MVqhq32ULmWJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlpQS6Hj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlpQS6Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCBFC433C7;
	Sat,  3 Feb 2024 04:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933649;
	bh=LuTKsXiec32VQxbd3Pi7pvzg1FHlVQjhE8mw3FqVpPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlpQS6HjIqXssSJUhb1iPdY3QtKdk5lK21jGDhrZ8mIJaGfcodKqIseqjPaeZ5AQt
	 zMrL0kjGCMjtDYjEz1qR4IkTjdsAfJDshrqSFmI3g1w/eTlLqRPEVHav9QbR5Nyamn
	 gb8eTdKPH4exae2Pbt0Sw4CExhpQLDNUgznsWUVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaxiong Tian <tianyaxiong@kylinos.cn>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/322] extcon: fix possible name leak in extcon_dev_register()
Date: Fri,  2 Feb 2024 20:05:30 -0800
Message-ID: <20240203035406.721778460@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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



