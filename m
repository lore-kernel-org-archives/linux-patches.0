Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394354B8DE6;
	Sat, 28 Feb 2026 17:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301331; cv=none; b=HPF9JYfZpLAQeqLZ4vgweuUH+HdZLUsWw/NF+kXpMQRTI+45PY5XMlIKkzzhSjZQGJiO+vUnEZtgv//tIJxbs3yelffwvBrrZqpsI+VRcubSKQcwrPhntVnwpGufHqi//2CNqj7hYwqGl+wihbyvMHxLzWF1HLOo2/XuHsxMPjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301331; c=relaxed/simple;
	bh=W+gTu0H6JhHAnfGgON93jd0Og1WUEHEzknCmsh4qEWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlEcKjDF9chD5+7dF57TfjhJ3383IPOglaGDJBNgp+T8OdZ9lTy1mGFKtvgGn4201bM5l1Sm9zyKyllKrFoKM1INbJseiVe7AvOOqv/so0UNdt/y80MrhUnQpjFO7pmRixI+ctxAjC3LBR3kX2LGUnWtdu4/JSHpX2WxdDc/Qf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZE6s4D5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZE6s4D5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EB4C116D0;
	Sat, 28 Feb 2026 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301331;
	bh=W+gTu0H6JhHAnfGgON93jd0Og1WUEHEzknCmsh4qEWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZE6s4D5iSI8c8BL3QuS45m0ABc0Kjt2X6+YjGxwXqsGUzKrCDi9KzMxESVUJAu1xt
	 UBIph6m0yvch0m3bkq9zNS9PQD6cPDRs59q/c7cjbD2TqoT4lJm+iyZ/+6TXaGVkTY
	 aMG67Kz88CD8StkIHuZ84IoKx/cDaQ+myRZPLzjghXsxiHky5a79xRsJ8dGFxVxeHG
	 BGIDftJBQ92SdxZ1efHDNLNqslkLHFEssQXjrbp3C5ruL7auV3NQmgNrreul1u2H5Y
	 N6OJ4fpJd+M2v7iRl4eCPIkQ8FQKhNukwNJl5PWjOpXAjQGGPiAKuDNqcRLicpyG00
	 AKm0UldSaaOYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <hansg@kernel.org>,
	stable@vger.kernel.org,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 518/752] media: i2c: ov01a10: Fix analogue gain range
Date: Sat, 28 Feb 2026 12:43:49 -0500
Message-ID: <20260228174750.1542406-518-sashal@kernel.org>
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

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 109e0feacaeca5ec2dd71d7d17c73232ce5cbddc ]

A analogue maximum gain of 0xffff / 65525 seems unlikely and testing
indeed shows that the gain control wraps-around at 16383, so set the
maximum gain to 0x3fff / 16383.

The minimum gain of 0x100 is correct. Setting bits 8-11 to 0x0 results
in the same gain values as setting these bits to 0x1, with bits 0-7
still increasing the gain when going from 0x000 - 0x0ff in the exact
same range as when going from 0x100 - 0x1ff.

Fixes: 0827b58dabff ("media: i2c: add ov01a10 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Tested-by: Mehdi Djait <mehdi.djait@linux.intel.com> # Dell XPS 9315
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
[Sakari Ailus: mention analogue gain and update the limit from 4096.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov01a10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov01a10.c b/drivers/media/i2c/ov01a10.c
index 0b1a1ecfffd0e..834ca46acb75f 100644
--- a/drivers/media/i2c/ov01a10.c
+++ b/drivers/media/i2c/ov01a10.c
@@ -48,7 +48,7 @@
 /* analog gain controls */
 #define OV01A10_REG_ANALOG_GAIN		0x3508
 #define OV01A10_ANAL_GAIN_MIN		0x100
-#define OV01A10_ANAL_GAIN_MAX		0xffff
+#define OV01A10_ANAL_GAIN_MAX		0x3fff
 #define OV01A10_ANAL_GAIN_STEP		1
 
 /* digital gain controls */
-- 
2.51.0

