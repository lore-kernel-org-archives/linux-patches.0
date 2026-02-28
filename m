Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6863D34A3DC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302764; cv=none; b=vAPCWKnrooBhOVTyYfpls3EJSdhyRB6PdRVPXQwjY4947uXBCbR3AFcBAaYdFtcaJrcOy7GviNHLN4yl6IXoosjyVz8MlkpsVFtmE0wexygB4zM/XO0ZnaftMWwEnJrtqAR65NiB7EvaUoUHogcOAzCXhFhXV/PZFKSAE+gKdgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302764; c=relaxed/simple;
	bh=7FuBXoDjyFWkfqQuHCkhgl6rLFGuqtifIM7LQkIvrk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drt1A1LRGPYyhCMz12etU4K8LESElj5TaQNTLz/Q0QBa6qYAsCCOSaVJPCRs58KS1PmHhvCEFlYP8yeBo6ymWK7qgShhPakD+lbkPr528HclPta+QCd1A8To6J02OVWYqK/jQf2/UZ9L0NRHPwjnyunupHRIdEH1jr+bYGf811Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o8Nyrba6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o8Nyrba6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD239C19423;
	Sat, 28 Feb 2026 18:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302764;
	bh=7FuBXoDjyFWkfqQuHCkhgl6rLFGuqtifIM7LQkIvrk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8Nyrba6xQEpoJzYMLW1Dw99oLZS5bXugZ7ZAgOcg0Akt25zxEM9oELzgnChJ6BgK
	 oN4kRgba20ncyjO5f6JyAcjVX7F/oJYCVWJilvWIG2VCMcrAEnOVfHXzC7OlVRmysW
	 GqqnvIr34AJkLsEhrMNCGAIgNsYyVWS8iQvEr0JeN8v2uLGwt9/10ma0BwawcroH9m
	 VQgm99ejMZ0zTA4HVhdXQ9pT43ZWUuhZ4NrmWEhpN8hk/6HX8ZXityMkgBSP/oaTW3
	 PzL0MFQVaVclysTPA/QLJ0qy3W45CPzGH6Mv63kwk+ARShWGD8hPQMvBBe0EgvuqTJ
	 WXpSjl8stxJvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wei Li <unsw.weili@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/147] pinctrl: single: fix refcount leak in pcs_add_gpio_func()
Date: Sat, 28 Feb 2026 13:17:23 -0500
Message-ID: <20260228181736.1605592-135-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 07bf090420453..491a46e330b30 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1368,6 +1368,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		}
 		range = devm_kzalloc(pcs->dev, sizeof(*range), GFP_KERNEL);
 		if (!range) {
+			of_node_put(gpiospec.np);
 			ret = -ENOMEM;
 			break;
 		}
@@ -1377,6 +1378,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		mutex_lock(&pcs->mutex);
 		list_add_tail(&range->node, &pcs->gpiofuncs);
 		mutex_unlock(&pcs->mutex);
+		of_node_put(gpiospec.np);
 	}
 	return ret;
 }
-- 
2.51.0

