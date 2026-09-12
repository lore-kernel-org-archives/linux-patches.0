Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77C8346AE3;
	Sat, 12 Sep 2026 07:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198826; cv=none; b=YfVOHxLodniomobaURusMLxujHqYnAy2JeOmNZxG4rDZ/RNwzdLOS+2Hrqu0E+Ypb71FC1N5Fe20ZCLqyk2FOWJmqhP9vbgSy5LN/krrX/+jhbTcEuaFn7Z40E4xfeUJMhbBR3qDa88i4ovWZ0m1Ey5M/aOQFX0DWJoZg/YjyAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198826; c=relaxed/simple;
	bh=dAUWZ252aby51+dIgJ2PyjNzC50b98glzitD+JT5HdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKipuLo48VpabHNCDKatEhDFmBrCGGNLMkg5cXvn022edkbWLfHzKJ8DRLOw6p5daVTdTRDgWBWyroH1WVDrX1BowmG3L3JnBCWR0eSsy2AK5yn/3KedadYQWDezoaHWfEn1sBNx1OOyuKanuMrt/5jyyqs3Faxh3pMcSxCnU2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeeuQKb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeeuQKb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2721F000FF;
	Sat, 12 Sep 2026 07:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198825;
	bh=NbcLI85BO/58IA0rDI+s2JOzZRsHLygh1YkNIU8QzIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CeeuQKb7c0EN6Ko5xyxwI/j7GV5/U7E7Mz35OuEnkxoObXnJrgQky+Baurjyay4dC
	 eETSfTgVxO2gKoI/3OO2mxjYb1crPKi+qfODJ9eZz9jc/e+M4Qp78XKOv52civ++/O
	 MnrKqHa4teb8pdKW7YgfHhaY/HgAmaIFcfCErj+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <john@groves.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0417/1815] dax/fsdev: clear vmemmap_shift when binding static pgmap
Date: Sat, 12 Sep 2026 08:36:07 +0200
Message-ID: <20260912065658.683324886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Groves <John@Groves.net>

[ Upstream commit e0239229931faf9ca3367e3befcf16f77b2cd45b ]

Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a static
device from device_dax (which may set vmemmap_shift based on alignment) to
fsdev_dax, the stale vmemmap_shift persists on the shared pgmap. Explicitly
zero it before devm_memremap_pages() so the vmemmap is built for order-0
folios as fsdev requires.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
Link: https://patch.msgid.link/0100019ecc090eea-7c46f51e-5393-402c-850d-78059bb6d343-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/fsdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index f315533b299e9..dbd722ed7ab05 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -237,6 +237,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		}
 
 		pgmap = dev_dax->pgmap;
+		pgmap->vmemmap_shift = 0;
 	} else {
 		size_t pgmap_size;
 
-- 
2.53.0



