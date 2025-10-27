Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA603081AE;
	Mon, 27 Oct 2025 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591172; cv=none; b=WjKvdbPpgBshYv+FNTAUw0q2gFd3OCnwQetfg+FeVbZdU9r1YIQQvHmza+H3VovRFE24JbfqYml8fixwqswYqSBjeYyz2LJh1tLhdeepJ6N2QLg94hCdJGLM5ChyQH+OfjOFj93ar9yg4ejSEp0dlfq6y+c3PEcqep1+nPu+gdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591172; c=relaxed/simple;
	bh=2P3WKDRSDB8MqaLwClCWxTkxq+LzQhSBpHrlCPYFCJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raK7OemuU2YgcbPNhVAjab/QmXnaQ0odpdSyEy446Zz2eilfMhtW14sQiIPf/aBQTs1F9FerwTtphAc5DHgES/VbaTejRIT9aabtBlthpGbrTvM5irE4D4FPgSTGOAHLJsHDh+moEe9Irz4f+5kx9FL9G4YBr06hqWwLFr/Z0qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbIksvTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbIksvTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5D8C4CEF1;
	Mon, 27 Oct 2025 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591171;
	bh=2P3WKDRSDB8MqaLwClCWxTkxq+LzQhSBpHrlCPYFCJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbIksvTTzu/MzVri3BNtKqQKCA1KUiAVf1Rq7rAy7ptm/Cdz1lPvq7PeCrjqNVYdu
	 xUsY5yJyrrnNZkU908vcBfZfXWfQyGPEPy+vavOTQgB7DxndgJZLmVERE7jgXpzzEI
	 tcbnpDW1kOzQpW1HNbHXfsPUeLy+MFXOTrHHiysQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 094/332] pinctrl: check the return value of pinmux_ops::get_function_name()
Date: Mon, 27 Oct 2025 19:32:27 +0100
Message-ID: <20251027183527.104093209@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -327,7 +327,7 @@ static int pinmux_func_name_to_selector(
 	while (selector < nfuncs) {
 		const char *fname = ops->get_function_name(pctldev, selector);
 
-		if (!strcmp(function, fname))
+		if (fname && !strcmp(function, fname))
 			return selector;
 
 		selector++;


