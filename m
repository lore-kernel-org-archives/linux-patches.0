Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911B812F58D;
	Tue, 14 May 2024 11:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686145; cv=none; b=I/MOa2lfnvkRiPU+KO6BcJx9kJEqfg7lk9u9Cqj3M2cgUVoo7IJS3LcWkZ6KMRGOulmThRRm3HLtvO2/W50LYf2k86agsWGMV+9E8UiMfXWFEdSxe5lS9nVfF8tFBw14dhalemxw1DE8n9mqMHVk896xm5Yc6MpTZa6XkGq/QWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686145; c=relaxed/simple;
	bh=yKQRI8EIf71kzFNNp5CycUHZaWm0W7zLvsat78GcU0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvgMJtThb3/CJXAqR6Z9sKNnxiOPxGHUETNmbI92Rx8dgOyeCRRzNiwofswZxQbXdbIiptgO8ulB+SGAJ1swHBjE74807qYbftAURAyobBZBUlZIqfuEeJZlZ6LYmTx12TpW8rQtrA6r1Cir2olnw8OdckWKJssDInwNRzbPnQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQUEGilh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQUEGilh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2A6C32781;
	Tue, 14 May 2024 11:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686145;
	bh=yKQRI8EIf71kzFNNp5CycUHZaWm0W7zLvsat78GcU0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQUEGilhs4gw85nSZLVpUgHywwuRAPP13rFDJbOKTnrKQnnAV8jk5vmStUIexT3X3
	 R+Px/j3wGvOwHDd9GP99k76BrMYXl2aAbaI9MFnbvnov+xw8bWcAfPlDnXNHdKs3ZZ
	 78okAzmpRiOlRQEErO7lM5BEnngSVdl3NY7tQDIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/236] pinctrl: devicetree: fix refcount leak in pinctrl_dt_to_map()
Date: Tue, 14 May 2024 12:16:38 +0200
Message-ID: <20240514101021.713224398@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit a0cedbcc8852d6c77b00634b81e41f17f29d9404 ]

If we fail to allocate propname buffer, we need to drop the reference
count we just took. Because the pinctrl_dt_free_maps() includes the
droping operation, here we call it directly.

Fixes: 91d5c5060ee2 ("pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <20240415105328.3651441-1-zengheng4@huawei.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/devicetree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index 6e0a40962f384..5ee746cb81f59 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -220,14 +220,16 @@ int pinctrl_dt_to_map(struct pinctrl *p, struct pinctrl_dev *pctldev)
 	for (state = 0; ; state++) {
 		/* Retrieve the pinctrl-* property */
 		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
-		if (!propname)
-			return -ENOMEM;
+		if (!propname) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		prop = of_find_property(np, propname, &size);
 		kfree(propname);
 		if (!prop) {
 			if (state == 0) {
-				of_node_put(np);
-				return -ENODEV;
+				ret = -ENODEV;
+				goto err;
 			}
 			break;
 		}
-- 
2.43.0



