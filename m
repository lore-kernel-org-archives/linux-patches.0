Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F281B39B94E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302631; cv=none; b=PcnpPfnPxzYPysTGfJohpiSQlht4jURNz7XmD1OSgRZYz91AQ7HUtdV/qFepAcPlfKDQIDD1IeFl76iI/IuCJXEmj5t+t7U/bvgKPlDVCjiFZP97VwF8HHFdKDJiNYCwB9eALeYqBcJ6FeP3eANOt4mKD7ne5fepbwyZWxnh6A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302631; c=relaxed/simple;
	bh=PT0jcGeYv/3Ji78TidBctrwqdbFgEvfjyKr81ic5vt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEJZ2ocmUHk3VfFK7eQUi6+BBPl36agaYvCMl8xxtBx3mqPPW5ZFqo4fBw9WeOW/99MX8z32lUKxfSoE2PUbV7cVikmw+6KpDECSn74xwjWhkXlLIaeg4YDZE6KAwE8gIwdDe8c+nIv3nr8MZtkse1+SOMxaeUWZBD6Dkjqo2Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpc8DZw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpc8DZw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C18C19423;
	Sat, 28 Feb 2026 18:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302630;
	bh=PT0jcGeYv/3Ji78TidBctrwqdbFgEvfjyKr81ic5vt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpc8DZw27NwY0EXK/zuLd/0e8W5vCZ0hkHYn251rJJlNnIKmNxgMgwHIXDb1rKBeU
	 BPGlO/wTqkzuL4R31VwSnpHWmkmnzZHGNdX9NJocS1MTmHfxsu4d9y6fV+Dc1YWwB8
	 tiPqMyJFVbnvOKwaDLkH12hoNjGkcIgMBuzheMqAxnOMkHSwlKFL0xWtW4GUXb0uu+
	 4FyuzSwNdndHiQgA9qutx5hzRiCwWTgZZMF2eAVu+WVg/rW/XtXGp2gKp2uC8txqYf
	 HplqlATQ3babRWLEopm8Asdr1INAGzDQgj6GuW496G159bN2IqNO2QFVTVCb6B712v
	 AJCEC1d6mDK9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wei Li <unsw.weili@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/164] pinctrl: single: fix refcount leak in pcs_add_gpio_func()
Date: Sat, 28 Feb 2026 13:14:49 -0500
Message-ID: <20260228181505.1600663-150-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

