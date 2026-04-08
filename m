Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F621355F30;
	Wed,  8 Apr 2026 18:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674265; cv=none; b=fi4KkbHsVfdtqdzjNIAWmR4cQZK6Bio0R6iqvFHngSihQ02Du50LbCcGZpyuWP9pe26PndNpukIHsZUYdus5gJ6fQFhuFfES9at0MF3yuT+P/KHOP4T1WU0clcrcWpi3jmZiAcN4tZlgURBZURVJgBwl59pJkIDk7nKoJjdnumc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674265; c=relaxed/simple;
	bh=WpNNJ4cOrRWLqxrPK11JpUVTiraMO3LmT97qu7U7TLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqEUZLtSpiIfxpEFEIDyEgrU6WsHirx++WdS8bgvfxZDopzm4p9l5AcA3lLhgklkfA/bbdH+gXNL360LCKJQ7VTr3UgesIV49GlKWBAuDj6s083+PAumIfjxb2ppCXSGdMyOmhJvXy4QDDf5eSYAlscpKLPnTCWJycrGFNsdEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkMfgs3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkMfgs3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E726BC19421;
	Wed,  8 Apr 2026 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674265;
	bh=WpNNJ4cOrRWLqxrPK11JpUVTiraMO3LmT97qu7U7TLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkMfgs3x+4bumXBqTtSbioVT4XHSLbN70Dm4uPQ/0UPuXGXlUemOY1w9UaqrfT4bo
	 V2Uk8ztkgpsCHO6hNgj1smxWzuV7vUl0aLzKXZL9XXIilpLok7eIBgq4BKMwQ3nLem
	 qJJJRqaacUj89sZu4xwvlCefxPjXeGwwmjxyPA+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 003/311] net: mana: fix use-after-free in add_adev() error path
Date: Wed,  8 Apr 2026 20:00:03 +0200
Message-ID: <20260408175939.529390134@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit c4ea7d8907cf72b259bf70bd8c2e791e1c4ff70f ]

If auxiliary_device_add() fails, add_adev() jumps to add_fail and calls
auxiliary_device_uninit(adev).

The auxiliary device has its release callback set to adev_release(),
which frees the containing struct mana_adev. Since adev is embedded in
struct mana_adev, the subsequent fall-through to init_fail and access
to adev->id may result in a use-after-free.

Fix this by saving the allocated auxiliary device id in a local
variable before calling auxiliary_device_add(), and use that saved id
in the cleanup path after auxiliary_device_uninit().

Fixes: a69839d4327d ("net: mana: Add support for auxiliary device")
Cc: stable@vger.kernel.org
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260323165730.945365-1-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3376,6 +3376,7 @@ static int add_adev(struct gdma_dev *gd,
 	struct auxiliary_device *adev;
 	struct mana_adev *madev;
 	int ret;
+	int id;
 
 	madev = kzalloc(sizeof(*madev), GFP_KERNEL);
 	if (!madev)
@@ -3385,7 +3386,8 @@ static int add_adev(struct gdma_dev *gd,
 	ret = mana_adev_idx_alloc();
 	if (ret < 0)
 		goto idx_fail;
-	adev->id = ret;
+	id = ret;
+	adev->id = id;
 
 	adev->name = name;
 	adev->dev.parent = gd->gdma_context->dev;
@@ -3411,7 +3413,7 @@ add_fail:
 	auxiliary_device_uninit(adev);
 
 init_fail:
-	mana_adev_idx_free(adev->id);
+	mana_adev_idx_free(id);
 
 idx_fail:
 	kfree(madev);


