Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1191D32FA3D;
	Fri,  9 Jan 2026 11:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959647; cv=none; b=Re10JKHKOZkM2opEumpV9zOQ7DpB6olkya6swL0xNdnS1HC7td3wJIwxqqWONJHQ69LLLjfDyVk+IiH8c6/hWeYINaza9bNv2QnorA8BG4s28YZLVAbcHj8qNwKSRgk1ESBNIymkxwMuBpsVh4sdcSpwVw96xs5vBDEAb7MVdjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959647; c=relaxed/simple;
	bh=nomSJoOIRRD5hyqBHiInCLRvCtJoyFm3muhcgQBnB3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKE1YFnxJWV2GHmVSpYGcw3QzoSSRLDTTrSfFfZSev/g481M/Av127Dh7kuKyBHH1TyfbD9fxvZJxxGZ3hII30eVBxKRXWzUjfZIoh98zxaW9Rj4jrmpkLvzcwR1Drr5PFTummZXqwPft4laA2osOEmlpn4VbIyTIZZJhYOp/KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5G2JH45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5G2JH45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875CAC4CEF1;
	Fri,  9 Jan 2026 11:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959646;
	bh=nomSJoOIRRD5hyqBHiInCLRvCtJoyFm3muhcgQBnB3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5G2JH45mzKMy6+RdPQkVV3Ufg8W+Tk7CxG7pQ50jVna/eI50CS9c96HOIlTEllKG
	 HG/Lagqvl+LkbRd6R1wu6riZhucydRZDZZ6CiRzOPcOU60gV6IttAvuB5vsrmudKEF
	 dErh/X5XfBzHVoMXwcIVQtDN2ipBMF+x15o+MVNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/737] mfd: da9055: Fix missing regmap_del_irq_chip() in error path
Date: Fri,  9 Jan 2026 12:34:24 +0100
Message-ID: <20260109112138.705940847@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1b58acfd067ca16116b9234cd6b2d30cc8ab7502 ]

When da9055_device_init() fails after regmap_add_irq_chip()
succeeds but mfd_add_devices() fails, the error handling path
only calls mfd_remove_devices() but forgets to call
regmap_del_irq_chip(). This results in a resource leak.

Fix this by adding regmap_del_irq_chip() to the error path so
that resources are released properly.

Fixes: 2896434cf272 ("mfd: DA9055 core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251010011737.1078-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9055-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index 768302e05baa1..bdf6401d32d76 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -388,6 +388,7 @@ int da9055_device_init(struct da9055 *da9055)
 
 err:
 	mfd_remove_devices(da9055->dev);
+	regmap_del_irq_chip(da9055->chip_irq, da9055->irq_data);
 	return ret;
 }
 
-- 
2.51.0



