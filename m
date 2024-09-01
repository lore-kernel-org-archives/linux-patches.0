Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2406364AB;
	Sun,  1 Sep 2024 16:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207771; cv=none; b=byFvPRjkEa2jn1qkpzq1yPXmXkCp2LFSx2Mpsq6k2NYuhofenZUE3OIPuziENkmvoLCpvktIsXePFrwUHHXzdtbvFxepvd7NIRJGgjSM1TWbgFRa5OiB0MjMoJSpEHiAbjXOzGFcYgO+ZJkgnyt8N7jA5VhmEI9UQ/8tWX1sOI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207771; c=relaxed/simple;
	bh=t1vpZvw/lSCFt32Sggd1qo+bnu//0Gywi21/zdvlv8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9fGurAt/gNOnKTnSTQqj7jqWAl2Q0OGa0PjL96nlsR86jeWiHtgFnLpSjmBGaVrcrilpJ2E5xsRrpLNr8aSjuxXzq9PIQ0zjy+oG5MHZNSKJRixHpaDXYdMZfVJqddkByP+N+2gW6omTQirc/oFqzRD4hcqmSCjDNTnpq2bvow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sI6wFfu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sI6wFfu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19968C4CEC3;
	Sun,  1 Sep 2024 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207771;
	bh=t1vpZvw/lSCFt32Sggd1qo+bnu//0Gywi21/zdvlv8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sI6wFfu9AWPqXNS2RlwFSLnjTeu+IX4Sn916+gb5sRifRCLAj189GWFrui7ZtPCSK
	 CeeCF1DjILRm9gKoRQr5QcXdmCZUy7CV1CabEeijCiLF8h5QhOmMFVeicBT03s9xdf
	 9iSzttlS0+pKJsCCKGjtWh1Wcy/4JSHPVZPlBF7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 73/98] pinctrl: single: fix potential NULL dereference in pcs_get_function()
Date: Sun,  1 Sep 2024 18:16:43 +0200
Message-ID: <20240901160806.449643224@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


