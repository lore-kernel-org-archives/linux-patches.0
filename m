Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3A846D094;
	Tue, 21 Jul 2026 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656391; cv=none; b=X8hYp84qaYC03kt4UV9vTdzRK4ycoQw8KIPRi8boV3T7ImNy7GO2b3DYvauYCPRevHv7bFmXpq5vZZarkjIh+nJtIVLKVpQH1a5b9zsPzqaiJ211eAm1NqeMWgCfKFyD9yXDXKriiTXyqUjDpfilnRjP7ycqTWirIPNyATvsb3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656391; c=relaxed/simple;
	bh=ZPfjt7Jf1Li1u6xIT0xaPf5r88KpWJ6mBfmpBm94ecA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXLH75HfFxuoUpapjdRcQogl01iMArTNTLCph9+pJh2ttc0Bp215abDrJCNCSs2S/m87vqx8UgGtdg3kv4y94lUUFJ7mBT93eesbFSiHSTNDlAMHGdECg3slw3UCq+87bmZEycMNFndmKvkVqSu77EFlHijTxHN9X4AkzEUxMvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxVibaTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxVibaTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB401F00AC4;
	Tue, 21 Jul 2026 17:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656389;
	bh=Qs3WFRqo5nEcm9zBoPY469wd4wMOyLAsS3iSYEjqUUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxVibaTg43CbmapOyLSC82nd6ZK0tdKxPy3RzprydjKpkIPZv8JKzsD7P2lnDdOd9
	 VYlzttIw+SKOABw6+Zor1SXJA+ehe6WPb5jxpD/S4ymF5eLqhCJFuoVTS3/5z/xAM2
	 /aIBYYDPHxe9upwpehcJOGS35iGbu/RE9hapsteg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0367/1611] wifi: wcn36xx: fix OOB read from short trigger BA firmware response
Date: Tue, 21 Jul 2026 17:08:03 +0200
Message-ID: <20260721152523.421341895@linuxfoundation.org>
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



