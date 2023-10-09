Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D3519464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJ+P8Nw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40541C433C9;
	Mon,  9 Oct 2023 13:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857187;
	bh=vXv2LftSo1EZ6aZVzbA2zA+1gwYwVOwEMr8qJxHMGwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJ+P8Nw+uz6BSd+HZCyQAZvuI2S72fWzRZshwn0EpaVbcg3W8eqLZu29wIxyknisj
	 XtCaRqR3DZlBw7BudFzAwKRLJCSlaH6uO4iUaStBsDrh4+X4RfnQOUoNRpUX7dxpNe
	 zMokBvxf+mI8MTZUHkrrFIYKs1/IvsF7SAvrXzm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 090/163] regulator/core: regulator_register: set device->class earlier
Date: Mon,  9 Oct 2023 15:00:54 +0200
Message-ID: <20231009130126.521994833@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 8adb4e647a83cb5928c05dae95b010224aea0705 ]

When fixing a memory leak in commit d3c731564e09 ("regulator: plug
of_node leak in regulator_register()'s error path") it moved the
device_initialize() call earlier, but did not move the `dev->class`
initialization.  The bug was spotted and fixed by reverting part of
the commit (in commit 5f4b204b6b81 "regulator: core: fix kobject
release warning and memory leak in regulator_register()") but
introducing a different bug: now early error paths use `kfree(dev)`
instead of `put_device()` for an already initialized `struct device`.

Move the missing assignments to just after `device_initialize()`.

Fixes: d3c731564e09 ("regulator: plug of_node leak in regulator_register()'s error path")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/b5b19cb458c40c9d02f3d5a7bd1ba7d97ba17279.1695077303.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d8e1caaf207e1..2820badc7a126 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5542,6 +5542,8 @@ regulator_register(struct device *dev,
 		goto rinse;
 	}
 	device_initialize(&rdev->dev);
+	dev_set_drvdata(&rdev->dev, rdev);
+	rdev->dev.class = &regulator_class;
 	spin_lock_init(&rdev->err_lock);
 
 	/*
@@ -5603,11 +5605,9 @@ regulator_register(struct device *dev,
 		rdev->supply_name = regulator_desc->supply_name;
 
 	/* register with sysfs */
-	rdev->dev.class = &regulator_class;
 	rdev->dev.parent = config->dev;
 	dev_set_name(&rdev->dev, "regulator.%lu",
 		    (unsigned long) atomic_inc_return(&regulator_no));
-	dev_set_drvdata(&rdev->dev, rdev);
 
 	/* set regulator constraints */
 	if (init_data)
-- 
2.40.1



