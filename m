Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1470340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301061; cv=none; b=KNF89/Le06nZQi8Q7chuRX5KLScWX8hYbtCbxxoyL18cnrBd6Vq32ZMPBa0XjTI0Wnk8p0ytNpY+dZ1lRBM74tymhdDZD/ZogdpC5DYOpvj48dlocwshP1Upq2QpYH+5WLxfskyGjsLa6O3xHxOb+d7xb6YnqYhQmMCHpGbaLPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301061; c=relaxed/simple;
	bh=kuip02XYYUcT7Wff0IA+vk3H5TdO8JVrUUmowrLODW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0dx95Rw8bHtIR/G8Ezk7KN1N3iapE5H6R4qYhO/YwotAWOqmuFNgruQ2Re6SVhGbo1X7qXcGj9tPwFUlN93WVY3JbB5oPwYufuAOhZgJniGSTUFI8Rr5R/PSs0R2lak/ztImC/LtbzNUDN2/uRJ+L4iQ+11tMi476H79AHIsmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miF24SIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miF24SIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300B0C19423;
	Sat, 28 Feb 2026 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301061;
	bh=kuip02XYYUcT7Wff0IA+vk3H5TdO8JVrUUmowrLODW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miF24SIh/fgMi1LWKO3k1loFFbCO3Uk2OnGIxXxyQfDzIDBIhXY3GW7PhH5ysGCUU
	 HnuMPMEiAXCtUGJZ21VRiuMGh1HA+5t1ve+NNMGFo1eNKlIYS6UjOO08PgN5wJmqLK
	 +9Ak+fbQhS5BuzqYm9iWbSNHnHACWwpmey8tuvs31LY2Gd78yHHjySLa27hV4+HEoD
	 5HqoDhI7qPl7Ti77/agKinP7Ql0+1x2VEYZQgLzCdjZfXL+8EY3tZMRBeelSc33AQX
	 h1dpqxd4M6kWKEoUhD8xnt1M1cccwcxO3CBN5N8M4oeSnQfDnavaJI9kkRuLFoDHLx
	 Q0uzw+g/inztw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/752] power: sequencing: fix missing state_lock in pwrseq_power_on() error path
Date: Sat, 28 Feb 2026 12:38:35 -0500
Message-ID: <20260228174750.1542406-204-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit e1dccb485c2876ac1318f36ccc0155416c633a48 ]

pwrseq_power_on() calls pwrseq_unit_disable() when the
post_enable callback fails. However, this call is outside the
scoped_guard(mutex, &pwrseq->state_lock) block that ends.

pwrseq_unit_disable() has lockdep_assert_held(&pwrseq->state_lock),
which will fail when called from this error path.

Add the scoped_guard block to cover the post_enable callback and its
error handling to ensure the lock is held when pwrseq_unit_disable() is
called.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Link: https://patch.msgid.link/20260130182651.1576579-1-n7l8m4@u.northwestern.edu
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/power/sequencing/core.c b/drivers/power/sequencing/core.c
index 190564e559885..1fcf0af7cc0bb 100644
--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -914,8 +914,10 @@ int pwrseq_power_on(struct pwrseq_desc *desc)
 	if (target->post_enable) {
 		ret = target->post_enable(pwrseq);
 		if (ret) {
-			pwrseq_unit_disable(pwrseq, unit);
-			desc->powered_on = false;
+			scoped_guard(mutex, &pwrseq->state_lock) {
+				pwrseq_unit_disable(pwrseq, unit);
+				desc->powered_on = false;
+			}
 		}
 	}
 
-- 
2.51.0

