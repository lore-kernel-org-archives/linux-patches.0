Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1396C359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302459; cv=none; b=qLHpDJbvMvhV0L9kt2X4D50d2Kwa78nqUuo2dDGozWeGRnwFDDApGiZUm7pxZwndSfgQt80cTfFaxQ4OYE52m7zr4q8zFLldpWtAuxdi/oSBmHHKElsFa20cFopGwDlCj6IKaS2X6fBdOEGcPHzVD/Cz5bFE8PUTt6iumfwAF0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302459; c=relaxed/simple;
	bh=PT0jcGeYv/3Ji78TidBctrwqdbFgEvfjyKr81ic5vt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmPLQif823ssJ2och+zch9s1QTHko1yGswnNshlJ2AJomxM1d+jwpN2QKN0/YNSemQlbVqgQJBtLZjDgi65xMK9TvI1Jj1X/MuUiuCIoa0gwWkLi7aznLyflCF1XLyNXUol+GBwNO5vZAEtA7girOm3Z0E2LSGntDYyxZNT2jCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGp1E+QZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGp1E+QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749DCC19424;
	Sat, 28 Feb 2026 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302459;
	bh=PT0jcGeYv/3Ji78TidBctrwqdbFgEvfjyKr81ic5vt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGp1E+QZf+lfWq551Oy5LCCy9XJ3I/3DZiRvSS4Uno6H58IO49FfyWBlZH1F7RjnH
	 arINYjkBAFjKO4fnYSvvb7GmIxYoEARApVOcyQdbgkbBFVdbRgAMljc54riz04r15r
	 RUe3MSeRBCuTuwuoQm6MKpz+8BW1tqacMAXsk7mEBeF/TqPKV5LuiMFdBxDP92BGnN
	 W345PzFcrqzlM5E4r7Ct8tevugD1EUNIJSvHDztVjY2o3Co/vob48eQCuAqJzqUk7k
	 zXW0FF8vC0jwpq33Pikkj2GLoXN7lrUNTUhfukucre0M2c4jTi5xCkiuAW/lDhCXC2
	 fdev5MXMikIyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wei Li <unsw.weili@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/232] pinctrl: single: fix refcount leak in pcs_add_gpio_func()
Date: Sat, 28 Feb 2026 13:10:53 -0500
Message-ID: <20260228181127.1592657-200-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 0659cd3aa3a5a..2c5b5ce60248e 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1364,6 +1364,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		}
 		range = devm_kzalloc(pcs->dev, sizeof(*range), GFP_KERNEL);
 		if (!range) {
+			of_node_put(gpiospec.np);
 			ret = -ENOMEM;
 			break;
 		}
@@ -1373,6 +1374,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		mutex_lock(&pcs->mutex);
 		list_add_tail(&range->node, &pcs->gpiofuncs);
 		mutex_unlock(&pcs->mutex);
+		of_node_put(gpiospec.np);
 	}
 	return ret;
 }
-- 
2.51.0

