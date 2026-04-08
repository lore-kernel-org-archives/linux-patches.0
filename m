Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41592727F3;
	Wed,  8 Apr 2026 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674112; cv=none; b=oZ0QvwytU2TpiB7poHrJNPQ8nEOJxEbWyFCnWRw6iQNrMhqXYh/yvQ4/mUNnS+gDk038yldPTqw9IchAEb/BwYEIGXbzUaWPinTbqALIdyEJ3ct66Bc5CCi5daLbd1JGEJ2bA7NNY1Phb6G7lzKGepQXWgvJjY2UPxJmsts5YZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674112; c=relaxed/simple;
	bh=A8Yq6J+QruGxV7QpNZnLxUXPcDfVEWWysJmPpDfjdns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3TjVba7OKZV6RGH+HjDIN6QKuLLbsvOmWt8G9U5PE84IvzxzK/OiOTK8em+L+y/CXHRgygRUlsjc4qyInjkYepsPDkeFrdp0JHbpnXIP+Iea+WZyyeDY3IrgA0GCtjPmUWLPTs1oXjgowf8M5i0Cp7cZgN6LGtE2r1tCrPM9Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8YRNgma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8YRNgma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A240C19421;
	Wed,  8 Apr 2026 18:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674112;
	bh=A8Yq6J+QruGxV7QpNZnLxUXPcDfVEWWysJmPpDfjdns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8YRNgmaLf4j18DLs7SqviNSgON3ixCnkGzYqjUGoK+uLg8kyhd36E6s/NuMCJn/3
	 nzAwxPinNtE0PWGvxGQ465HGTyRq35qgAZuVF0yZAIzoiBsXXD6mZtGFpQP91sQeqB
	 JEOQ7Ifm20dyuy7D7sZvhDuWkEaf+sxJwCfIzmhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/242] net: mana: fix use-after-free in add_adev() error path
Date: Wed,  8 Apr 2026 20:04:15 +0200
Message-ID: <20260408175935.127265019@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2823,6 +2823,7 @@ static int add_adev(struct gdma_dev *gd)
 	struct auxiliary_device *adev;
 	struct mana_adev *madev;
 	int ret;
+	int id;
 
 	madev = kzalloc(sizeof(*madev), GFP_KERNEL);
 	if (!madev)
@@ -2832,7 +2833,8 @@ static int add_adev(struct gdma_dev *gd)
 	ret = mana_adev_idx_alloc();
 	if (ret < 0)
 		goto idx_fail;
-	adev->id = ret;
+	id = ret;
+	adev->id = id;
 
 	adev->name = "rdma";
 	adev->dev.parent = gd->gdma_context->dev;
@@ -2856,7 +2858,7 @@ add_fail:
 	auxiliary_device_uninit(adev);
 
 init_fail:
-	mana_adev_idx_free(adev->id);
+	mana_adev_idx_free(id);
 
 idx_fail:
 	kfree(madev);


