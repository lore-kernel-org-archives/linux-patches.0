Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EEA30B51A;
	Mon, 13 Oct 2025 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368709; cv=none; b=uxLxuah/tbbm3nZ+HGvihbbLjWnL7IxSS2vZWcSWKp2fLPyEfEan19G7mg8wUDP9a3pVGL7jVbjEoJxUmzyGvmB6crjciU14DtKiLZDAW0nwpmt7h4upeJoL6P8nvDhpZYzqemgEI69/1YM5gtyOCaBoWeZ0Bv3973Z8PKoCiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368709; c=relaxed/simple;
	bh=JwBaw6JHTUllkPIpDjd8wmRreb0QRhsJZtpDMQ7ssfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdRWmtRK1ZVbekzPZJxc4HkLzGr+Z7ZJNdjPQXtn2Xyv9VoJbAlZDUruCo7FCZi8ngBDUHZjdAcl4eSsPwb7hWMTcZccA/5Iou7JbhQ1C5WcrAcmdFT0AcBgn6PJWZv+0sfUf4eSwZRJT1MbApObStl3EByFD+/+q2ylc2ogYss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncEKfYtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncEKfYtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED07C4CEE7;
	Mon, 13 Oct 2025 15:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368709;
	bh=JwBaw6JHTUllkPIpDjd8wmRreb0QRhsJZtpDMQ7ssfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncEKfYtmZgCNCWfNaEi0a8a6QXdrLrKzj2uJ1LfjlPyJv084goytOOfSj92dJvOD8
	 PUN0Uqy43shBcYRHGVIYsHVyjl2TaZ/JByKA6rqNOBNKp3hZe+PjzxsyJEbnlzqTr8
	 TLDmXrTOfifIEuLgp+vLpKBqRPlkkx7fq3QkqDZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.12 256/262] pinctrl: check the return value of pinmux_ops::get_function_name()
Date: Mon, 13 Oct 2025 16:46:38 +0200
Message-ID: <20251013144335.453565082@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -337,7 +337,7 @@ static int pinmux_func_name_to_selector(
 	while (selector < nfuncs) {
 		const char *fname = ops->get_function_name(pctldev, selector);
 
-		if (!strcmp(function, fname))
+		if (fname && !strcmp(function, fname))
 			return selector;
 
 		selector++;


