Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE467372223;
	Sat, 28 Feb 2026 17:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301479; cv=none; b=YoW4SiTpeMQHMdfEZcnCMGcA9uPCpkzuGICYYtq44QOZCh2PfApZDdZJ1R/Yici+heC2FraoLHyqIihkeC2YnDXx1OiG+mWvbEj9ntQ++3KOqmInYejGssmo55bQtArmbfdoZEw/Vu2JpjecLkVP+tNqp37pHXjOj6eHiPED9rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301479; c=relaxed/simple;
	bh=Wed49aVcA4uIWLfGN4AjrfVz5Y9GyauHPSu1ORChr7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccbo9AHZQ3rqM+c+NVk7kKcf0x1CGKQQCNvQncDqoYfFKdKIXnmlkr7Dad4WJR3mxRAvdKT3tHer1fASzlSFArnATdm0m7CZGItLvI0SzLJZxwRi6/TW6R5qSm8LpZhdoUHYT2xO2vN0b/Fkp6mWT61/dg0SWBkmWyYmfF++RCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QnG3I62i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnG3I62i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF6FC116D0;
	Sat, 28 Feb 2026 17:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301479;
	bh=Wed49aVcA4uIWLfGN4AjrfVz5Y9GyauHPSu1ORChr7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnG3I62iOmEsmcJTnpgEObRrjc7QCG3n4UHIy17qEQsIu7KTGpTzrLnm/IEmBgz9r
	 cIUmKSKBX5CZeeKh+oD623nGCPjOGaydchVZRN0uSCjzSzjoBAsUGTYE7U5ioUownq
	 L25YOPOGvTVFVjJ5MTnFyHfvQCZXGvoKdP76VKT5SQFncYA0T08i6zSnqeRqfyx3Pv
	 y4vYZxUEW+6Y5Lck5sZFuvi4kFsWTpLx613vraDEy4B96ZqD9I1QLysDxk7wQBz4Ap
	 L7GzB8GbbdsfqN69GxN9rL0Qqi/aNZg4WgnnJmTRDuxqQfwpj2+thBNmUt/ap9HCYw
	 pFSqMduY4EaKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Johan Hovold <johan@kernel.org>,
	stable@vger.kernel.org,
	Andrew Davis <afd@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 664/752] mux: mmio: fix regmap leak on probe failure
Date: Sat, 28 Feb 2026 12:46:15 -0500
Message-ID: <20260228174750.1542406-664-sashal@kernel.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 3c4ae63073d84abee5d81ce46d86a94e9dae9c89 ]

The mmio regmap that may be allocated during probe is never freed.

Switch to using the device managed allocator so that the regmap is
released on probe failures (e.g. probe deferral) and on driver unbind.

Fixes: 61de83fd8256 ("mux: mmio: Do not use syscon helper to build regmap")
Cc: stable@vger.kernel.org	# 6.16
Cc: Andrew Davis <afd@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://patch.msgid.link/20251127134702.1915-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mux/mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mux/mmio.c b/drivers/mux/mmio.c
index 9993ce38a818d..5b0171d19d430 100644
--- a/drivers/mux/mmio.c
+++ b/drivers/mux/mmio.c
@@ -58,7 +58,7 @@ static int mux_mmio_probe(struct platform_device *pdev)
 		if (IS_ERR(base))
 			regmap = ERR_PTR(-ENODEV);
 		else
-			regmap = regmap_init_mmio(dev, base, &mux_mmio_regmap_cfg);
+			regmap = devm_regmap_init_mmio(dev, base, &mux_mmio_regmap_cfg);
 		/* Fallback to checking the parent node on "real" errors. */
 		if (IS_ERR(regmap) && regmap != ERR_PTR(-EPROBE_DEFER)) {
 			regmap = dev_get_regmap(dev->parent, NULL);
-- 
2.51.0

