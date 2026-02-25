Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5223518DB2A;
	Wed, 25 Feb 2026 01:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983111; cv=none; b=Tggv2Nf1fa99xcisH9c/60L5oqO/UYxeVyrWAkR1GtoisSIfguqRY2gUVbP9lb1bvbXEqbgrqvxefY6WLX2M2kX2o2rSDk0/T+I4befzVkWuCQg1YX7nqhBahPssMS3wE9Bvd9+jBSpbfl4EJdAwHPbOrqj5XYHzWLoXiwS5Nz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983111; c=relaxed/simple;
	bh=zf2CqcKrZolEImqZaDmnKQPceJr54m0E9GiTgvmpFI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VdM8pqB4vhFNdup5oB39R52on6Jo3CHjwpes1TEKcUhnliJIwMubWG+n38n7S5BvyicCxTh8v/zOu7jOpI+iiJZhxoKgJWNdDMVVvI0AQkpAvGSVsnyh2Iug410XHLq5x3d4joMhOo2hTu/F4vRrBjHheC8A30eegwxsne3VgFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1T2rHv4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1T2rHv4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F91C116D0;
	Wed, 25 Feb 2026 01:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983111;
	bh=zf2CqcKrZolEImqZaDmnKQPceJr54m0E9GiTgvmpFI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1T2rHv4n7A56Ua38TlLFfoIVThGPjnhN1RofLl6bresbcuk14wQ23UeXaPwqdkwss
	 0qqn3+ST0MGtJRGZsDFe/ZrgOYfW7Rmz0BQMqByrgIuurndoViAvj8SGc4PChWq9JD
	 Xwm1mg/Sb1+CrHeKvVkaIdagQ3vbQiLw7wNzYOmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 254/781] regulator: core: fix locking in regulator_resolve_supply() error path
Date: Tue, 24 Feb 2026 17:16:03 -0800
Message-ID: <20260225012405.937724195@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 497330b203d2c59c5ff3fa4c34d14494d7203bc3 ]

If late enabling of a supply regulator fails in
regulator_resolve_supply(), the code currently triggers a lockdep
warning:

    WARNING: drivers/regulator/core.c:2649 at _regulator_put+0x80/0xa0, CPU#6: kworker/u32:4/596
    ...
    Call trace:
     _regulator_put+0x80/0xa0 (P)
     regulator_resolve_supply+0x7cc/0xbe0
     regulator_register_resolve_supply+0x28/0xb8

as the regulator_list_mutex must be held when calling _regulator_put().

To solve this, simply switch to using regulator_put().

While at it, we should also make sure that no concurrent access happens
to our rdev while we clear out the supply pointer. Add appropriate
locking to ensure that.

While the code in question will be removed altogether in a follow-up
commit, I believe it is still beneficial to have this corrected before
removal for future reference.

Fixes: 36a1f1b6ddc6 ("regulator: core: Fix memory leak in regulator_resolve_supply()")
Fixes: 8e5356a73604 ("regulator: core: Clear the supply pointer if enabling fails")
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20260109-regulators-defer-v2-2-1a25dc968e60@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4b6182cde859a..b2dcd1acd0ece 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2285,8 +2285,16 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (rdev->use_count) {
 		ret = regulator_enable(rdev->supply);
 		if (ret < 0) {
-			_regulator_put(rdev->supply);
+			struct regulator *supply;
+
+			regulator_lock_two(rdev, rdev->supply->rdev, &ww_ctx);
+
+			supply = rdev->supply;
 			rdev->supply = NULL;
+
+			regulator_unlock_two(rdev, supply->rdev, &ww_ctx);
+
+			regulator_put(supply);
 			goto out;
 		}
 	}
-- 
2.51.0



