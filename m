Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD1679C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A95C433EF;
	Thu, 12 Jan 2023 14:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533499;
	bh=6ZEgEXyYUVLecMuvcZGIG1V8k0b2NNWQGiHke+cOego=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FndR3Omq1H0Y7+96GjbOVHKYrXU7ERGX/RJjog/HOx4ssp4MLo/SkKcwUW5dYGdvB
	 5LJoUL+ypCj1NMuJFhJIF0DkoLTVfBg8U7xLrCkMrAiYDQU15dHcyV0tEbbHVFqzKm
	 WQdT6HP2Jp8bo33adFMikY4mIhveGFHFzOBq5ulg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wright Feng <wright.feng@cypress.com>,
	Chi-hsien Lin <chi-hsien.lin@cypress.com>,
	Ian Lin <ian.lin@infineon.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 497/783] brcmfmac: return error when getting invalid max_flowrings from dongle
Date: Thu, 12 Jan 2023 14:53:33 +0100
Message-Id: <20230112135547.239185905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wright Feng <wright.feng@cypress.com>

[ Upstream commit 2aca4f3734bd717e04943ddf340d49ab62299a00 ]

When firmware hit trap at initialization, host will read abnormal
max_flowrings number from dongle, and it will cause kernel panic when
doing iowrite to initialize dongle ring.
To detect this error at early stage, we directly return error when getting
invalid max_flowrings(>256).

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ian Lin <ian.lin@infineon.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220929031001.9962-3-ian.lin@infineon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 4e9d2b3659f0..6a5621f17bf5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1109,6 +1109,10 @@ static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 				BRCMF_NROF_H2D_COMMON_MSGRINGS;
 		max_completionrings = BRCMF_NROF_D2H_COMMON_MSGRINGS;
 	}
+	if (max_flowrings > 256) {
+		brcmf_err(bus, "invalid max_flowrings(%d)\n", max_flowrings);
+		return -EIO;
+	}
 
 	if (devinfo->dma_idx_sz != 0) {
 		bufsz = (max_submissionrings + max_completionrings) *
-- 
2.35.1



