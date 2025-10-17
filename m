Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC06F2F12A7;
	Fri, 17 Oct 2025 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716225; cv=none; b=Ocy4PnQoF9Y9IXZVttgP4igguRhC8Oe29O8dP5tDe/FVAlQDiI2i7mMZjYqlGKtQJpSE7jCq0Yog66EKs0HOacEpV5CHX180nj5HuXp+f6YP0DrAf0sT/ATqyuhAatQgFCD4572jfdwcTw2vTSiUhJHKB14G3H6yWSFRGdQVptU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716225; c=relaxed/simple;
	bh=xw/AAb0DOkt14d+/tDZ39rJimsOWXaq184yIIzFC14g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIaIubh5XEO36aVqeDVv9YwGSy9tO8/6t9MMAKF2nzLBN5H6qvbx3XyjC2bDPyh+6TyTGWrtoL7f+dPcpH/9TIYbxYstbRwEG1HZerwe6KRb6iG11oZA1qbFVqKDsW+md5gSUa+QKdieqnq+DbvOHLcM98QDo/8BVkK93JvLkXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gi4qo1Gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gi4qo1Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D47EC4CEE7;
	Fri, 17 Oct 2025 15:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716224;
	bh=xw/AAb0DOkt14d+/tDZ39rJimsOWXaq184yIIzFC14g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gi4qo1GgjOhSUCiCwIxRNNLDsNFZ/VODHmLt2lnclZVcHHVdjt2lMDa5VAkw3R2oz
	 lZY/HURghUxDav3eo5g4Co+AHThid3lNdtHYOMVjNt8dL9h/3h3OUapgrJVwX3psid
	 hW179ngTJfu0GEwCsxT7lJ+7K0jpM+6NiRHeVRbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 117/276] pinctrl: check the return value of pinmux_ops::get_function_name()
Date: Fri, 17 Oct 2025 16:53:30 +0200
Message-ID: <20251017145146.748713293@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 4002ee98c022d671ecc1e4a84029e9ae7d8a5603 upstream.

While the API contract in docs doesn't specify it explicitly, the
generic implementation of the get_function_name() callback from struct
pinmux_ops - pinmux_generic_get_function_name() - can fail and return
NULL. This is already checked in pinmux_check_ops() so add a similar
check in pinmux_func_name_to_selector() instead of passing the returned
pointer right down to strcmp() where the NULL can get dereferenced. This
is normal operation when adding new pinfunctions.

Cc: stable@vger.kernel.org
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinmux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -328,7 +328,7 @@ static int pinmux_func_name_to_selector(
 	while (selector < nfuncs) {
 		const char *fname = ops->get_function_name(pctldev, selector);
 
-		if (!strcmp(function, fname))
+		if (fname && !strcmp(function, fname))
 			return selector;
 
 		selector++;


