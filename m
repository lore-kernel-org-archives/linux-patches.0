Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53BF1ED4D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD06C433CC;
	Tue, 25 Jul 2023 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285263;
	bh=NyAdYL3puK8Z0+vIaY8L9hEWumESJZ4u1TPX2pr7yvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LL+IYCz8r4rdvKUlEa8oOcpp6JqAHYNCykkt718siXMSzd+Y0m18+5wrEUjmvBeR8
	 FqzTknXSCnsTOR9VMKGMXqK7EJgA7m3ZMJA2lEJ5/1ICPk6CFbkw1vyXu58w4+545y
	 IAx59ms+aiGySZF5JZTdsylc6lSqmaAOkBeGVw0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/313] mfd: stmpe: Only disable the regulators if they are enabled
Date: Tue, 25 Jul 2023 12:44:55 +0200
Message-ID: <20230725104527.139173900@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 104d32bd81f620bb9f67fbf7d1159c414e89f05f ]

In stmpe_probe(), if some regulator_enable() calls fail, probing continues
and there is only a dev_warn().

So, if stmpe_probe() is called the regulator may not be enabled. It is
cleaner to test it before calling regulator_disable() in the remove
function.

Fixes: 9c9e321455fb ("mfd: stmpe: add optional regulators")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/8de3aaf297931d655b9ad6aed548f4de8b85425a.1686998575.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 508349399f8af..7f758fb60c1fa 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1494,9 +1494,9 @@ int stmpe_probe(struct stmpe_client_info *ci, enum stmpe_partnum partnum)
 
 int stmpe_remove(struct stmpe *stmpe)
 {
-	if (!IS_ERR(stmpe->vio))
+	if (!IS_ERR(stmpe->vio) && regulator_is_enabled(stmpe->vio))
 		regulator_disable(stmpe->vio);
-	if (!IS_ERR(stmpe->vcc))
+	if (!IS_ERR(stmpe->vcc) && regulator_is_enabled(stmpe->vcc))
 		regulator_disable(stmpe->vcc);
 
 	__stmpe_disable(stmpe, STMPE_BLOCK_ADC);
-- 
2.39.2



