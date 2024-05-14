Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C201212C554;
	Tue, 14 May 2024 10:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682124; cv=none; b=uKvelspay2iRu/hPe5Hp8OSI5sob0yUbSZ0LTb3g1hRkUIPKrYQ/Uk3DIOk4crvIsxa7vQPUbZo45XqdIlCZnsVGXbbnyq5G+GLC2R2px4urWsijlEls+NCQRRjh5koNR6qMYum16QEYckvjUhgJp9DaEcILjPtaV7KlBrNaAGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682124; c=relaxed/simple;
	bh=QtX+27Q02jJFc7Z9pdxyngXJVDsbWnarSzHyHME+uDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeC+LyY2fPIDJL1PQY5AwCQbJXFyuSMnrBVcCUGRk5Y0qBWcB7QLHi7lRQPuFyQsGw976uMqdluEUUfybqkuALZXRuj4uvJDIqGBpDLcC+GtuzdPds5GmrgLyKoMh0L3DaMNXQ/6OT/fhe0mXW3tsz6+cEpdM+x6n+voOWgEfaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3GLtg4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3GLtg4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A75C2BD10;
	Tue, 14 May 2024 10:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682124;
	bh=QtX+27Q02jJFc7Z9pdxyngXJVDsbWnarSzHyHME+uDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3GLtg4/QQ314dWAsDA0jqZK0f2Wkj/elMO+p1LCljxfU6j6fdm8C62cIfc96s8Lr
	 W21KnMVPLfnOEHCKHGKokmhMLBl+ampt7AOFbaogXKtrQABWnuVTUqp9fd5Ix8LIjy
	 z9/zR9q6J8uxqw/F0+nIze/f4Kzm+KCt5LlmsjQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 016/336] pinctrl: devicetree: fix refcount leak in pinctrl_dt_to_map()
Date: Tue, 14 May 2024 12:13:40 +0200
Message-ID: <20240514101039.219988806@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index df1efc2e52025..6a94ecd6a8dea 100644
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



