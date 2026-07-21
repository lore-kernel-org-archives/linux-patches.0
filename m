Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFE844AB61;
	Tue, 21 Jul 2026 21:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668996; cv=none; b=fObL21dXJM9FHRenhUMajo9EutlN6+79C72cZBrbobKnOJn5yFNjUp9h3+o1tdH6aSwU+Z7/SMR9NmhFKn04UAiHwbakMB2FyRtIDLJge8urfO++Fq4X+tMQGgGnipTnLffLIPOuhDk2rKMwDYFGyNe7q92fj9U8onhNKsjUwy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668996; c=relaxed/simple;
	bh=+wKrdDJHvtCpJ+wPjeMPEpcmq7vrNrop6EExuHCJeK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WV99Hh1Z7XN8XzKcy5Rq6SQ9AzTW3kLKs8QKHGTIdhQz/aB1ah7pvdh1CYXA96+JdTYROx9mHlSGst5XbRLYflnV0lCmStY2ZXCli0W4rFYfKmI5mH2Vq/lgOI8CMCbAqpJaBhEWh0kn5DBSfxvsSkcR0o5bLAHhoHQCyIi2dGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcwxDQ+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcwxDQ+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2091F000E9;
	Tue, 21 Jul 2026 21:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668994;
	bh=57AU5A635VHZx4lVGZOOIKrFck7uPezVsWgpSbJfg84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcwxDQ+iBCkNKf+9F6JIWMY4Jg0QFMd9SS1wfTaUkwMNzYy2VhPMCB7duA+nbxWTo
	 WVZnrZGkqAxnRc0WV7e4xqNKaqXwopMTB1ucfnb6sh26LjYU+8KXhyY0ZzoaVhv9Qt
	 ji/wXcjQwfc+WV7NWhR6iMypo70xiSdjwTndNm6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0388/1067] wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
Date: Tue, 21 Jul 2026 17:16:29 +0200
Message-ID: <20260721152433.308450537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 88a240d86d3d64521f9194abe185ac71cc74d0bd ]

The firmware response dispatcher copies all synchronous HAL responses
into the 4096-byte hal_buf without validating the response length. A
response exceeding WCN36XX_HAL_BUF_SIZE causes a heap buffer overflow
with firmware-controlled content.

Add a bounds check on the response length.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260421135018.352774-2-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 566f0b9c15841e..bd51abef3a5be7 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3353,6 +3353,10 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	case WCN36XX_HAL_EXIT_IMPS_RSP:
 	case WCN36XX_HAL_UPDATE_CHANNEL_LIST_RSP:
 	case WCN36XX_HAL_ADD_BCN_FILTER_RSP:
+		if (len > WCN36XX_HAL_BUF_SIZE) {
+			wcn36xx_warn("HAL response too large: %d\n", len);
+			break;
+		}
 		memcpy(wcn->hal_buf, buf, len);
 		wcn->hal_rsp_len = len;
 		complete(&wcn->hal_rsp_compl);
-- 
2.53.0



