Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DA2253946;
	Tue, 20 May 2025 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750430; cv=none; b=X1955L1FOffxVTGEqeE1Bd476eGLOxBlqt+saxI8+YDE09BFDcKmlkcv/aQbcevg4iQjuz9EwZLsjZG97txJYycz57ivND9BQNISvpiYTChlPOoCGT39mgc6sksjkXqRlp9+1vD3w41g1xlPEpOTEmAUIIUxIJKW5ejHRStWPrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750430; c=relaxed/simple;
	bh=9Sf9FbdS++8dKqXywbGp/6HTeuXTHKCZAVO/wJage8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0XtCklqydgHJn5/VgeS4SeSt1mCS5pQ12P42/wJ3qU+z0hG62rtrLbKA+fPdvrP4tDlqQ42cbv5V3E+do+X89p/6QjPmB3RB6UJ+/oU/JwCFSOakMOP6dthAlzFsB0ICiiQthQF3d7Pn/cpcsYQmxNIB5T5QYVd6wR25AygNBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUchNH+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUchNH+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DADC4CEE9;
	Tue, 20 May 2025 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750430;
	bh=9Sf9FbdS++8dKqXywbGp/6HTeuXTHKCZAVO/wJage8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUchNH+bQQVZif8xXMkeORoE89aR4WTON2rsCPiAP3F8L0hwe/oYNj7nbS1Qljvnp
	 e56s24gsdV/h9Zgveu69Vyu8cd0HC3OiP67lxUmwOumDgg7d3b2g7Yd3tjnLsdTEG5
	 2xKA5IR391U1r3WOzEQa218MRc74MIY+L8TzUYJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 142/143] phy: tegra: xusb: remove a stray unlock
Date: Tue, 20 May 2025 15:51:37 +0200
Message-ID: <20250520125815.594942441@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


