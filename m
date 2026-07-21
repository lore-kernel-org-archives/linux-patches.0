Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03E046C4A5;
	Tue, 21 Jul 2026 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649291; cv=none; b=oCQHCqQPS2FS5r0L6fVSQLAH/6gOf+4iIBnMSIICbl9xWQLwm7MG3zW86URVmcr9U0+p3uSVLGF8BavSBKfXeE7jpeR7lPwtR160zeSEWt1+xifAp57y3iWwROIrgseyh2nRmEsFvFG0wRsUdZx9VlmT9OSajZ1M7l2C0eerJmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649291; c=relaxed/simple;
	bh=g66krw74u3V4X0aop0nioTBuUvs1xdBZtg2KfCfZfPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjOKLk08uaSSC8Yf4HkM/bbgY4DuDFGq394UEmHv6Twwdb/36wSpW73qFDndPXs/cd0HO0LDY9qAHCdg/onSdrShfEzeduX/GTCptxDProOtA+GaN5vIUHV0KOwA+ZCyyxTdPVQYa6hOrlKTyPC/NUoBwYyBc122+qptOtxjZ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qte48Dty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qte48Dty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE131F000E9;
	Tue, 21 Jul 2026 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649289;
	bh=jpIO9oMqsc8szteRCcYJ4LRjR7qq5f6ErEvNc2Mi/Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qte48DtyjBIWeojjuVOsYc4TFHSy17Wy3brNqd6zip7GJL3bjYpTlKM0y2U7t8cdz
	 Y3UUqc/YunkhV4BxqXwM+Yhfncy5GjFBUVk3PfB++BPYJmMJR1WMxXhy1XU4KAe0M8
	 /qdIZ8Q9g2egKJq2FqPGTnQyro83N8u0mdP/appw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0522/2077] wifi: wcn36xx: fix OOB read from short trigger BA firmware response
Date: Tue, 21 Jul 2026 17:03:15 +0200
Message-ID: <20260721152605.121810503@linuxfoundation.org>
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

[ Upstream commit b5e6f21923ca89d90256e7346301056f6502691e ]

The firmware response length is only checked against sizeof(*rsp) (20
bytes), but when candidate_cnt >= 1, a 22-byte candidate struct is read
at buf + 20 without verifying the response contains it. This causes an
out-of-bounds read of stale heap data, corrupting the BA session state.

Add validation that the response includes the candidate data.

Fixes: 16be1ac55944 ("wcn36xx: Parse trigger_ba response properly")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260421135018.352774-4-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 2a0c946d810950..c0b477345832b8 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2599,6 +2599,9 @@ static int wcn36xx_smd_trigger_ba_rsp(void *buf, int len, struct add_ba_info *ba
 	if (rsp->candidate_cnt < 1)
 		return rsp->status ? rsp->status : -EINVAL;
 
+	if (len < sizeof(*rsp) + sizeof(*candidate))
+		return -EINVAL;
+
 	candidate = (struct wcn36xx_hal_trigger_ba_rsp_candidate *)(buf + sizeof(*rsp));
 
 	for (i = 0; i < STACFG_MAX_TC; i++) {
-- 
2.53.0



