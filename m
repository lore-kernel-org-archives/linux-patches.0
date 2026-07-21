Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E22737EFF4;
	Tue, 21 Jul 2026 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649285; cv=none; b=LHnVER4Yeeu4xO2Het/XSgKE50Id3HMDAOMieDDNEzriY14StlN2qS4O/g+ZL5N4GfRaVTV6INVWK/YJUL3EoeGpocrH8JmzEn1CkZLkDR0Jnkl2e8uMGEIef1T1ydDLY/z+mDwzIn89Y4hlV+kWWyniFfC/wWVoWZsOTZ9wQs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649285; c=relaxed/simple;
	bh=3RgsIg1q6b/2jHuZ3XHen+Hl/6xWJEX32GiQv5skVV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyqwoOuMNQo0aI+OoJrFGeTlRYShhjRGorv3zs5+bKSjy2qAIKsGjuGP0wEou+3JU6WzRneLdmUNhJMqWekk1EEHGiY1OcJ+PCl4pTOCsOV0H8s3gVk1ZQKUeEJC7GQhn4iOpYvBcwRXG5EqfTUBS+nd9oiwGabFGLtVfge5kSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWj3PnwO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWj3PnwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B1D1F000E9;
	Tue, 21 Jul 2026 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649284;
	bh=VrTtdt6KoKOeAI6jQ4JvDneRJ5fdBZVguW1xqKI71o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWj3PnwOHxPLHcTrGAknzyrzNDN12q1m+OZERURN3X0gV9j/hRMree5Sj4TXGD5gY
	 MWZkjbkcRq/b9qxPdIcANCVbsK/3y+nttq/Ez+MuoifZdzW1wJot906DXerjfTEqJY
	 ooG2qCkFJNya82rLwWZN1vRzfvPoXx64Jj7/ofFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0520/2077] wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
Date: Tue, 21 Jul 2026 17:03:13 +0200
Message-ID: <20260721152605.076295812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 813553edcb7899..f65328329f4f08 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3293,6 +3293,10 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
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



