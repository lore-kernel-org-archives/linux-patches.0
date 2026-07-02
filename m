Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6059034252B;
	Thu,  2 Jul 2026 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010767; cv=none; b=duAppY58dbKtngbCNt6Jn4CxAUMTSizCpLlhW0wMHJi+AxLKNXXYJlJY4ETQvg2ncTrepS+fnohIsQAavLbkNfYDOl/YuMspuOWNztXcvok2Pln9q2npZxZ5ug7XVZfJsAgyAQraEKnFcZJifro+mqAKO/8cipaZr6o19cg0cpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010767; c=relaxed/simple;
	bh=/If1l46am0MiWctZ4Hd728ShKg3VAJBtgqbbjiUVKD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKIG7zfA8BzRZNFx8ZfX1lJzOPMKN38mEraWnrbaawasgT02etoO9BPxI/Nmn1tqzYPmifgroKt5PWiFgh6uXv/dcYuYUXznXlKI5N79EDUan5wOWtMgrGPqcVUTChMawfdTLFcCRWa9uMBlc/56Rn6NWq8Iwwd8SISw5rgEHJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUNiaUa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUNiaUa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61DA1F000E9;
	Thu,  2 Jul 2026 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010766;
	bh=JLc29ENr90ShpRYcVYmELzATut6THRyrziSndXc+wZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUNiaUa4ZDSO/hXYEy2yUIaL2xCreSRWW55mxi4YAb9TqaCgg1NxRWL49XEdGXuTM
	 17SyAvwofUtWafohg4T0V1pEfFB8sbH/t1xNkmGxyz/2XEiirkUsPAIMT/lysLbGX8
	 0tPdAdl5gVB54Y452GnlwaC96AeNIP9+xXCEOGhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 6.6 029/175] regulator: core: fix locking in regulator_resolve_supply() error path
Date: Thu,  2 Jul 2026 18:18:50 +0200
Message-ID: <20260702155116.412956664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2176,8 +2176,16 @@ static int regulator_resolve_supply(stru
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


