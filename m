Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA661B4F0C;
	Wed, 19 Feb 2025 09:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956700; cv=none; b=Uyct17LaVYxN9Z/xZjB13/RTuAqE2gZoT/Yriqxz4TMhkJaCBOY+MCiWuTEmXrAFHDEU1nOJSyhWW/ljABwLtTnMXl+0rKVr+Zj626bVjvoB/BbULqTXusPnO54BcNZE3CPI/tAg+bMteS6OQTN6ZDXaBrsay+MBjGexVL4E1QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956700; c=relaxed/simple;
	bh=T00kE0NeTefrmy0+4+U6fPdckfezNhLw+TDdRw5hSU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUI6/6XqFfIX2eCRb6pFME0PhzNojQTV+rvgPWy3bkOFo6Dgw+6eFWt+gWqtU0Fj6tij2vp4lV/p2Uo6jsIkGqEAZlZGCGXEoWYyXObtmi10DSmNVvcr9jF2gE2JlstDIXEVVug/tfAVIXLgN872E+71ryfbNNeX0eEAKzRLUcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ddjyZtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ddjyZtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD23C4CED1;
	Wed, 19 Feb 2025 09:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956700;
	bh=T00kE0NeTefrmy0+4+U6fPdckfezNhLw+TDdRw5hSU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ddjyZtYjljLcLjbfAn5Jpv5kaFvUbippy7lnL6ggS5YHj7wgToOLtefzYRrZdxRX
	 RWHclpDKQDajXLLvkW7yuoGeYpk9XrEgjYPDQsvf5EZl+4MgqqJazcE6Kgqc6dwQz/
	 1+yEudrG99lFadpAqhXIDSkWb83lOPscnKT5nGSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 269/578] pinctrl: stm32: fix array read out of bound
Date: Wed, 19 Feb 2025 09:24:33 +0100
Message-ID: <20250219082703.604789424@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Borneo <antonio.borneo@foss.st.com>

commit edd48fd9d45370d6c8ba0dd834fcc51ff688cc87 upstream.

The existing code does not verify if the "tentative" index exceeds
the size of the array, causing out of bound read.
Issue identified with kasan.

Check the index before using it.

Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Fixes: 32c170ff15b0 ("pinctrl: stm32: set default gpio line names using pin names")
Link: https://lore.kernel.org/r/20231107110520.4449-1-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1282,9 +1282,11 @@ static struct stm32_desc_pin *stm32_pctr
 	int i;
 
 	/* With few exceptions (e.g. bank 'Z'), pin number matches with pin index in array */
-	pin_desc = pctl->pins + stm32_pin_nb;
-	if (pin_desc->pin.number == stm32_pin_nb)
-		return pin_desc;
+	if (stm32_pin_nb < pctl->npins) {
+		pin_desc = pctl->pins + stm32_pin_nb;
+		if (pin_desc->pin.number == stm32_pin_nb)
+			return pin_desc;
+	}
 
 	/* Otherwise, loop all array to find the pin with the right number */
 	for (i = 0; i < pctl->npins; i++) {


