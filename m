Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B9F198E7E;
	Thu,  5 Sep 2024 09:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529539; cv=none; b=tznb2xSIDAjJpOOOKyK2PHaPLfnxrPm8p4yZjxMI1nyTEtJ0qtBnJAQU1dq3zz21QmXPFRppJ6WN9wlOcUh9/PpW1wNWU7W/r+v9f8GINem35krHvUVmzF6WtLHD06WbrLyjc8tvTXYNYTNy7qVGP2kkk/0cRpy9QGCSh1xCs7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529539; c=relaxed/simple;
	bh=FveRny5bY44DoOSCBzroFxkmKdlKfVSSR9lu8IF83Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t06Ww+6qIhtSU37XzE1ns7oJDQnZqzrsufmBAgB+toyOkVKA4hkI5op7Gowfizgr8tPTuNJmItmq2GqiHd60oe4sCEQFlf4hdFZsgBfhsPBKgGfCtjcgtacPvlxWqxVNEVI3iZn1wDKD58z5EybHYvs8/te+NWqK0cZYahRuopY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKAh4mlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKAh4mlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0984EC4CEC3;
	Thu,  5 Sep 2024 09:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529539;
	bh=FveRny5bY44DoOSCBzroFxkmKdlKfVSSR9lu8IF83Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKAh4mlZkJDIXAry82JimxNpVmf1MqPJYM4sYpVSCb/vi02wAbvlVFQJCZCnvri1n
	 fM6nJp5Xp1J51YhpvrMq5lcXY4Glzl8WwA8ngB1B8fzpBdM1WfUN0nbKmeBfAB+bmm
	 vZX9SQIqqchhJrdLN5F37bOywMQB1SsEi11Cx8oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 066/184] drm/amd/display: Check msg_id before processing transcation
Date: Thu,  5 Sep 2024 11:39:39 +0200
Message-ID: <20240905093734.816339054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit fa71face755e27dc44bc296416ebdf2c67163316 ]

[WHY & HOW]
HDCP_MESSAGE_ID_INVALID (-1) is not a valid msg_id nor is it a valid
array index, and it needs checking before used.

This fixes 4 OVERRUN issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c b/drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c
index 99e17c164ce7..1d3e8f0b915b 100644
--- a/drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c
+++ b/drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c
@@ -128,13 +128,21 @@ static bool hdmi_14_process_transaction(
 	const uint8_t hdcp_i2c_addr_link_primary = 0x3a; /* 0x74 >> 1*/
 	const uint8_t hdcp_i2c_addr_link_secondary = 0x3b; /* 0x76 >> 1*/
 	struct i2c_command i2c_command;
-	uint8_t offset = hdcp_i2c_offsets[message_info->msg_id];
+	uint8_t offset;
 	struct i2c_payload i2c_payloads[] = {
-		{ true, 0, 1, &offset },
+		{ true, 0, 1, 0 },
 		/* actual hdcp payload, will be filled later, zeroed for now*/
 		{ 0 }
 	};
 
+	if (message_info->msg_id == HDCP_MESSAGE_ID_INVALID) {
+		DC_LOG_ERROR("%s: Invalid message_info msg_id - %d\n", __func__, message_info->msg_id);
+		return false;
+	}
+
+	offset = hdcp_i2c_offsets[message_info->msg_id];
+	i2c_payloads[0].data = &offset;
+
 	switch (message_info->link) {
 	case HDCP_LINK_SECONDARY:
 		i2c_payloads[0].address = hdcp_i2c_addr_link_secondary;
@@ -308,6 +316,11 @@ static bool dp_11_process_transaction(
 	struct dc_link *link,
 	struct hdcp_protection_message *message_info)
 {
+	if (message_info->msg_id == HDCP_MESSAGE_ID_INVALID) {
+		DC_LOG_ERROR("%s: Invalid message_info msg_id - %d\n", __func__, message_info->msg_id);
+		return false;
+	}
+
 	return dpcd_access_helper(
 		link,
 		message_info->length,
-- 
2.43.0



