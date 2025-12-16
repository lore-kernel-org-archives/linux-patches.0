Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3754C341069;
	Tue, 16 Dec 2025 11:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884221; cv=none; b=umqe4V/pizjoKh0wKQLjxF2pgOHO9ewP+pOxR9782gJysLJOp44ZKJqxS4iDfAY+kF26P94SdVMnsnAdjYoGQBsuenl5M2k1X26EOuUmQiDIwKjyK0VWbrmtziENZMNJczHofL4D8OGeZzcuZKPvankS+46ItDzLUOvwH2MJS6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884221; c=relaxed/simple;
	bh=B7QpSf+zqVXPnSgZsAOpidHYhVjwbVk++Gwq0xtfrnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOmUew3XV6AVy8Wty9AC2fHZyCi5BYz/jsMIMJaV3oi5h5G/IRa2lIrChzbPLWhI7X7u50+D2ap+YkKhYm+ke3kFwUpgP0BJbpvWbArYUcPjow61pLrzHfm/dhitzefsacV+d704tgqAYoSswLwE6kiCLUWXl4sYYzLzZ0K7XlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+UkwhhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+UkwhhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BE7C4CEF1;
	Tue, 16 Dec 2025 11:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884220;
	bh=B7QpSf+zqVXPnSgZsAOpidHYhVjwbVk++Gwq0xtfrnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+UkwhhWZs0suGXam72+toAJYwbLldZOLIOkj66R0tHcNuLm0EsR1np7bp9neXd1Y
	 ZwJEv8MwEbfpvgAmxkwc5JR/6yxfW/D52aVUfCY0L/rl0nI0kUd2ELbfbgaeTyFhkH
	 3GDH6HSooXmJeQtpL7tCcO2aVQ3AOrNIDbUZn6fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/354] regulator: core: disable supply if enabling main regulator fails
Date: Tue, 16 Dec 2025 12:11:35 +0100
Message-ID: <20251216111325.560005626@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e7f2a8b659477..be9704d34c015 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1593,6 +1593,8 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 	 * and we have control then make sure it is enabled.
 	 */
 	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
+		bool supply_enabled = false;
+
 		/* If we want to enable this regulator, make sure that we know
 		 * the supplying regulator.
 		 */
@@ -1612,11 +1614,14 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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



