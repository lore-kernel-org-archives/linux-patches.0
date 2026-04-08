Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B3727979A;
	Wed,  8 Apr 2026 18:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673537; cv=none; b=kHOFetzxmTAd3WMIvDxbyyG+ydVVi8NVzh/IXpri2pn2kUJUluhBt4PTE9TT5VzZV4Onw2yFm25U/o+onPk7/aHqt5kHew8+20ycF1qDBc0Q+0vsQ9q827iHy3eOiWmICkhZXKtgkXXyMZssvHt3/U44fC10KXwI6ujy3T+ji7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673537; c=relaxed/simple;
	bh=0UcbJQomOFHIMEJzK8bla3h6cE5TjyQIRiNtGfloZpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aure05r5k7wvsjdsa2ZVfuqV4r54Sn/VVDUtK+QYBSqibzoiJ+62eaBn4doS+M52zCzTh0GIkPHUU51X05rWvBWP06DGJFpis31BAwjhN4G701pf8JgX9xO42s1N3PkKvIykaGz4i4U/5if0djrI1IB2kt31q7ysL+Eybs9v9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1lrv1nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1lrv1nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94356C19421;
	Wed,  8 Apr 2026 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673536;
	bh=0UcbJQomOFHIMEJzK8bla3h6cE5TjyQIRiNtGfloZpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1lrv1ndjLLWpdl4OIOpnbyUlEkpolXA5tPz9k3DxNHnJiK4AFkRyZQxyQPZUcZ3q
	 gmhCgRETRJjtBj68muk0fkM0MfmUelTbitzif0vPgLY/hHjwukOQfPEbW0gWwgb1TC
	 9AvMFu+/Fe+McJ56Ulqv95kyUYPUay61DhydJFBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/277] net: mana: fix use-after-free in add_adev() error path
Date: Wed,  8 Apr 2026 20:04:15 +0200
Message-ID: <20260408175943.947242329@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3302,6 +3302,7 @@ static int add_adev(struct gdma_dev *gd,
 	struct auxiliary_device *adev;
 	struct mana_adev *madev;
 	int ret;
+	int id;
 
 	madev = kzalloc(sizeof(*madev), GFP_KERNEL);
 	if (!madev)
@@ -3311,7 +3312,8 @@ static int add_adev(struct gdma_dev *gd,
 	ret = mana_adev_idx_alloc();
 	if (ret < 0)
 		goto idx_fail;
-	adev->id = ret;
+	id = ret;
+	adev->id = id;
 
 	adev->name = name;
 	adev->dev.parent = gd->gdma_context->dev;
@@ -3337,7 +3339,7 @@ add_fail:
 	auxiliary_device_uninit(adev);
 
 init_fail:
-	mana_adev_idx_free(adev->id);
+	mana_adev_idx_free(id);
 
 idx_fail:
 	kfree(madev);


