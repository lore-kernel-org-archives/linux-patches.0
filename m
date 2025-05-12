Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3F3296FAF;
	Mon, 12 May 2025 17:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072405; cv=none; b=dQjq/MZAk+1cnqYTHxtWy3XoBQDb5kDnDtyEk7zCUYUDXtMAygexTTIV1Qo9Y/8QV7AM+mlSbxJhy8mrJisrPnNZK93eqXtW1k6lU8BqVg4xlrke0YSsfy0zxJkU4cm0zEynp2hyVxGDCplwu0D8Ph78nMIqLejX9BbgTDKQifw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072405; c=relaxed/simple;
	bh=VRdWmtoEnHRQGJNaBdDXXPiTRHFnueHZGBzFyAbCVFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YL/hmEluicL6Qgv6Cj0egEAP4MNzmt33nRpMf9Oh7IDDUpsBMvJ4g4OX7LvobbHq7pKA281rCR0j9rLsKRS/EVbvOJ9iwiueqlbTUcIKz0Vd1FM4xIkWHa/YZLnYWK9RY//I3OINxpADRPHDCoT0IQImFCqGOnX//spUkEvnuMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4hwuT8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4hwuT8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF04C4CEE7;
	Mon, 12 May 2025 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072405;
	bh=VRdWmtoEnHRQGJNaBdDXXPiTRHFnueHZGBzFyAbCVFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4hwuT8MFkj5yq20J6FG0a6txrnVndZSflAorJHqoL7fRo4H+6i7cdQhD9PYqOrTd
	 wLRDJt6FOnQVXSnWF/G3pK9Vjg9GwqGFMAdVkogNuFSuppsxxgA4xCGyhpnLPmHicZ
	 L1hKpK2xAPKjL+SNgDCLME/Uu1KXGVUHEW9daWDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Bisson <bisson.gary@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 23/92] Input: mtk-pmic-keys - fix possible null pointer dereference
Date: Mon, 12 May 2025 19:44:58 +0200
Message-ID: <20250512172024.066482305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

From: Gary Bisson <bisson.gary@gmail.com>

commit 11cdb506d0fbf5ac05bf55f5afcb3a215c316490 upstream.

In mtk_pmic_keys_probe, the regs parameter is only set if the button is
parsed in the device tree. However, on hardware where the button is left
floating, that node will most likely be removed not to enable that
input. In that case the code will try to dereference a null pointer.

Let's use the regs struct instead as it is defined for all supported
platforms. Note that it is ok setting the key reg even if that latter is
disabled as the interrupt won't be enabled anyway.

Fixes: b581acb49aec ("Input: mtk-pmic-keys - transfer per-key bit in mtk_pmic_keys_regs")
Signed-off-by: Gary Bisson <bisson.gary@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/mtk-pmic-keys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/keyboard/mtk-pmic-keys.c
+++ b/drivers/input/keyboard/mtk-pmic-keys.c
@@ -133,8 +133,8 @@ static void mtk_pmic_keys_lp_reset_setup
 	u32 value, mask;
 	int error;
 
-	kregs_home = keys->keys[MTK_PMIC_HOMEKEY_INDEX].regs;
-	kregs_pwr = keys->keys[MTK_PMIC_PWRKEY_INDEX].regs;
+	kregs_home = &regs->keys_regs[MTK_PMIC_HOMEKEY_INDEX];
+	kregs_pwr = &regs->keys_regs[MTK_PMIC_PWRKEY_INDEX];
 
 	error = of_property_read_u32(keys->dev->of_node, "power-off-time-sec",
 				     &long_press_debounce);


