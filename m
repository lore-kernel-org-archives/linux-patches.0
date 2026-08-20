Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BAC352019;
	Thu, 20 Aug 2026 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238202; cv=none; b=nUQcP5z6PA3oZhcY1JoGcMLRy6pQ2zkc0IRuGBuVxm9AVaF7NRaN1EzPUxDVOdZt72nzt6lOI0qyzDOh/qgO5Gy+dUQawK94Xy/UFiIrkfUgmSC3a5MR84u5NlBI3mkFMFjxy+F0Z47oAeSvcRdNy9uC8V8+vL/YiyZooxruV8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238202; c=relaxed/simple;
	bh=oDRK/BQ/9Bhl/kgZaDrel53e8hmlyAT/ydGKPUIMHjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfXyU1NkuEt2++qKdNt5jdh3G6bfBNTdye7rwviDAu4nYwgjYHTHiU/exSxAMQIwbzKpnrm+qayK7B0ZbqccX8sxLFODUl8BItV6uKPHrWFfWAz7mYGnf7Hj9oLv92si32lI4pUgx5lZlNUVINhNAzOm/97FGK6pxvc0SVzOXbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3st7g9d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3st7g9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB781F000E9;
	Thu, 20 Aug 2026 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238201;
	bh=OZyhcll6N2+bTH0m5LylGQFOOeCBPMaeQpOJ1nKUzFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3st7g9dJxMqsUjhBCogEw+UqJ6qmKlRzR5ikdG5vALD+nXkAw3tJC1kIAFPD3yCb
	 jh2IkBTDvJAnFgHtz/TTez4U13woOmI+W2o96x3C84pTObYD2dc3Sxan13iDm8D63J
	 Oe2HtkFdkD0K6aYiuIhsEcNUKpg1Is5KRU+HI7nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 067/228] pmdomain: mediatek: mfg: initialize prev_o in mtk_mfg_attach_dev()
Date: Thu, 20 Aug 2026 16:53:29 +0200
Message-ID: <20260820145246.498092235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 090a95dbe13df9965279b588d97eda134831769c upstream.

mtk_mfg_attach_dev() reads prev_o on the first iteration of its loop,
in "if (prev_o && prev_o->freq == o->freq)", before prev_o is assigned
at the end of the loop body. On that first iteration, evaluating prev_o
reads an indeterminate value. If it is non-NULL, the condition
dereferences a stale or invalid pointer, potentially faulting or
incorrectly skipping the first OPP.

Initialize prev_o to NULL. This matches the intent as well: there is no
previous OPP to compare against on the first iteration.

Found with Clang's -Wconditional-uninitialized.

Fixes: f08e7a4e8d6ac ("pmdomain: mediatek: Add support for MFlexGraphics")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-mfg-pmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/mediatek/mtk-mfg-pmdomain.c
+++ b/drivers/pmdomain/mediatek/mtk-mfg-pmdomain.c
@@ -657,7 +657,7 @@ static int mtk_mfg_attach_dev(struct gen
 	struct mtk_mfg *mfg = mtk_mfg_from_genpd(pd);
 	struct dev_pm_opp_data *so = mfg->stack_opps;
 	struct dev_pm_opp_data *go = mfg->gpu_opps;
-	struct dev_pm_opp_data *prev_o;
+	struct dev_pm_opp_data *prev_o = NULL;
 	struct dev_pm_opp_data *o;
 	int i, ret;
 


