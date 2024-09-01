Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7B81E498;
	Sun,  1 Sep 2024 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209016; cv=none; b=bBtJ6/FPnCUOyNt3NwwqMcMOzpXLxtmbDdm8LxfU58Q1suERpKUYCTvYpyR4t/SnSe66AHFnQLIDE22qHY0c+ZNTC3pWlzTmEprLcv3Bsfhx3ZTi9TDw33/naKHgppzkU+M1cK5drfXDFRLfgBRMeYLKAtWJQz4rH/AkRkWYlwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209016; c=relaxed/simple;
	bh=Wmttm6vTSoD815Vuff92eDZyy+LlnFWBT9yHoOxXsuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDX3QGerW2vgoV4kTVIE5kvzDIpqxqxPhomNxiTJlCF7jC1reCHoY9EtGTMTq1r9ylYgoFCA9S3klFP1ME07iXtNCfwwtVYOfZqlEmmwqhYimOyi47VkUqQRCfviKIb/zcp0s9PQEz0WkJtoxPMh9+QXIdvDmaTIvvtjiusGpXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAH0vUHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAH0vUHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1A5C4CEC3;
	Sun,  1 Sep 2024 16:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209016;
	bh=Wmttm6vTSoD815Vuff92eDZyy+LlnFWBT9yHoOxXsuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAH0vUHEousjhm6yhz6N62GrV1f7oUmQ3vMlyf+kUSRriF33G1f/T9DdWfhMilpCY
	 PUnhHDWRZ9OaPFvCCkbU/uNMQnSnSM3bBvAdtSIFQ/9YwjxSiNvze+3lF2wqYeOdus
	 lweliW2BKASJwo9yA4cCUHeYWq6CwM9irhA2s1bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 108/134] pinctrl: single: fix potential NULL dereference in pcs_get_function()
Date: Sun,  1 Sep 2024 18:17:34 +0200
Message-ID: <20240901160814.152029218@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -323,6 +323,8 @@ static int pcs_get_function(struct pinct
 		return -ENOTSUPP;
 	fselector = setting->func;
 	function = pinmux_generic_get_function(pctldev, fselector);
+	if (!function)
+		return -EINVAL;
 	*func = function->data;
 	if (!(*func)) {
 		dev_err(pcs->dev, "%s could not find function%i\n",


