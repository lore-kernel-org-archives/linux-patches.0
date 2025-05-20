Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDEA2F37;
	Tue, 20 May 2025 14:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749987; cv=none; b=ogDmvo+n77dbu+yJUElmjKQcOeQmjUm1g1/ZAt4PGUoJgWMMgonbmbtd2Oq9zERfqbsTi9GjHLE1w+rn/JknLUwlLjf6yZjhCeuBuuyWtGw1MPvZ4pkOlmofkJYS2W65vogELQ/srp3CJCO46akQTb1t9S/kNl/V5zS16qLjZhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749987; c=relaxed/simple;
	bh=29KATQd/TCHDHC2K7O61J+F0CeZSbFXuUI4P2OzWFPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jb5gZYcgkq131yhuV/qx0D5NgvHQSoCR8HouM7tuPlUbWCclL3cv1dy2owwdaLR5XS5G8xCqNd3f3P9MGMY7gLdHVfslZw9uGKYA4oS2YXsLGnjwxupzImIZzmy1F4WCl7F/+S5hZBZiRSGpUGOhI/grvDYxPKObYcMwNHF0Kag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDurpC48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDurpC48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE69C4CEEB;
	Tue, 20 May 2025 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749987;
	bh=29KATQd/TCHDHC2K7O61J+F0CeZSbFXuUI4P2OzWFPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDurpC48HPK1lQTartnS7Pcio2gq6ha3P2vjWn6LgbwI6sDmjgSk+6CWvz3HGOPPp
	 sJmaqc6FjCOjvcwCyLfBzsFwEo70Z88l9ouNwDSAB2GWPMP4IVhs3WN51tvDN6lxMp
	 ViF3yrjn9fRL4NNQt52MIrf2486xYOoSP2nT6glo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 116/117] phy: tegra: xusb: remove a stray unlock
Date: Tue, 20 May 2025 15:51:21 +0200
Message-ID: <20250520125808.599291309@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 83c178470e0bf690d34c8c08440f2421b82e881c upstream.

We used to take a lock in tegra186_utmi_bias_pad_power_on() but now we
have moved the lock into the caller.  Unfortunately, when we moved the
lock this unlock was left behind and it results in a double unlock.
Delete it now.

Fixes: b47158fb4295 ("phy: tegra: xusb: Use a bitmask for UTMI pad power state tracking")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/aAjmR6To4EnvRl4G@stanley.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -656,8 +656,6 @@ static void tegra186_utmi_bias_pad_power
 	} else {
 		clk_disable_unprepare(priv->usb2_trk_clk);
 	}
-
-	mutex_unlock(&padctl->lock);
 }
 
 static void tegra186_utmi_bias_pad_power_off(struct tegra_xusb_padctl *padctl)


