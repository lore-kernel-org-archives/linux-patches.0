Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA4E1D5141;
	Wed, 25 Feb 2026 01:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983654; cv=none; b=FI8AT02jV3zD6+N60vG6B/WSTrENPYIJ1bp7EXY3nXeT1N+IyYbM63ZDOzcYq6Bysv76b2SucmIV3tBVClruUmHrNVHmYY/lb2UKNRqki0lAxsvWHs90wjrVr+TxoKfKhtSQ4NAjfN3fbC1El1xOWslSIAAWaQcTP8fEh9mAMYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983654; c=relaxed/simple;
	bh=zXN5lBK6rskL2/If81XLU0jr339E0H39+JyNGLtLhrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bPT3qNDWp3Ac6Bg0WdXSmc2wy3axYzkytRqYYDi8kW/LU3oHFaIKFssF8XVw2AKk4MFBBzyfjeYYEPJPY0arYcO5a6ElT/vg2U6rFq+XcjN+TpDvAMslotVJ/BmOy0HpOibPZgysDrmpkpuZ47ZCICje0rbvmLEcDbskZYMoT8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxGZQHRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxGZQHRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6E1C116D0;
	Wed, 25 Feb 2026 01:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983654;
	bh=zXN5lBK6rskL2/If81XLU0jr339E0H39+JyNGLtLhrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxGZQHRdjWO4L/t7DjouxnHJLkig26BSNDG9k6x8tDABtHEKaDfFdDv6Kki+uMG1+
	 w3AKTyE8OTK25l6IXTABdTGCnXg4ld8swX6lH6fVqWYnPQTMGyXEVpKFFcS/qygU+o
	 NbusS95j1e5i8mj5O2dIOy5fr8uhIJWug36UR8X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 740/781] drm/amd/display: Only use analog link encoder with analog engine
Date: Tue, 24 Feb 2026 17:24:09 -0800
Message-ID: <20260225012417.878704478@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit f402898bd101af3166bde236b7f6a43d926e17a0 ]

Some GPUs have analog connectors that work with a DP bridge chip
and don't actually have an internal DAC: Those should not use
the analog link encoder code path.

Fixes: 0fbe321a93ce ("drm/amd/display: Implement DCE analog link encoders (v2)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c   | 3 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c | 3 ++-
 drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
index d40d91ec2035f..a916872db7bd4 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
@@ -638,7 +638,8 @@ static struct link_encoder *dce100_link_encoder_create(
 	if (!enc110)
 		return NULL;
 
-	if (enc_init_data->connector.id == CONNECTOR_ID_VGA) {
+	if (enc_init_data->connector.id == CONNECTOR_ID_VGA &&
+	    enc_init_data->analog_engine != ENGINE_ID_UNKNOWN) {
 		dce110_link_encoder_construct(enc110,
 			enc_init_data,
 			&link_enc_feature,
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
index 068fb1df8d889..90d826237cf00 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -733,7 +733,8 @@ static struct link_encoder *dce60_link_encoder_create(
 	if (!enc110)
 		return NULL;
 
-	if (enc_init_data->connector.id == CONNECTOR_ID_VGA) {
+	if (enc_init_data->connector.id == CONNECTOR_ID_VGA &&
+	    enc_init_data->analog_engine != ENGINE_ID_UNKNOWN) {
 		dce60_link_encoder_construct(enc110,
 			enc_init_data,
 			&link_enc_feature,
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
index 8687104cabb72..cde2c2cba1dd6 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
@@ -740,7 +740,8 @@ static struct link_encoder *dce80_link_encoder_create(
 	if (!enc110)
 		return NULL;
 
-	if (enc_init_data->connector.id == CONNECTOR_ID_VGA) {
+	if (enc_init_data->connector.id == CONNECTOR_ID_VGA &&
+	    enc_init_data->analog_engine != ENGINE_ID_UNKNOWN) {
 		dce110_link_encoder_construct(enc110,
 			enc_init_data,
 			&link_enc_feature,
-- 
2.51.0



