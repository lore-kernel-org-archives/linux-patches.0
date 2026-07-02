Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C02C33E355;
	Thu,  2 Jul 2026 16:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009374; cv=none; b=cIar+egfCtbTlqnya2lL1UZxv/WOVyrtUY+sIau/ezD4c26Z8yIxDHqikrzo7ZJfnUk+85ZeJpe0bsobCDyGh9HuKZwYopItPmBURji88yQtXXsBshhDC7Cyjl2Dju40KEB5xPQzlPp9a6iztxUdSm5bMI7gHcKsxXIZ8Sj78Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009374; c=relaxed/simple;
	bh=FdGofmnForuXzoSzsf0PGDkn6ueKx3g4N1I92AOkPo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HtZJxa+efNZMWC26RfJbl1ZkpH9VkDiR7+DfvpWmNxQ4q7IzuP46CyI5tA9v/Oh+R3h7hlVlC7YNbRyUDRW6scvtiLlI8Etefoat2l6ZvacBezVEK5VCb01sOgocm29HP1aKPaVM8dSq6szUNozSWNjFfqq/kqE02XN5qeCX1Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCDnWI5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCDnWI5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78E71F00A3E;
	Thu,  2 Jul 2026 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009371;
	bh=sDcrVYKF97YSIUYFGfH7SqfIBouZyAVS4ynZTtnYH18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCDnWI5B52ltY2kQJ0zXJj9YeuN3wENfzbY3azZiKBObAx9TSOCJW0B96q0KzxQlE
	 Bq7LWkvMyohGDuUT5rfRgFZlPNdQpUseNahFsd7dtJ6t6Q+CATRU95ZRy1Y4y7QIvU
	 jjL8j0IEM7GLbZ/w6O+00jshcpgXvW2npBB1F2nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 5.10 26/96] regulator: core: fix locking in regulator_resolve_supply() error path
Date: Thu,  2 Jul 2026 18:19:18 +0200
Message-ID: <20260702155109.535988384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 497330b203d2c59c5ff3fa4c34d14494d7203bc3 upstream.

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
Signed-off-by: Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2036,8 +2036,16 @@ static int regulator_resolve_supply(stru
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


