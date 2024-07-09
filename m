Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942AE15886A;
	Tue,  9 Jul 2024 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524026; cv=none; b=oSmDDreHyvspT4cza0sxB9WTuJoj75S4dQeULqM7HGGv+BH6eHxojDhthtz5oM0Qg1qITR39JjDydjyQn6Z7cxlop8IovhKehJgUwb5XJsj6T2mfI1/SFvj7lLrL0xe2b1vbynXXmSIQL6R+O6uFyHkKRIkkBkD76bFm6uBOrU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524026; c=relaxed/simple;
	bh=Ft72WYgnb4rJfkKhxo71ZJEkKSbdmCELaFqZbnMO8bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrw3oRx/ts7nZShYJ7U/xwejKJGsb8xdzcSuP5mBVBSjIDLzD97vk2FewdYLNqPxFtpWcnRTxVmd+qsGkKr2vH0Bt6Y9HX68YDQ4UKa6ntnaE+zrz9BHZAfJAygSbd9+Kj6j6nuTOH/AeXTSn3dFNu0HVWU4ILzGHMsUgZPphNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWtBfKWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWtBfKWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FA4C3277B;
	Tue,  9 Jul 2024 11:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524026;
	bh=Ft72WYgnb4rJfkKhxo71ZJEkKSbdmCELaFqZbnMO8bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWtBfKWfNYrfWo8A3c+rnb/fnkCrQri4xx+JpOsOUZ9lfcgjqyvjBDkhzdwdzP+Mb
	 E63w2DejyJ+Hd3KhaquzG9XhYj3ikL6ax6eTeSCiebWnRKFOae3rtlC0YV4D4RmcUy
	 i9xZee9dkZrdqAUIUxyHCMmBGatuU5tYceE8ojsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 029/197] drm/amd/display: Check index msg_id before read or write
Date: Tue,  9 Jul 2024 13:08:03 +0200
Message-ID: <20240709110710.044869819@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 59d99deb330af206a4541db0c4da8f73880fba03 ]

[WHAT]
msg_id is used as an array index and it cannot be a negative value, and
therefore cannot be equal to MOD_HDCP_MESSAGE_ID_INVALID (-1).

[HOW]
Check whether msg_id is valid before reading and setting.

This fixes 4 OVERRUN issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
index f7b5583ee609a..8e9caae7c9559 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -156,6 +156,10 @@ static enum mod_hdcp_status read(struct mod_hdcp *hdcp,
 	uint32_t cur_size = 0;
 	uint32_t data_offset = 0;
 
+	if (msg_id == MOD_HDCP_MESSAGE_ID_INVALID) {
+		return MOD_HDCP_STATUS_DDC_FAILURE;
+	}
+
 	if (is_dp_hdcp(hdcp)) {
 		while (buf_len > 0) {
 			cur_size = MIN(buf_len, HDCP_MAX_AUX_TRANSACTION_SIZE);
@@ -215,6 +219,10 @@ static enum mod_hdcp_status write(struct mod_hdcp *hdcp,
 	uint32_t cur_size = 0;
 	uint32_t data_offset = 0;
 
+	if (msg_id == MOD_HDCP_MESSAGE_ID_INVALID) {
+		return MOD_HDCP_STATUS_DDC_FAILURE;
+	}
+
 	if (is_dp_hdcp(hdcp)) {
 		while (buf_len > 0) {
 			cur_size = MIN(buf_len, HDCP_MAX_AUX_TRANSACTION_SIZE);
-- 
2.43.0



