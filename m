Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C65F359709;
	Fri,  9 Jan 2026 12:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961652; cv=none; b=kg7Dg/4Tx95xpR3cFZW0Mx3IDuVMMzuYbkwA4hNAZH2hYo5wd+lOFcXW8Vy1ylMbz53yLbEa45gQ7euNdLaYQu54sTlQn/WtIIZsJ0dubknN5JVB1DtGqAOiEZk1G+HaEFJKg/gvM2KTUZRjIERp/yKpreYONEEDtv17wekiwcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961652; c=relaxed/simple;
	bh=PF00AUJ/MBJXMqdhnLBPOiJ+NaybHY8JqZvUXjO1gJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOEp1UD+3ym9MeKjljHerYZdQdNmGDAgwt33kYE3uS/U0pwXZTpcmjI+FjNzWvIBJdfDbXePYD7pRdBH2GvjmZsLYmkPgdolr9FxhxmcRqxOSQ3XmcZpyvbUydfYORNrn/zGGzqiq4A0lb6oKRRpoBByMpHyy6HysBzTohjGqsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCR7wm3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCR7wm3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88814C4CEF1;
	Fri,  9 Jan 2026 12:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961651;
	bh=PF00AUJ/MBJXMqdhnLBPOiJ+NaybHY8JqZvUXjO1gJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCR7wm3BJgOWQ/NOSAg0ogmqZzDqcCtxMjGZyUZcir4jmbPXCT0iTcUoTkkKqWno8
	 KFpRU1IbqiVHLnbfD6IcoRdhlU9ORX7q82NT2I9r94PAFW4XIPA2cj3nK3BxhkeYQ7
	 ZIxTQZkIMaf6X/evcpwN5GB1ZcMKMcxw78Le2AEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/634] regulator: core: disable supply if enabling main regulator fails
Date: Fri,  9 Jan 2026 12:36:06 +0100
Message-ID: <20260109112120.746882478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit fb1ebb10468da414d57153ddebaab29c38ef1a78 ]

For 'always-on' and 'boot-on' regulators, the set_machine_constraints()
may enable supply before enabling the main regulator, however if the
latter fails, the function returns with an error but the supply remains
enabled.

When this happens, the regulator_register() function continues on the
error path where it puts the supply regulator. Since enabling the supply
is not balanced with a disable call, a warning similar to the following
gets issued from _regulator_put():

    [    1.603889] WARNING: CPU: 2 PID: 44 at _regulator_put+0x8c/0xa0
    [    1.603908] Modules linked in:
    [    1.603926] CPU: 2 UID: 0 PID: 44 Comm: kworker/u16:3 Not tainted 6.18.0-rc4 #0 NONE
    [    1.603938] Hardware name: Qualcomm Technologies, Inc. IPQ9574/AP-AL02-C7 (DT)
    [    1.603945] Workqueue: async async_run_entry_fn
    [    1.603958] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
    [    1.603967] pc : _regulator_put+0x8c/0xa0
    [    1.603976] lr : _regulator_put+0x7c/0xa0
    ...
    [    1.604140] Call trace:
    [    1.604145]  _regulator_put+0x8c/0xa0 (P)
    [    1.604156]  regulator_register+0x2ec/0xbf0
    [    1.604166]  devm_regulator_register+0x60/0xb0
    [    1.604178]  rpm_reg_probe+0x120/0x208
    [    1.604187]  platform_probe+0x64/0xa8
    ...

In order to avoid this, change the set_machine_constraints() function to
disable the supply if enabling the main regulator fails.

Fixes: 05f224ca6693 ("regulator: core: Clean enabling always-on regulators + their supplies")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://patch.msgid.link/20251107-regulator-disable-supply-v1-1-c95f0536f1b5@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 7e6ff7e72784b..436764329f63b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1660,6 +1660,8 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 	 * and we have control then make sure it is enabled.
 	 */
 	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
+		bool supply_enabled = false;
+
 		/* If we want to enable this regulator, make sure that we know
 		 * the supplying regulator.
 		 */
@@ -1679,11 +1681,14 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 				rdev->supply = NULL;
 				return ret;
 			}
+			supply_enabled = true;
 		}
 
 		ret = _regulator_do_enable(rdev);
 		if (ret < 0 && ret != -EINVAL) {
 			rdev_err(rdev, "failed to enable: %pe\n", ERR_PTR(ret));
+			if (supply_enabled)
+				regulator_disable(rdev->supply);
 			return ret;
 		}
 
-- 
2.51.0



