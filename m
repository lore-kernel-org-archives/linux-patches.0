Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E947346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302237; cv=none; b=nhwt9Eojh9gvijH3JJdZlAZG62p4M0YrkMaxOQzc+RNCsLvo4+veF30dUKMYp3xBIv4Sx4XLfM6kqVCy0Y52bd7P8g6icJS40wb1YgAk5b5/hQef+gCvdPVtVU/3xfbuHEa1DmMIzPSLxYSlF6uLUcsjNz5YRMYA4H1nF8q4tUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302237; c=relaxed/simple;
	bh=Wyu88rKKlR6lI8rjrNumn18f+8jR67I5mTu22BQpEqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpqaHSCLU2Hbq6zWBs5RoCIq7IT/qRvddPQRNIHdt0Sw1gejQcD4gf5/VNjVmR66bvZHr1dB5ktPoh5yw0niBck89YyNbtuI6P8simkgm1cygmQPDNxafjEDCeh/KYnOsYD9pzG9d3FCVV+dyL72u5hVnkkStafab1Bs7zBYZzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRwXEmzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRwXEmzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0B6C19423;
	Sat, 28 Feb 2026 18:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302237;
	bh=Wyu88rKKlR6lI8rjrNumn18f+8jR67I5mTu22BQpEqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRwXEmzfu2N8rzFZZDdKnkFbUucp0caO8hdwaSuplzX3ZtfdNNVMp69tb/veoJOZs
	 4p1nqz6efuERFrYLFjl3z/eS7XEWSGhch9fuu38HSY1qqdyAGmYkd6Deh6nDWL81P/
	 /xOfKuDyVYz8hR0BfpZrzeAV28yK7nD/W/B1pjFdQFeiFN9ihU7KaaQe/FUb93AhQE
	 nFbSQAs/PSjhR/JrI4Vucf3xpmq0sBP8Vfkvan4nroZG3XsAn2aAOr63btWlFT7xSK
	 lyRb2whiexha+2cutKzgamu9e6oS/VIgIIwUfUDPXPrIDzmB7XvOB4qUBzRGsUo3q2
	 FrJogFWH7/n0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wei Li <unsw.weili@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/283] pinctrl: single: fix refcount leak in pcs_add_gpio_func()
Date: Sat, 28 Feb 2026 13:06:30 -0500
Message-ID: <20260228180709.1583486-248-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 2ee0ee3b6ed14..4aadafe2c50a5 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1363,6 +1363,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		}
 		range = devm_kzalloc(pcs->dev, sizeof(*range), GFP_KERNEL);
 		if (!range) {
+			of_node_put(gpiospec.np);
 			ret = -ENOMEM;
 			break;
 		}
@@ -1372,6 +1373,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		mutex_lock(&pcs->mutex);
 		list_add_tail(&range->node, &pcs->gpiofuncs);
 		mutex_unlock(&pcs->mutex);
+		of_node_put(gpiospec.np);
 	}
 	return ret;
 }
-- 
2.51.0

