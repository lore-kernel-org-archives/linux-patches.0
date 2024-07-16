Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C7419E801;
	Tue, 16 Jul 2024 16:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146020; cv=none; b=gqlbFfc09ICHhA/5VZFnDEVgfyAX864dPJgLavhMUryWoSD7gzw7/StlIkooULdoG6y8JBG9BJcwfKW0qgOv9bZZ89u47BYcb8J4HsWmG9VzakOVj/ay6szeMBdv6a1thhT7X0j6wrHUUoUSgs95/q8diVsv67s6EVNUYJIbRhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146020; c=relaxed/simple;
	bh=W4gtafuhgB4MSsyNPXJ3tiqRukYEubhZgQKBgwrd03M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqVzH23Bo0zZBjc0EACy/UaKEX3cuUHNmNcQbtkPRIFENyrwb7EpBjtRIAQtA2Pwcg8u8dxy80nP5aIImNJXWAEJHMRpEJO49VydMd37n7exJbMZJJmYRycn7jpU7JEfsGkfDZ1YHaMPOOhxslbDQSNlFEHggSGTAiGn7YjxCN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CBluLYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CBluLYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE46C116B1;
	Tue, 16 Jul 2024 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146019;
	bh=W4gtafuhgB4MSsyNPXJ3tiqRukYEubhZgQKBgwrd03M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CBluLYdYW3I5CUQz4izrk7wvVP1wlk/9I+TTO7A0STzsAGIyPYAVWtjIh6l5B4NT
	 0oOhSKWiGy418UhKQoMsYb++NhgCYB8az6eakYoN7gBogMkPZw8F7Iz+eRs4x7Fke0
	 IrNLnRIvQHPQKXgz4hnAADGg7eSQAR/PrWwmwVXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/144] drm/amd/display: Check index msg_id before read or write
Date: Tue, 16 Jul 2024 17:31:18 +0200
Message-ID: <20240716152752.889798310@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



