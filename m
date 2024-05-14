Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F19139D15;
	Tue, 14 May 2024 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684623; cv=none; b=i7zajfW5F904BAF8u6XxaqsYjp8Z0Prd6JQDwHBEd0DnFcY+NMwF9OmWpTplEqL232Gw5SzBKgUGObJfVf3h3T6gWGOzDvzSKxLN4YJX7DiZQfVGuKbXpkOGQDrHSwB7XbQMcnwnrgJs3h3q3QX6ElI+LOdLNLCXrQcIUXp3/OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684623; c=relaxed/simple;
	bh=B2xlL3tkl4l7QJ8YW8gY4cyT4PDFo0hnsUo1BUWr+Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSMwKWDFmEtu0zFc1+aIGTV6uHez42k5RvVRnz4nWv+06p3kmeqzHmKb+ahioox0uJlYFBofqcIs74gve5Q5jYQS3t7erOEPyRFaJJAF8SzULBv5H32Oh7YMH0VBy+uJzRs9Gvc+XhyxJQyNnuyMUjZzpYGSvMHTJcZRCWsrPRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9j4RLtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9j4RLtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D45C2BD10;
	Tue, 14 May 2024 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684623;
	bh=B2xlL3tkl4l7QJ8YW8gY4cyT4PDFo0hnsUo1BUWr+Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9j4RLtMKGhqe6nvUeE4IewuAgr39g1k92YXY7Aet/BD71gSRVC4cMna/OzDS2wMV
	 d+1cfaghhJ3o9VJlIqYK61p7AalaGQmPUrXN7NdQKNAoR9T7gzIGkmIFog2V+U/xhC
	 rb3dS68SxnNciBCEpWvQiEUb6q2ZoZtXgXOVSX8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/301] pinctrl: devicetree: fix refcount leak in pinctrl_dt_to_map()
Date: Tue, 14 May 2024 12:14:55 +0200
Message-ID: <20240514101033.158214285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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



