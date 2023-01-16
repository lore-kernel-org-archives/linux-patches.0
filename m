Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E1B46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8393CC433D2;
	Mon, 16 Jan 2023 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886345;
	bh=b52JihtzJHFSqIQQvyHNO6KZaqTEOKizc3NuPBO1sUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lav/HR5FcCOg4xe0GR0g6ftgg4rFxQ0DWMpGtUVq9iwtXOVDv9h4QVFeMjQC8JkPB
	 t7DC/kBKV9U6xCpPA32J+8JDaf4ks8G3dOR01mBJ3eiVSVPUlIm6ephRmQH8zAjKyE
	 xyABdRgWTfNiPjdqdlUkJDKdA1kFBZUFW6kAb5XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wright Feng <wright.feng@cypress.com>,
	Chi-hsien Lin <chi-hsien.lin@cypress.com>,
	Ian Lin <ian.lin@infineon.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 396/658] brcmfmac: return error when getting invalid max_flowrings from dongle
Date: Mon, 16 Jan 2023 16:48:04 +0100
Message-Id: <20230116154927.694608423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index c3ea31ca857a..092501eee9aa 100644
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



