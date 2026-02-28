Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D74B33FE27
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301210; cv=none; b=gBVQyMEuXuYY4LozU/esc2KLj9G50cUgaC2YHh/mU5IhzNQik5Va7MfmuSnKCWUxAwDZpePhV5wePC3raiaYzEaMwVLOSMufimW7TzJlcy0BEh2mYXL39NoXw+lPSGxJn4ti3Q+8++uG3cDGz/za1YJwf1Ts+DD7yI+Y8QbNn5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301210; c=relaxed/simple;
	bh=10LD9H4CBUJb42a3buQSMpkNQAa4if+Msqqc8c9f7nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvpAL9P/5/xdNa503M4sNzDYViEsCMstRsHA4T4JHPwEkzAQZUjBEYUquZLxCl7+T4MVwWCc7Rq3e2aomV2sM9A/1M23DDiHcY9J3aPWEtGfhH2Wv9CFKlG6s9IU6ISHRfUhkoIfBq0tl9L9t7b/GVI7ivH1diWOK+s7zO6R9pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnVgsH7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnVgsH7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF80C116D0;
	Sat, 28 Feb 2026 17:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301210;
	bh=10LD9H4CBUJb42a3buQSMpkNQAa4if+Msqqc8c9f7nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnVgsH7zo3bjDAz00bvPnJVMvuKxSQNigvTy22dtO/oYrr2ArKaLnwoS+J+59Av0L
	 CYKgPFLE0UnxaGKs9d+7TQsnMzmq1cnRjZA3Uf5qySf+hWLM95MSOzpCEr+lZNQESv
	 /M8E2BesWoban5mIUb2uZ2VFVPPPFojfWwkD5YkJySyJbip9+SNGaTMQrw/L90RC+7
	 Xhhkhsz+dXmeqd4faIrs8Rb6uGNbTFOGKADSqRtf6FRZqVdTAjQg+ne6vFidiw8vNR
	 sM3ze2pTMvUY5NFPY7LFcYxnkc12mHePC/reDNqgk3iSTVxc3Xey3kedGnc4pc4PwD
	 MRJAzmBaTcmJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: decce6 <decce6@proton.me>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/752] drm/radeon: Add HAINAN clock adjustment
Date: Sat, 28 Feb 2026 12:41:36 -0500
Message-ID: <20260228174750.1542406-385-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: decce6 <decce6@proton.me>

[ Upstream commit 908d318f23d6b5d625bea093c5fc056238cdb7ff ]

This patch limits the clock speeds of the AMD Radeon R5 M420 GPU from
850/1000MHz (core/memory) to 800/950 MHz, making it work stably. This
patch is for radeon.

Signed-off-by: decce6 <decce6@proton.me>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/si_dpm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 9deb91970d4df..f12227145ef08 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2925,6 +2925,11 @@ static void si_apply_state_adjust_rules(struct radeon_device *rdev,
 			max_sclk = 60000;
 			max_mclk = 80000;
 		}
+		if ((rdev->pdev->device == 0x666f) &&
+		    (rdev->pdev->revision == 0x00)) {
+			max_sclk = 80000;
+			max_mclk = 95000;
+		}
 	} else if (rdev->family == CHIP_OLAND) {
 		if ((rdev->pdev->revision == 0xC7) ||
 		    (rdev->pdev->revision == 0x80) ||
-- 
2.51.0

