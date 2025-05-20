Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E559119ABB6;
	Tue, 20 May 2025 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750234; cv=none; b=AiBou4mcHZOcLUotBfUIMuRc4/z4oLZu+lbaVLmSCIXOkmmpd2cosdqzAQsTctzeO3wCE23526zinCEnZOQUxAanW49wJ5AO4miWL5dnkojKAfQo2ulp4KM3nZ3/5xYdNUzhgcmMygUKe8Jy219v6mseFG+ZQRMGM9stW0dVqfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750234; c=relaxed/simple;
	bh=loW77w5skyVjOdz/bv9tW/0ncflEH1V2jzd2CbVhiPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soXfpqsej1b8ObNjWB78DIBf1W4l5TsRDIUXEgtiT0IUVm44VzHAO3KgH+Mk+i4X3UF5kcA23SmjafxQqOYAKsbXm/XJ1UXzTFtXO2ruJM9IRSw3ts6I18BjLyLuxzBNPUIstVdpsPeNYoaTrRI2nks7RB8Zdh4egmy28zWzKhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ewfnt+KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ewfnt+KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FB2C4CEEB;
	Tue, 20 May 2025 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750233;
	bh=loW77w5skyVjOdz/bv9tW/0ncflEH1V2jzd2CbVhiPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ewfnt+KLniPSUYmjkH0q6fRe7fkBE6F+9ZqEtZSIFXpg4I1pepJbPs4jbw8f0AnYq
	 izrlwY/jYcpvu2p+YS97ewaZVd7nEuqgTISMELj9KsyykRMKPGZFVvY5MECRxi53rT
	 PAjFsZKw2nuGjIHWSZ80pV2EpZb1eA+1S42PpJXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 086/143] drm/amd/display: Correct the reply value when AUX write incomplete
Date: Tue, 20 May 2025 15:50:41 +0200
Message-ID: <20250520125813.443756390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Wayne Lin <Wayne.Lin@amd.com>

commit d433981385c62c72080e26f1c00a961d18b233be upstream.

[Why]
Now forcing aux->transfer to return 0 when incomplete AUX write is
inappropriate. It should return bytes have been transferred.

[How]
aux->transfer is asked not to change original msg except reply field of
drm_dp_aux_msg structure. Copy the msg->buffer when it's write request,
and overwrite the first byte when sink reply 1 byte indicating partially
written byte number. Then we can return the correct value without
changing the original msg.

Fixes: 3637e457eb00 ("drm/amd/display: Fix wrong handling for AUX_DEFER case")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7ac37f0dcd2e0b729fa7b5513908dc8ab802b540)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    3 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12546,7 +12546,8 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		/* The reply is stored in the top nibble of the command. */
 		payload->reply[0] = (adev->dm.dmub_notify->aux_reply.command >> 4) & 0xF;
 
-	if (!payload->write && p_notify->aux_reply.length)
+	/*write req may receive a byte indicating partially written number as well*/
+	if (p_notify->aux_reply.length)
 		memcpy(payload->data, p_notify->aux_reply.data,
 				p_notify->aux_reply.length);
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -62,6 +62,7 @@ static ssize_t dm_dp_aux_transfer(struct
 	enum aux_return_code_type operation_result;
 	struct amdgpu_device *adev;
 	struct ddc_service *ddc;
+	uint8_t copy[16];
 
 	if (WARN_ON(msg->size > 16))
 		return -E2BIG;
@@ -77,6 +78,11 @@ static ssize_t dm_dp_aux_transfer(struct
 			(msg->request & DP_AUX_I2C_WRITE_STATUS_UPDATE) != 0;
 	payload.defer_delay = 0;
 
+	if (payload.write) {
+		memcpy(copy, msg->buffer, msg->size);
+		payload.data = copy;
+	}
+
 	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
 				      &operation_result);
 
@@ -100,9 +106,9 @@ static ssize_t dm_dp_aux_transfer(struct
 	 */
 	if (payload.write && result >= 0) {
 		if (result) {
-			/*one byte indicating partially written bytes. Force 0 to retry*/
+			/*one byte indicating partially written bytes*/
 			drm_info(adev_to_drm(adev), "amdgpu: AUX partially written\n");
-			result = 0;
+			result = payload.data[0];
 		} else if (!payload.reply[0])
 			/*I2C_ACK|AUX_ACK*/
 			result = msg->size;


