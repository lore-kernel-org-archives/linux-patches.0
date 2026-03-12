Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44BA346FB3;
	Thu, 12 Mar 2026 20:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346312; cv=none; b=mTxw4gICYfI/k3QekUAfGZrLr9H+XBJ5F3VJDOvTuPH1LVTZesfiyb+Dh88wPPP+rACqaGXWZC3b9+cayrwU5QNHaYUfN0aJIFQ5t8KvcP9N75jvt77MTdNBAMdMo3EYddFMPzgH61LefeB6fuIWdKijt2u1C522nxFwsjQSQhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346312; c=relaxed/simple;
	bh=zm+l6gZ9fQ9gL+QuXCE2A/8Ld+BCEHid08AcQrwVOyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLxlHbebjx6UgSZAdHvvt6tqeWav01DgEBoij1jB5CNr+hGXvUqicj3G9CtuHl7W2ZP+mHAVI2BZD1KmBaLwB3L0WwowCib/nAd3/J5ecDckK+Lx7eLhtRDFcrotThOWjLHBd6UQsRj3X/Oom7OcjpOBurstii1Wxc+kDeMhGfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmWrcNLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmWrcNLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F24C4CEF7;
	Thu, 12 Mar 2026 20:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346312;
	bh=zm+l6gZ9fQ9gL+QuXCE2A/8Ld+BCEHid08AcQrwVOyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmWrcNLV3nYau5amTH/uzSJKbgWka70+tYni376N/2qy1ifD0ZmYcOmHqifr/70g8
	 vSjrSk/8tAh69ZcBdOfFg9gLFirBOnbgRAcBM7JweZCiEjEJjIP1nSgkLuc1o+0T4U
	 6SungYf1prhnmIz5fxECdMI/pelgvMmhFypnt75g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/265] drm/logicvc: Fix device node reference leak in logicvc_drm_config_parse()
Date: Thu, 12 Mar 2026 21:06:30 +0100
Message-ID: <20260312201018.262188575@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 01a37e28c0803..6d88f86459882 100644
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



