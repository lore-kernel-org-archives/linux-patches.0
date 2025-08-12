Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDE2191F98;
	Tue, 12 Aug 2025 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023560; cv=none; b=eA5m7d0rmOyjHszyxN5SjQ41nxNXZzmMdTUWCvFxo7LrG6QmVa+Mr92CSAQh0adCpEFVnpdjVrrnQaZwG41tZ5Yr2xrdeL3x0rcCUnTeP96Y+hp+xoCo6X/RViibucUGm+m0KzwDL8E3aRmR51Xcyh6Z67pcOlDXZDiDqu/ue/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023560; c=relaxed/simple;
	bh=S9VKdWS5dVrfIKKcryMfpzhdlNYnsqGImzVgJREaLCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W84nj3rFBcGrRftjCMBZSonN9nDZ3pj6q5CvKQ0JCh7WVArpwTgxcbNyZzTrtUqLK1ZLmyFGPgnVi/OdDmZL6ImRrcbaJmHdBg++ID9hipnPGo8iFhjzjzybnVX4Ep/VvQcL804nL4J2PLCjXJYH4ooxxCUsT3tntsfij+k91/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6cFDbRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6cFDbRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A5CC4CEF0;
	Tue, 12 Aug 2025 18:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023559;
	bh=S9VKdWS5dVrfIKKcryMfpzhdlNYnsqGImzVgJREaLCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6cFDbRL2q2eyQVXmpVOfphRU8GcwPCgR6z21QJVcv0mRtMgbC0WzSQ3srVmHkn4A
	 5q9RaxRNbo2rck6yoKPI/XL0reH0w0uLXT+XIJqXk4Som6z5KU2nlOg2aIUDxCseFn
	 8B8lC5z535X4xc4DtNdTzwjcAIhZJZSVWMN8s7H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@kernel.org>,
	greybus-dev@lists.linaro.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 115/627] staging: greybus: gbphy: fix up const issue with the match callback
Date: Tue, 12 Aug 2025 19:26:50 +0200
Message-ID: <20250812173423.685629795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



