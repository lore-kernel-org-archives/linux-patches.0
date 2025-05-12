Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9829AAE1;
	Mon, 12 May 2025 18:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073449; cv=none; b=PNOvsKm6nJEUwQf8kuloMG1GYusqaT6Hptd0xmduHhKiwrW0fpI7K9b6koS+LB4jY8KzaPQblQvbHPDYKTdBbcIWwEc+MH+FhcqzsCkI8lUAxXC4MrF3Ih31GzD1CFS+zxNnpFuyH1K1sY9ztiWzeG9azs30Hs55tyrG8cB+Sz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073449; c=relaxed/simple;
	bh=2MLp8LeNJhAJVYohUSZzwX/Wshe+KOvpR7Y7NC9AHa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pN85KDTQarEyQN/55VgS8YrPJyLVfeJXLl3BdzA5uIJ0gUbySVvmWrESWyYvxE8hW/+RqQdQO5rroudTF9LQKU328lBblsWvZXEBlglJ1HyEnj7D/MOSL8IMG/CsE2DzeSRUjdecVytI9Sx9rEBIXWqpB11TV6J9bOValgOC3d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xq0lfNcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xq0lfNcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980E9C4CEE7;
	Mon, 12 May 2025 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073448;
	bh=2MLp8LeNJhAJVYohUSZzwX/Wshe+KOvpR7Y7NC9AHa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xq0lfNcZpIlsYypnpuv0DfxgVjk8RZ9obKLDGVduU3ksZlCjCsKrJZ4R14Q8r535b
	 K9MKdFkMq0m4+3oN4aLpwCF545RId2odvEhHsO2XYC9S/MR5BSaWv5kcnKBpbeJxHU
	 nfapFW1CUxg8Zfb9Z8oMWxmBCqv+wG+YHq1zTaw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 051/113] drm/amd/display: Fix wrong handling for AUX_DEFER case
Date: Mon, 12 May 2025 19:45:40 +0200
Message-ID: <20250512172029.751151755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit 65924ec69b29296845c7f628112353438e63ea56 upstream.

[Why]
We incorrectly ack all bytes get written when the reply actually is defer.
When it's defer, means sink is not ready for the request. We should
retry the request.

[How]
Only reply all data get written when receive I2C_ACK|AUX_ACK. Otherwise,
reply the number of actual written bytes received from the sink.
Add some messages to facilitate debugging as well.

Fixes: ad6756b4d773 ("drm/amd/display: Shift dc link aux to aux_payload")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3637e457eb0000bc37d8bbbec95964aad2fb29fd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   28 ++++++++++--
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -48,6 +48,9 @@
 
 #define PEAK_FACTOR_X1000 1006
 
+/*
+ * This function handles both native AUX and I2C-Over-AUX transactions.
+ */
 static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 				  struct drm_dp_aux_msg *msg)
 {
@@ -84,15 +87,25 @@ static ssize_t dm_dp_aux_transfer(struct
 	if (adev->dm.aux_hpd_discon_quirk) {
 		if (msg->address == DP_SIDEBAND_MSG_DOWN_REQ_BASE &&
 			operation_result == AUX_RET_ERROR_HPD_DISCON) {
-			result = 0;
+			result = msg->size;
 			operation_result = AUX_RET_SUCCESS;
 		}
 	}
 
-	if (payload.write && result >= 0)
-		result = msg->size;
+	/*
+	 * result equals to 0 includes the cases of AUX_DEFER/I2C_DEFER
+	 */
+	if (payload.write && result >= 0) {
+		if (result) {
+			/*one byte indicating partially written bytes. Force 0 to retry*/
+			drm_info(adev_to_drm(adev), "amdgpu: AUX partially written\n");
+			result = 0;
+		} else if (!payload.reply[0])
+			/*I2C_ACK|AUX_ACK*/
+			result = msg->size;
+	}
 
-	if (result < 0)
+	if (result < 0) {
 		switch (operation_result) {
 		case AUX_RET_SUCCESS:
 			break;
@@ -111,6 +124,13 @@ static ssize_t dm_dp_aux_transfer(struct
 			break;
 		}
 
+		drm_info(adev_to_drm(adev), "amdgpu: DP AUX transfer fail:%d\n", operation_result);
+	}
+
+	if (payload.reply[0])
+		drm_info(adev_to_drm(adev), "amdgpu: AUX reply command not ACK: 0x%02x.",
+			payload.reply[0]);
+
 	return result;
 }
 


