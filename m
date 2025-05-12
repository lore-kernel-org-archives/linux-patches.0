Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76D41DC1A7;
	Mon, 12 May 2025 17:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071149; cv=none; b=ag87yeLDbGk9d+MoUWuy3O4mH2ZGSUizFJ1TpWnzVKRjW2V1uy6Y374hcvmruEQtsFl9GmYMsf0GhJ2wPSuEMaBGmBc6sksawuDm/Sfh1IbX/nCpXPHydYFXG3zKKEoSSSybnsHt0IzpoMq8bPjF9Q63rfk9L1mrF2Oro8BT8+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071149; c=relaxed/simple;
	bh=bR3DqavTRnAJn5rnHysvybQJh57c9fbxOyvF3cL88gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjGIlx1WRa3fI9Z4vrv05KKKqwkTzvK28m1Vw7Ixh4v4+BXI95AbJZT8D1AIfvHNX6++SL7r6x/r/i431L4sO1mjGF2RnzAtuFjwKQJ6IA5jKTQV/zhQ0jNs63emmIXV+UjWUz4lfMiu1CHGBealF2ix2cAUAeQE5cX2asGxOVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=de1VCrE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="de1VCrE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5865CC4CEE7;
	Mon, 12 May 2025 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071149;
	bh=bR3DqavTRnAJn5rnHysvybQJh57c9fbxOyvF3cL88gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=de1VCrE54OsKT6W82I9itd8/c0BZgpEQPoB81Dpj1LkgjDBDXUwKG5PG4rpRQmTD3
	 r5FS8h44MSC4jWnUaG8C8cGnOUSS6p+RuoZM9qRGdeRWqfRmyA+Qscn8dQf2atam3V
	 XSAheqk5vJ3+cM2oNqx9wpvUi0iEJuI2lT/E5jhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.15 28/54] drm/amd/display: Fix wrong handling for AUX_DEFER case
Date: Mon, 12 May 2025 19:29:40 +0200
Message-ID: <20250512172016.778203842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -53,6 +53,9 @@
 #include "dc/dcn20/dcn20_resource.h"
 #endif
 
+/*
+ * This function handles both native AUX and I2C-Over-AUX transactions.
+ */
 static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 				  struct drm_dp_aux_msg *msg)
 {
@@ -87,15 +90,25 @@ static ssize_t dm_dp_aux_transfer(struct
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
@@ -114,6 +127,13 @@ static ssize_t dm_dp_aux_transfer(struct
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
 


