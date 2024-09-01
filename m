Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEDB1DFD1;
	Sun,  1 Sep 2024 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209725; cv=none; b=ViFbMsJGL0/MA3LWim0bUdjdm8GfZiOnOambkjQVbHtCEMWMlbd+jF75IpvnQuLSjfOeaDHHqnOQt0hwkrR2ELRiDpUyBFXpN24LqQq1i6c80H0bGilsD6YZNPimauDC5CivmOISFbSTwdXrVFUqBnrQzM4wyrG/bsZkNVogrWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209725; c=relaxed/simple;
	bh=ZuOJPpyoBe7jGu4f06y45A8eiHoqgR5Lb10P0tR5cSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPAuY6kVzwOn85ULVtkvagdEBGVpzaTaRPpRdERyDr/VD8Bxp1pnt1Y9x7qrBDzNeq7f6cVz1+yDwWHdboGlOlGhsNBA2uio+yprRZkD8ZpNbukSDgs48d7Py5oF/vHZF8uzFhMlj648RmIo2bytkOQ0q+g6+oCA/Uc+150cdzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOZraQim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOZraQim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060E0C4CEC3;
	Sun,  1 Sep 2024 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209725;
	bh=ZuOJPpyoBe7jGu4f06y45A8eiHoqgR5Lb10P0tR5cSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOZraQimoDh7DwWut/uYftzrqLP71ur+CKLmnfyvqRejWl786nKv9dOaAALSdhn0q
	 PtuBqf5dqmwpX0EZOqKpcwO2JqkY4aRoiAgauih9/xZVN/FlGFs1Q2merhIc2Aa7xR
	 dfzahg3uyhhldJ7V0Mf4PxbnF2KRufZcnA9E0GrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 124/151] pinctrl: single: fix potential NULL dereference in pcs_get_function()
Date: Sun,  1 Sep 2024 18:18:04 +0200
Message-ID: <20240901160818.773333592@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 1c38a62f15e595346a1106025722869e87ffe044 upstream.

pinmux_generic_get_function() can return NULL and the pointer 'function'
was dereferenced without checking against NULL. Add checking of pointer
'function' in pcs_get_function().

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 571aec4df5b7 ("pinctrl: single: Use generic pinmux helpers for managing functions")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://lore.kernel.org/20240808041355.2766009-1-make24@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-single.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -350,6 +350,8 @@ static int pcs_get_function(struct pinct
 		return -ENOTSUPP;
 	fselector = setting->func;
 	function = pinmux_generic_get_function(pctldev, fselector);
+	if (!function)
+		return -EINVAL;
 	*func = function->data;
 	if (!(*func)) {
 		dev_err(pcs->dev, "%s could not find function%i\n",


