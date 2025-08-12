Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559CB27781E;
	Tue, 12 Aug 2025 19:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025594; cv=none; b=UBgGSfJU9zl4ijYC5+3BNqdR8eGtZzF4bir2wWn98YLog7BtWcWKepYIxvDkAG5Bs+J8B9gemnRElGgOuOfuS819Pqx/cuqnor60IggjAA0R4lrFLEdjtbX3ACvKrqdZgg6Wlqn2D0p9juPbANbVZkbOpGY7oJiynQks6onZkrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025594; c=relaxed/simple;
	bh=mA0MwtwcZe5bQvlpMr8sJrYqvsKlC3YATC3lnaynOvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uffzoEu7e1HUiHn4/9M0xf+jdu59JRFJztC622Tu5gqPqocrxS7g+BNSo61NnbKCTYpCQnrMuP60GgYrNFrc3t2/T7/Cz50NO3ZVNuAD3bw5+vT9MyJxRQmHlGDqoxEEATZPQ/ZJ8aOKbYXQIOK6VwsVFDdIWIaTxEKeDLm9VL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFSRKNVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFSRKNVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5F2C4CEF0;
	Tue, 12 Aug 2025 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025593;
	bh=mA0MwtwcZe5bQvlpMr8sJrYqvsKlC3YATC3lnaynOvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFSRKNVb6hT8dSvCS9a2dyV4/HxjuTItpMtgwM1m+bXiCyjSDz+mi1iVM7eXv+6YP
	 qOsqapjumqlguoeZlktbjxuvS8LvRLSzrWIP6gWLc1eqVAbbxuBlMIVhprh6ExpDc8
	 YGfTnfG772mBUfdkKmImV//nl2PameA1Rb7M2pkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@kernel.org>,
	greybus-dev@lists.linaro.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 088/480] staging: greybus: gbphy: fix up const issue with the match callback
Date: Tue, 12 Aug 2025 19:44:56 +0200
Message-ID: <20250812174401.079187621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



