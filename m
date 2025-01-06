Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529601DE88E;
	Mon,  6 Jan 2025 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178323; cv=none; b=FdrL41guiYM7gGQR6Ctn3S9uMrlFtOP+bNb0l+BDm5HGd58uouQsUvnumGxT5icDkPAMNJMPnCY9DbasP3D6Ol5ztZmJEc+8lA3omsy7LwtcY79Vyf/MTR18gAwtp+HR+E+zYr0qccfIL8ARWvyxnfPqoz2hX7cCgHBeKCvxI7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178323; c=relaxed/simple;
	bh=R723dTy1PDk1/IDXgdIzIlxpzS8RjLsxI7H1/5KNiP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Snv42lPFwJqlIvugHISf9o45cqvj2WlKLDDCuEvCDUtF5efa/YrZP1TZuzU7Q4TcA0FW1DmD0fRYnu0Pj7ZEEpgT+jq/UorN8linnVAaMqNwDIcMDGJhXoJrAu81EYutcbyFThut7tKSrB8ZKO/D9tx822VUPzrPp/629U3JuD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCTLrAl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCTLrAl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A81C4CED2;
	Mon,  6 Jan 2025 15:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178323;
	bh=R723dTy1PDk1/IDXgdIzIlxpzS8RjLsxI7H1/5KNiP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCTLrAl5c+Obz9EaIJU7Ofs2MK6c5MoM7XWhHOLL+QUsVFw/emoFgKJRFZPqcA6Ot
	 CRZWrhkjCTLjAy/yCkZ+wH+HxIsotZMfTaVhu28W5XiRgwuA16tZye/Gbh55x/k2/2
	 zmCL3CAMKL1fi/pzU+Zpw1/GNKVeB8QcFi06mzFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 079/138] power: supply: gpio-charger: Fix set charge current limits
Date: Mon,  6 Jan 2025 16:16:43 +0100
Message-ID: <20250106151136.222283160@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Fedrau <dimitri.fedrau@liebherr.com>

commit afc6e39e824ad0e44b2af50a97885caec8d213d1 upstream.

Fix set charge current limits for devices which allow to set the lowest
charge current limit to be greater zero. If requested charge current limit
is below lowest limit, the index equals current_limit_map_size which leads
to accessing memory beyond allocated memory.

Fixes: be2919d8355e ("power: supply: gpio-charger: add charge-current-limit feature")
Cc: stable@vger.kernel.org
Signed-off-by: Dimitri Fedrau <dimitri.fedrau@liebherr.com>
Link: https://lore.kernel.org/r/20241209-fix-charge-current-limit-v1-1-760d9b8f2af3@liebherr.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/gpio-charger.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/power/supply/gpio-charger.c
+++ b/drivers/power/supply/gpio-charger.c
@@ -67,6 +67,14 @@ static int set_charge_current_limit(stru
 		if (gpio_charger->current_limit_map[i].limit_ua <= val)
 			break;
 	}
+
+	/*
+	 * If a valid charge current limit isn't found, default to smallest
+	 * current limitation for safety reasons.
+	 */
+	if (i >= gpio_charger->current_limit_map_size)
+		i = gpio_charger->current_limit_map_size - 1;
+
 	mapping = gpio_charger->current_limit_map[i];
 
 	for (i = 0; i < ndescs; i++) {


