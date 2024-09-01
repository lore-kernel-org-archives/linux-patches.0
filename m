Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95965183CAB;
	Sun,  1 Sep 2024 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208211; cv=none; b=ZaKTUu6WB32NBkQPNLsTP58EjEZiUWyVI6fCx5eoorpWqAP7CCjQ866x1gKFboanKJotNSfsaHCioj2tmDtj/t0reQUCXt6HwUlcsOTsdlYXLaea5VI3ogj2hegLS0lmWHGXM6MnVtj2EJxQjSXBA5AscdGCtelQVzjDAZS3wTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208211; c=relaxed/simple;
	bh=0QcsczcFN4FH4YFeGY9Wit01VddJCzv7a5M42ZW0VZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Icg43za6Vd6Upr6RhdZYyX4otUstIf4jOEEJhv/VQBq+5SsAuiaIMXQDLkezN2nGhX44QhpZk0NrnGHpehe8gk+qR4HQ5VdQvQynZcdDWf/0Kc5WRWji3Zi+d22FJ0b6s3cCqO8cKF+VoVyuVdVLsuAe/Ker0AaRqazzXbKbsVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q279tNfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q279tNfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CCDC4CEC3;
	Sun,  1 Sep 2024 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208211;
	bh=0QcsczcFN4FH4YFeGY9Wit01VddJCzv7a5M42ZW0VZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q279tNfa5ZV3SSxjAgG08F7XjZZKnG4WNHm4RVm8OWaZAqRMDOcPpnFGvRUXfPhtQ
	 ziufq1M6BonTMud+PecJng97yRKoW3Z1yFxrKSlZQ0RiRXxqbhovhhfwXlCktYzlrk
	 FqD1KHefXDPmRNJ4qPXI4NJXlyz0ceUYuxEcIfYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.10 013/149] pinctrl: single: fix potential NULL dereference in pcs_get_function()
Date: Sun,  1 Sep 2024 18:15:24 +0200
Message-ID: <20240901160817.966680664@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -345,6 +345,8 @@ static int pcs_get_function(struct pinct
 		return -ENOTSUPP;
 	fselector = setting->func;
 	function = pinmux_generic_get_function(pctldev, fselector);
+	if (!function)
+		return -EINVAL;
 	*func = function->data;
 	if (!(*func)) {
 		dev_err(pcs->dev, "%s could not find function%i\n",


