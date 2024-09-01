Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC002C6AF;
	Sun,  1 Sep 2024 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207966; cv=none; b=LRmUzbwB2vBKUDjrLF1vy4knMT8eCBs7SK3j7u5/jjyYk4hmISmL8ot+BxWzo6ZB7QCkgNj8Ug2YpcWxIBQTOkAzd8jAonqyRO53rpxrSCNJ2VyWwvGVqH3NKR/HPSZ/6nRvxo/CBqQfm6Mg+26yuT/94XPYilI5lrwnaKJJUKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207966; c=relaxed/simple;
	bh=Xylso641AHwINPMIf7BpCXmiiRKmrvxsRl7srDoYMcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5G4Sb7MDToUozBW/NDS6Pwu5rX3VQH9xA3dagn7aK37WYWQ0oPADd5jlM0k/oqZCNycT1ACbwzuiLSs5KQJTeWoeYaxtMk2oxR7xLjy7MgGvVuB+uwHmPQVBa55FjfYrssjITULP+MZc/rkZOokoJkdfiv/N8Cn878RAoH7XEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWYrQCD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWYrQCD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D73FC4CEC3;
	Sun,  1 Sep 2024 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207966;
	bh=Xylso641AHwINPMIf7BpCXmiiRKmrvxsRl7srDoYMcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWYrQCD5R0JJoV0Ols+zb/BcKnHFEpetJRQrfo3rGIpM0l0gr05PhxaygG3m0aFFs
	 WIOLFMIQjDoS2aYcVU9ccV6roAMDhF3bPgjwDI0ZJpZOXNuye1AaKpSxzs2TgryNna
	 j1EvpyLMZaSQlzWWLpweRt/fZ63fdpDRMZQEXQtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 07/93] pinctrl: single: fix potential NULL dereference in pcs_get_function()
Date: Sun,  1 Sep 2024 18:15:54 +0200
Message-ID: <20240901160807.632891607@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -349,6 +349,8 @@ static int pcs_get_function(struct pinct
 		return -ENOTSUPP;
 	fselector = setting->func;
 	function = pinmux_generic_get_function(pctldev, fselector);
+	if (!function)
+		return -EINVAL;
 	*func = function->data;
 	if (!(*func)) {
 		dev_err(pcs->dev, "%s could not find function%i\n",


