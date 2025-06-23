Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046BE227E8F;
	Mon, 23 Jun 2025 21:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713950; cv=none; b=TS6gmxfKnj72ZgkkTIdWMW9Gw0hsIZsot0flBDAWrKvWZSF0jjM0WmSjea2e78mkkTC0RWd9QrBUplp1V10zj+2APtWyAZUmPEOT9PUqLXsJMggQJL9BSCAbE2pOnU9y8/2Hsq2LL0fvgQyv8hVg0qefGXSjotiWysL8lwILKRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713950; c=relaxed/simple;
	bh=hXaMSKxYkWG6jH8uKdGeJ0EpzdPF3Wec2ADQiaAyIeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPuktHcvnz15xG6nT4iV7QQzNtULgEWIyfTGkSa1sblq9qgjGmurwUmte17jpdri3i/Op50yVb9RKV5AbknbiXRmhvfL+GVvULcZjS9eGm1zSb3ASH+1w8TuHjzNpp4ahHVHh4srmkAouBJ8CRumqUIqjKvjnxgBA6w4+EANppg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzNt7QB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzNt7QB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90803C4CEF0;
	Mon, 23 Jun 2025 21:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713949;
	bh=hXaMSKxYkWG6jH8uKdGeJ0EpzdPF3Wec2ADQiaAyIeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzNt7QB45/3MnhF6sb9JY2RqtpXUe3SeZ1p3CQ+okCphY99Od565fRJtjofbU+u+D
	 aqaQBMeg8c9PvW7ZBeawOVNkaZJ84YoigpkUg8N1a0jamjRzr7YemQxH3p2UjXM06U
	 aUSu7sHetsxZx9mS5bE8JP81qzuQOo25r4oQmymg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/508] backlight: pm8941: Add NULL check in wled_configure()
Date: Mon, 23 Jun 2025 15:03:01 +0200
Message-ID: <20250623130648.635562953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit e12d3e1624a02706cdd3628bbf5668827214fa33 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
wled_configure() does not check for this case, which results in a NULL
pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: f86b77583d88 ("backlight: pm8941: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: "Daniel Thompson (RISCstar)" <danielt@kernel.org>
Link: https://lore.kernel.org/r/20250401091647.22784-1-bsdhenrymartin@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 527210e857959..434c6c499fdef 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1406,9 +1406,11 @@ static int wled_configure(struct wled *wled)
 	wled->ctrl_addr = be32_to_cpu(*prop_addr);
 
 	rc = of_property_read_string(dev->of_node, "label", &wled->name);
-	if (rc)
+	if (rc) {
 		wled->name = devm_kasprintf(dev, GFP_KERNEL, "%pOFn", dev->of_node);
-
+		if (!wled->name)
+			return -ENOMEM;
+	}
 	switch (wled->version) {
 	case 3:
 		u32_opts = wled3_opts;
-- 
2.39.5



