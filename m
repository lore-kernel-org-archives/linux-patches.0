Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374AC44AB61;
	Tue, 21 Jul 2026 21:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669001; cv=none; b=P43jGlkXi/kctn6io4/0K9QKOEAoTZPTAcz1EjKSudvUcNhtW3+ae0AY1hs5UnsAzViBw/sX9733LXeXbJ1wwKCojaYpY0o9c5qMVjK0nsbmn5CG8FcyLuHOQ0oXhfs1RltEk98pn8oDm6gk0sX7IUUDlseCF35tEz5cPBYn0qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669001; c=relaxed/simple;
	bh=g8Lq7fmxedPt0UO5IIqM1cnlZtHdh/W30YbFUMZ9+JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lX3gWwQYNtvQc3ccfL0P8UCJXBuh/jBBvyK9WgPP6kndScvCpL1Bk1SbZy8d/dRwJjSWoCYagYJlvEK51KNrE0EEp6xDIOyzcTCCHOwUgpAkH+xzh0fvjZtNcrWvoew4DSDwhh4L41zyCjNjqXNpPkoSVKLeprZfCU3JS4YqSDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRcmGm5E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRcmGm5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3751F00A3A;
	Tue, 21 Jul 2026 21:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669000;
	bh=93oZ34r+7Q1wBBM4uF2qpNXWc0nkzWv3el8L9EizaR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRcmGm5EtDVRP5pltRjPsgp8hD8joRbS9D6IIDxNazWaRwIl4qFv4KcspapYwNref
	 V0FssteACX5KjefD7pOOf9atLpR4WPMQpVoqtsGaqhWKRMCedutOkI76vqCMrjPYzR
	 rWqKNuHYx0BC5Aa1/gfkn0T6vLkcv1Br2qVbvae8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0390/1067] wifi: wcn36xx: fix OOB read from short trigger BA firmware response
Date: Tue, 21 Jul 2026 17:16:31 +0200
Message-ID: <20260721152433.357852709@linuxfoundation.org>
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
index ad329252a7ceb8..79f0ed675a838b 100644
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



