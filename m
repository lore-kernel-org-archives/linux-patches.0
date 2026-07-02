Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2373397E81;
	Thu,  2 Jul 2026 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009613; cv=none; b=QGxABEA/TEgslatSwsd8AyuIi2hvmN/hH+nXzo1vnn837iBI9rWPhel846JGzdkaFoycv5l3e0e7+vs/Eu3QyVfx7ptku/YxI0XXQoSYm5BwDK/N7URTlyz/GAROu3raZB6fBOkv0inUV+USgBMv+ht0sC1t6WOVi4dwUJyGYKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009613; c=relaxed/simple;
	bh=31EB43Mg4AtjJ18yoLH7DtmEFfeBkSR9dky8+3Mqhlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pE2T24cG6oG8R42thUBNusDgygjWLprxpXb7L4ju2993nc0SQu4u9SqPtATe/vhW7O7qALehERVzLRcuTAwYgJMw6g3ba5sKhL/yEYO9kTFhcQbyN+rYDcOLh8g4xI7X2kqtd0AYlCFr8RjlsH+T8/rSFC128yiCRwL+P3huvjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2zXtU/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2zXtU/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB5B1F000E9;
	Thu,  2 Jul 2026 16:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009610;
	bh=FXzsC7BnuulAQ6IwMNMXHL/MGocZE+pTTy1TenlFmsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2zXtU/479RxqNGRw7naQfmOec6QEAj440uO7weMpVdjJEn7CNGT04B66ZRMhyr9b
	 eOX3xE1ftxa25z3/z8jwQut96wITackFg4aPnWl+RcIIF/fYItG++UjfijiS56etFH
	 Ym/VjqFgo4N2HRBDLJAMtr5WFu5SWKji3+uJeaTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 5.15 20/95] regulator: core: fix locking in regulator_resolve_supply() error path
Date: Thu,  2 Jul 2026 18:19:23 +0200
Message-ID: <20260702155109.633765944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2139,8 +2139,16 @@ static int regulator_resolve_supply(stru
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


