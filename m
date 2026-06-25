Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4312D060D;
	Thu, 25 Jun 2026 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392854; cv=none; b=J/tWQP5rkImVK0SfsouSVTwzMf5uG+JjAQEAZzocoqTrKAI8UgTLcLGE+LCoVuuoyBiMRdXztnAwgjfAK0zaa2wwEQBvWKKQ8jzKdALyFwAN0zwFruSzTMYTQ3Sz5Zqq2Wh0GyVBIdDN6C+IDp1xSzhPWJcZUKuumTy/lP+6bMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392854; c=relaxed/simple;
	bh=tQfIuoaFutr5P10ryHeMQmWMYDk9Bcbkm0PrDKUCyRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qB5QN7dYGjrlCY80i/+uT/U1VqHpJvB8975OC4MguHjbJrTd7H9V1VgPolOcL0MYfSVXsEq1ed/4lM7RPfcxWv9zcDOKd0tI53yd+VIyV7AbAUvKK6z3xG+cZDMcm42HELq3Jeorz/dMirwDMlCaBO0pgW6BMHOESAVF2DzJ9YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcRZKDuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcRZKDuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18FE1F000E9;
	Thu, 25 Jun 2026 13:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392853;
	bh=pGDwJPxSwroDM7bDi0TpYbE8aBILru/pAFnDNL+5ImE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qcRZKDuGzm49SqKqBEgfWXkIhdPf2UgQqz4ehQY1c1PPpwpCmsCZ1ugBEIKQWD33e
	 aS8KGUhI8+kpN59BcE6KvRJ1BwxR/C1zkyMgSx0kN2wGXcAGYGLNiTU26NoiLrnQD/
	 tPZNETAtQfWx/O/RIjMIBgraUJUMQoQ/umMfqSFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 6.18 29/60] regulator: core: fix locking in regulator_resolve_supply() error path
Date: Thu, 25 Jun 2026 14:03:14 +0100
Message-ID: <20260625125649.813544483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2159,8 +2159,16 @@ static int regulator_resolve_supply(stru
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


