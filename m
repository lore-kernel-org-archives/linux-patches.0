Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D589746D081;
	Tue, 21 Jul 2026 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656382; cv=none; b=kJuT9U7QgOL0nHs0OofbkqbAsOl9hW4kkPnET6cNR7c6xkvbKJcTjdJwQ1Ce+BQSvyXGsZIvWEbKYdLfY1jv/ZZuDzWY6tfWdjVuStp3pHkLNc3cksQeCQ0V/atrAeVm3aHV92TIEW38ghrb3L0tEj9FvJt6L2B81vkXey//Ki0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656382; c=relaxed/simple;
	bh=kCE5A7jFa3sn+gTP/RAAqJ7R84sEMz9FYFZA/oAT2lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PS7WlLWQoaxlMVQQqy2Zu8JYNOI2MRR3tHDHVt5IcPk5e1tPfFN7v6csJj5YGuHoVEoJ0Q/Nu1PAoqJaYLZpSpEGqp5FW9V8bH3e3GgbnOw8xBn4B53HOW9GBpIVspoWpCpOINaiRPQPoMxCqD1C/wX2k9//bfdbh38tFvrf9KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsFrFc7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsFrFc7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460AF1F01563;
	Tue, 21 Jul 2026 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656381;
	bh=uc/Jelo7ADdcKTsOGH2zzyISqoFnKlq5XLggx5Z8STg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsFrFc7lKiRLlOe+RoBR/OVktsH3IZfDobHVbf4SsP6EGA0HW6lQEPYy8NWd4pFno
	 psdCgUrbL+lFRygZ0IRBkmq+fO+TZ7k6NDMcgDP0yewPIRlurGI3c0s/27wnaap1md
	 QFRxhggLz0HpDMxTaSJL2tzX8KqThWuMIu6BA7cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0365/1611] wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
Date: Tue, 21 Jul 2026 17:08:01 +0200
Message-ID: <20260721152523.370060404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2cf86fc3f8fe0c..f550eb86301322 100644
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



