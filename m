Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0344D34250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301916; cv=none; b=stly6AzuU7QYUbK0xKRtGkhEqEcJfPMDJj0a1i3ZWZg2/wIc6CS1p6qX7fvhqmvClwN9VGxsw+xye2QGv7u0Q9c2juS3ShwYu/gAOZRHvFAK1kd92E38qN2BN/dWSzfizXwdFAEi6X3q9P0aYxQEtCJ98yB80JagNmjAEFVFEjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301916; c=relaxed/simple;
	bh=GG+SVGHWOzHlzvUYM0bUu8kewNyHl0A3P5/GzNqmg98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWlACV39TyfgSCEINkJUn7W1vsf3zKx3ovNYE0hLrYkPTnvUdrRTkyEOq19cc6f5wKMUuuEsnhdLNZBbEs4qxUuxmcwbVwOb9TXoU5RcNvEZyNDczFOctqXmcTS4AzXcFgQdOogWuAU+K066NpB2y8DgHP4hRGFk/BhGt8hDZHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bchOq0d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bchOq0d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E23C19423;
	Sat, 28 Feb 2026 18:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301915;
	bh=GG+SVGHWOzHlzvUYM0bUu8kewNyHl0A3P5/GzNqmg98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bchOq0d4Ixy4uZXx3vI4cXoyBU2wpe8v/tZaabY6SAVlTrJU+ukozMW3tKui8HWmB
	 azXQmBqty3w1r2ACqpmclBOzGN3mz4omVpgkq8EfN5UIiwLcD0zqgAqp+w7pgyy4of
	 aOH7sEQ8gNST+9rTl0S3Cxf3uTs1eUoXkD3cTqU9sBPu4yOa0Ryc9VHRDFQob02GhI
	 J+nsC3X68YILp5lRreM4/BEWoiqWHT+aNGQG7+BYCkJbQhjUSu4LreiqZdHhyXK/3R
	 v9tm3i+BuLWGMMVm/pCp/v+0T1DOwm8F3fTFyJm066jQl3xUlMKVzoIVkDcXkZ4/VU
	 Nv9PQTIZTYPJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wei Li <unsw.weili@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/385] pinctrl: single: fix refcount leak in pcs_add_gpio_func()
Date: Sat, 28 Feb 2026 12:59:30 -0500
Message-ID: <20260228180011.1568201-348-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Wei Li <unsw.weili@gmail.com>

[ Upstream commit 353353309b0f7afa407df29e455f9d15b5acc296 ]

of_parse_phandle_with_args() returns a device_node pointer with refcount
incremented in gpiospec.np. The loop iterates through all phandles but
never releases the reference, causing a refcount leak on each iteration.

Add of_node_put() calls to release the reference after extracting the
needed arguments and on the error path when devm_kzalloc() fails.

This bug was detected by our static analysis tool and verified by my
code review.

Fixes: a1a277eb76b3 ("pinctrl: single: create new gpio function range")
Signed-off-by: Wei Li <unsw.weili@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 2218d65a7d842..a2fb549307adb 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1359,6 +1359,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		}
 		range = devm_kzalloc(pcs->dev, sizeof(*range), GFP_KERNEL);
 		if (!range) {
+			of_node_put(gpiospec.np);
 			ret = -ENOMEM;
 			break;
 		}
@@ -1368,6 +1369,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		mutex_lock(&pcs->mutex);
 		list_add_tail(&range->node, &pcs->gpiofuncs);
 		mutex_unlock(&pcs->mutex);
+		of_node_put(gpiospec.np);
 	}
 	return ret;
 }
-- 
2.51.0

