Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3386C305E08;
	Tue, 12 Aug 2025 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022121; cv=none; b=bCOkFYqfZDhxteapEctf1KPaq0+eWqE1iP1LrQ1UuEE1XvL2d70uT2eO3CSQSZ3PFDCo9fdtPp2MZfHkd0R+yEbaRgjGwjz4qaNtu4SndCa7jDd9qloZ4d0/7SEfTAOLwgn+VOWs7IwIlBZmCPY/eWQyvFmPcSqpVUWVSMmrurA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022121; c=relaxed/simple;
	bh=pgiO4eYeKZ/zzbJvoH3mlgeLVohG1IERR7TCeGK4kx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AokjHc/IxDfQ2KS2PeuRBLpGZrN0/fW/aoDAsJflU5Hq56aDzzV3rsD8rWdRuNl8PaptFNOyLHZqdL1E0Qx9oO0DY4Z5uNXKBQUlV8UyJhV3bRXwAIfh/GtG+Eivm7S9qIT251+TDw8iDjPB75CWP96v6XkHKBt/U0fu2SYffTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptYuFaqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptYuFaqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B16C4CEF6;
	Tue, 12 Aug 2025 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022121;
	bh=pgiO4eYeKZ/zzbJvoH3mlgeLVohG1IERR7TCeGK4kx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptYuFaqoZ3MEVBIlGFWv8tlxqfMlZMfsvhlVUeIJ4dY8Wn5NNyUl3RW/6LB6cpv3D
	 iEj9c0EnQ0QCYfrZCAeCJia3oKnmuW5vn9NFrlxtQr8HdNm+2nDFahNM9vJaQj877O
	 k99sGJ7ZTkrBTxGlsWxfH2RA3PduhvH/86BxS4Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@kernel.org>,
	greybus-dev@lists.linaro.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/369] staging: greybus: gbphy: fix up const issue with the match callback
Date: Tue, 12 Aug 2025 19:25:57 +0200
Message-ID: <20250812173017.024046225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ce32eff1cf3ae8ac2596171dd0af1657634c83eb ]

gbphy_dev_match_id() should be taking a const pointer, as the pointer
passed to it from the container_of() call was const to start with (it
was accidentally cast away with the call.)  Fix this all up by correctly
marking the pointer types.

Cc: Alex Elder <elder@kernel.org>
Cc: greybus-dev@lists.linaro.org
Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/2025070115-reoccupy-showy-e2ad@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/gbphy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/greybus/gbphy.c b/drivers/staging/greybus/gbphy.c
index 6adcad286633..60cf09a302a7 100644
--- a/drivers/staging/greybus/gbphy.c
+++ b/drivers/staging/greybus/gbphy.c
@@ -102,8 +102,8 @@ static int gbphy_dev_uevent(const struct device *dev, struct kobj_uevent_env *en
 }
 
 static const struct gbphy_device_id *
-gbphy_dev_match_id(struct gbphy_device *gbphy_dev,
-		   struct gbphy_driver *gbphy_drv)
+gbphy_dev_match_id(const struct gbphy_device *gbphy_dev,
+		   const struct gbphy_driver *gbphy_drv)
 {
 	const struct gbphy_device_id *id = gbphy_drv->id_table;
 
@@ -119,7 +119,7 @@ gbphy_dev_match_id(struct gbphy_device *gbphy_dev,
 
 static int gbphy_dev_match(struct device *dev, const struct device_driver *drv)
 {
-	struct gbphy_driver *gbphy_drv = to_gbphy_driver(drv);
+	const struct gbphy_driver *gbphy_drv = to_gbphy_driver(drv);
 	struct gbphy_device *gbphy_dev = to_gbphy_dev(dev);
 	const struct gbphy_device_id *id;
 
-- 
2.39.5



