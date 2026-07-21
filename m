Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A762408039;
	Tue, 21 Jul 2026 19:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661949; cv=none; b=pQY4RwL3201Ax6YxKzCyyEkap6aQyPs57WCNZA3LkKfevhDs9DZJ2Q/Fvpbn1zQxDSl7dCDhvG1kq1r9PJlKPn6xAQ1PyO7qnLpXHGKQNrJU2oJJh91PPg1tyglnAdXU6fPh5Xqg2wjljDkNYqEijVMqgQJwjnis7vrbDWp6VTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661949; c=relaxed/simple;
	bh=uJmxzNLfkyGEMxWbf1LnFRSrPcKIXs/MQgEv1GQKn3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWBMI72Yjk+Kj1qfrmbRGTe9yS4JPWk7+LqXlti9gRxmDCptjee9y+2hUOXu1ZuR/B3P+Ju6OYmg2gRuNl5n67yKm2ciwIJ6bi2l50FJOAcLZGJ7B253/K8uEmeHtnKtxwGZBs1o3pgYFeTWDIKjtNU3jqmhmPeWawspwQdWLig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpJTzLdg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpJTzLdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3241F000E9;
	Tue, 21 Jul 2026 19:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661948;
	bh=SP8gLF7rGfAPtVF054gksGYZI4IMdZxTa+JUsjD6aFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpJTzLdgaGuROPk3zSpriZXoryqdEIvilK6uJQLUWf3jgGMWq4RE4cz3x7ipGS81t
	 JJKPCyJ4WO2tj9DCHt1Grny6wLGHGoz28InVUrX0QaA6/QRa6euLcDx+xLQffP5bj8
	 VCAoIrq1OE9rPlt0jl38t0T8221zxlDKADzqp8oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0258/1276] wifi: wcn36xx: fix OOB read from short trigger BA firmware response
Date: Tue, 21 Jul 2026 17:11:41 +0200
Message-ID: <20260721152451.858971144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0cea465edf327d..f7457dcd8980cc 100644
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



