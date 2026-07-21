Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1D3397E80;
	Tue, 21 Jul 2026 20:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666014; cv=none; b=mRk/3hIyZW1I4kVfE/t58E8jaoCECsZ25wJbUR8ra6fqeV004g4041CAH0vgInIeAWvWtsi3PPPmb+M+iHYMHna38002MIEaHHhKm6Ch4VqAA3nx/w/sLFL6wmdiRthXmLGSuWeYP0vqcqsfWg/ePC9h02/H5w6GDB7cPRA9/30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666014; c=relaxed/simple;
	bh=ne1vmOJ9R6ZUBJWbFquCOylkhpAPCBmTCzX5at6NyU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFl4tHbvCdNKLQc+u91nIkO1jG+Y4fFqUjHFpUSyJSu1tHugaXK/+/OIeobx3SJtyPCnLq00fwxg0xUCbwbdDBwIMi/l2XQVN/4GuokMGKz7z/MbqbCdwToIRAiUMF9q9kGAnLbNVN4EgZu1wIoi3+lTx8aql2v5N/Ts1mNGf88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+rscWn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+rscWn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1E11F000E9;
	Tue, 21 Jul 2026 20:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666013;
	bh=mcPWymH15ggMtI2tOVcwsu3jregyw17A9Vp2XoI1Y/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+rscWn3OdvqzidPM+/BRm3nZsBRHsJAWfTOLmL/BpUOMngB0VpyWAdtuaTL3aoRZ
	 2HCWDxaXtkGUteTZkcA18wD5cpOSzkGQODfCLgKEVr0N/FCUaIKiW/7k1tejjApkEM
	 CaOmoN4ntmnVyIY82ETF5H7At21Woi3BIhGB0KTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0505/1266] wifi: wcn36xx: fix OOB read from short trigger BA firmware response
Date: Tue, 21 Jul 2026 17:15:42 +0200
Message-ID: <20260721152453.149345392@linuxfoundation.org>
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
index 32a0e41c41ca9a..57de3747cbcffa 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2659,6 +2659,9 @@ static int wcn36xx_smd_trigger_ba_rsp(void *buf, int len, struct add_ba_info *ba
 	if (rsp->candidate_cnt < 1)
 		return rsp->status ? rsp->status : -EINVAL;
 
+	if (len < sizeof(*rsp) + sizeof(*candidate))
+		return -EINVAL;
+
 	candidate = (struct wcn36xx_hal_trigger_ba_rsp_candidate *)(buf + sizeof(*rsp));
 
 	for (i = 0; i < STACFG_MAX_TC; i++) {
-- 
2.53.0



