Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4083B2FF2;
	Mon, 23 Mar 2026 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275121; cv=none; b=kOh5Etv3DfEacCULQ4Uv7QjYQIvSjYl2/4ZzMU0qYEgnB/pgR651RQK7xH37rK7Dto2gV+BizqKBZPAEkYSziavZXt80vNZxXe++FiGsugBfVtv9vy2MhLMH5CslwCMusppnTza9luHctTkApEGQI+JEOLxw/e1IM83Desh8Pg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275121; c=relaxed/simple;
	bh=vTv0SIedwz5JXMEjq3a2zevoVLKVOYUZi9muRC8Avw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGZ3jYyD6pVMN49wGboy+ojHq6J7XCZvG0qyGniCFKWJ3rsWMjjHE3v4lgYRIr9dMVhghVofvzW5UDROsuRYL3GBnpByo0qzp1oaETG8y4eheu8XKT5WVazdg75IIqFlqRhEB/4mfnH6ovrWz3Fp6vGd31krNP1kbi7d7G/2c7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4PpRLta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4PpRLta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB6CC2BCB3;
	Mon, 23 Mar 2026 14:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275121;
	bh=vTv0SIedwz5JXMEjq3a2zevoVLKVOYUZi9muRC8Avw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4PpRLtawFtLCyURt6HhXGq4JWdvrt3Uebm0YNFV5sGYc7HQK3pOEpKN/obja82GA
	 8meu+CWEhpuUVq8fND7dugHk88Hy3o/xcJ3HehxZU3tfWkYNd8lS3ZHL4M0eBjbehn
	 rgOMUCj77Gbsyx73qYIkNROQS9NL33OYRNOP3OFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/481] drm/logicvc: Fix device node reference leak in logicvc_drm_config_parse()
Date: Mon, 23 Mar 2026 14:39:45 +0100
Message-ID: <20260323134525.344025330@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index cc9a4e965f779..8cbf4f2debf7d 100644
--- a/drivers/gpu/drm/logicvc/logicvc_drm.c
+++ b/drivers/gpu/drm/logicvc/logicvc_drm.c
@@ -90,7 +90,6 @@ static int logicvc_drm_config_parse(struct logicvc_drm *logicvc)
 	struct device *dev = drm_dev->dev;
 	struct device_node *of_node = dev->of_node;
 	struct logicvc_drm_config *config = &logicvc->config;
-	struct device_node *layers_node;
 	int ret;
 
 	logicvc_of_property_parse_bool(of_node, LOGICVC_OF_PROPERTY_DITHERING,
@@ -126,7 +125,8 @@ static int logicvc_drm_config_parse(struct logicvc_drm *logicvc)
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



