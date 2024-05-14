Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711045028C;
	Tue, 14 May 2024 11:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687546; cv=none; b=Vk8hPbRbIOf/8w5+r543tXQ88KgUwJmzLkH5D3WpZFtVB2HMliNlV3MAKO86OXrIDyXyjJLQOGxYRLcDt8zNoU1CwlcaNRpD7pQ+Daf/hdDvUaSPpYX1Hh+Z8cXIKdq0Gj+3NhjuEaHoXEZ2BaaBpk3u9ZVsiBOAQLCBANml7JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687546; c=relaxed/simple;
	bh=Pmfo8r73Yy9Yz7OGcyMPQYyqQ4HwllQv5BdE/1ppnLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1d53p8/5RIaxiPI285NQK5SBNZysG9IDUdFiRfgAJhZ3EPUP6+fU0eg3v+TxN6JX6uIXJigaQfJnky0Uo8KSCZSTxy8qCH3aUesCditWR71G3T1DSP/v3GMiwq/3jeys6vilxJp0SWVaexac1vIBid0xf3wR63nTSjXXbG0QD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yB2DWe9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yB2DWe9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA259C2BD10;
	Tue, 14 May 2024 11:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687546;
	bh=Pmfo8r73Yy9Yz7OGcyMPQYyqQ4HwllQv5BdE/1ppnLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yB2DWe9KHef7DtGOaK2n+T2pZ8uAgGosrhQSOf/qpz9Q3WWpPnNp7aavrZQa+Heqc
	 Ng8RB6wvcjL/QWThVph0NwdN2sopaN+npJ1nVl8xxSLynIhg1qkRA+DFBvqJJ3AEqk
	 P6yUYLsgaRJpQAYxZUIih8k2Wer1/0h0wa8GzLJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/168] pinctrl: devicetree: fix refcount leak in pinctrl_dt_to_map()
Date: Tue, 14 May 2024 12:18:40 +0200
Message-ID: <20240514101007.526689826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eac55fee5281c..0220228c50404 100644
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



