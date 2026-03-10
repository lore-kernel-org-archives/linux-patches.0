Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D76D387587;
	Tue, 10 Mar 2026 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141640; cv=none; b=S/oWRDt06TMj/AiJN/D56lAHaanEevNSl45ui91AfiZ+kqEI2YIMOYCNTU8ZvsCQjjr+48TQowaWzQ8ujZGnOVfxd33mAMYIxWQgjzjv4PIMT2bYyNa7wnvEWAisF/XexCUfuzZBGWycq1lPue85ojBK/uswbPMsQbkIVNa/bRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141640; c=relaxed/simple;
	bh=zFumHkeSM8QYCpSP35/AqKDPMjs7xJ4F/GL+7MF/eUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ29mfh4fC7GoDABqDxOo8vYRPPf6u28FZVRJbZvBDwVnYJo3kEttPb0Wm0+5oWGkeVKwqnVA90gKtPN0sgUjZUsV9g5xR10R0ZYqGjEFORdjFsqBP5oNq3c5WydD5o1IHrLtQc4tZ4tcQc39bJftjH54leeQkmPz/lTjKnqbS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNXwVeUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNXwVeUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B642C2BC9E;
	Tue, 10 Mar 2026 11:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141640;
	bh=zFumHkeSM8QYCpSP35/AqKDPMjs7xJ4F/GL+7MF/eUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNXwVeUocJgJKXtXXw92tj8Y+qGtb58uXEK4K5ZHGAgqC4TPqVowkupGkPvBFxAht
	 hxOa2YwqFUF4Hzhguu7LzvUBJyqvbVxrjPy5Zxy8/0pscrjCHcFUHgOU97NVVnrsnx
	 MioAgStRIqPxB8JL7wpMxq18T4AgY6WOn3sSZtbuyH4rzEpK1/h6uSp4ZOLbhaBP8B
	 XAq/CxTlNdTHv2i31F8Wi6oV2qsel/xD9xXs/IEuBXokcZaLadtXEWp2WVU5/Uwls+
	 Ha1Xa5suOynBl3RWlOFk7D4dmNGfoXvR4FQh9kyTARQkcVzfc7xwmfQF/sDlBdCZ3F
	 voSzxbu3NCwrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <ustc.gu@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/314] drm/logicvc: Fix device node reference leak in logicvc_drm_config_parse()
Date: Tue, 10 Mar 2026 07:14:24 -0400
Message-ID: <70c4ee8db7ec4184d155807634c37f208ddf5b4d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit fef0e649f8b42bdffe4a916dd46e1b1e9ad2f207 ]

The logicvc_drm_config_parse() function calls of_get_child_by_name() to
find the "layers" node but fails to release the reference, leading to a
device node reference leak.

Fix this by using the __free(device_node) cleanup attribute to automatic
release the reference when the variable goes out of scope.

Fixes: efeeaefe9be5 ("drm: Add support for the LogiCVC display controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260130-logicvc_drm-v1-1-04366463750c@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/logicvc/logicvc_drm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/logicvc/logicvc_drm.c b/drivers/gpu/drm/logicvc/logicvc_drm.c
index 204b0fee55d0b..bbebf4fc7f51a 100644
--- a/drivers/gpu/drm/logicvc/logicvc_drm.c
+++ b/drivers/gpu/drm/logicvc/logicvc_drm.c
@@ -92,7 +92,6 @@ static int logicvc_drm_config_parse(struct logicvc_drm *logicvc)
 	struct device *dev = drm_dev->dev;
 	struct device_node *of_node = dev->of_node;
 	struct logicvc_drm_config *config = &logicvc->config;
-	struct device_node *layers_node;
 	int ret;
 
 	logicvc_of_property_parse_bool(of_node, LOGICVC_OF_PROPERTY_DITHERING,
@@ -128,7 +127,8 @@ static int logicvc_drm_config_parse(struct logicvc_drm *logicvc)
 	if (ret)
 		return ret;
 
-	layers_node = of_get_child_by_name(of_node, "layers");
+	struct device_node *layers_node __free(device_node) =
+		of_get_child_by_name(of_node, "layers");
 	if (!layers_node) {
 		drm_err(drm_dev, "Missing non-optional layers node\n");
 		return -EINVAL;
-- 
2.51.0

