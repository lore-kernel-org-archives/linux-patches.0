Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591373B2D00;
	Tue, 21 Jul 2026 20:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666107; cv=none; b=M4vwUNqgQfQuG2ZMXn5fdTUlZIt3NqaboVRDg+LnWxwOR/HE1zii5vc30VE6FmPxMR+Zeugj61pDKw3mlCB7o1wjj3f3RekCKgTe/AyzwUM184QsrGe153tMqz2ZjWYy9yoN6iXxO+yZaHofTF0NncQtk9v5QyysmuE8DTPL1Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666107; c=relaxed/simple;
	bh=R3iHTZ+hbi4mgWkJnEFcanqqGpkqHQUWHv39/AUtonc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlwGUG8JwzRYTHD5+kDI3wvPYxMFhPFdN9r6Mi9seJ9aL4NdZ9OpIkcCgV8KKe488GMT0CoEP9j3/ja1qXANQr2s5YlngqACUGQWGUVWoBox6SSwCbg16aUrvXyaAdmoSQ5BNUBw0rRGj3Ff5SzpLJva69CahENKX3A7ey8R6FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CZmZOFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CZmZOFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91941F000E9;
	Tue, 21 Jul 2026 20:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666106;
	bh=E9bKdnvWxoAGkQnQwaZeERZEWoPw/3SslGKFPIcT9UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2CZmZOFi+XSUHO2qFMVUMXY3MYWg70hqVRx07DDM2+MPw4NjafBg8rZX+VLGCvcQu
	 /5XkFB6nK8S2wmVbtyDz7X+4Ik3wfkWpajJVmIBMdzK89NKTuLAI2b9GyrGOC8x87e
	 tY6mWe9iWWJqCP4liMBZ5ONYTkhubfA/7JX+DqJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0503/1266] wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
Date: Tue, 21 Jul 2026 17:15:40 +0200
Message-ID: <20260721152453.102277963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 17e1919d1cd828..daab434b19d581 100644
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



