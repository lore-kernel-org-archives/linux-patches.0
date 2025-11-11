Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C309333443;
	Tue, 11 Nov 2025 01:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824547; cv=none; b=PihO8xiG+ftbyP8JwO/39rY5BfpatMEyzA/RUP7zY/L/avS3B0eUP3TsvX44gqCYH1+87UCSuZpByuzQboZShopJ8udVCeBTCE8Kfkj82jmj8UOXATHkLv4zHvnIh8uOPNniKcKNtixkhAf1JNk3MU+zLzVzzOHVpth1ZtIKMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824547; c=relaxed/simple;
	bh=AaSuHM5R4dv9yVkktqDVzXn9ievVjelhU2oV8Op6x3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmFxDsNyn68OtEEhbrFVSWGoDja3e/ys4/4rDFOlodVHw2+Zne+2+gmS98I0pFJOcViLoUUX/MMBIRtZv+yv/MAuqXuHcbdna+FfJN7WG1/yrbi/lgcYLZq83Sc6TT/a0+KN0yVbIMV6aMzfYToaYztCqCULd56pEgSDA1XK/+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVYnSy0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVYnSy0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F9EC2BC86;
	Tue, 11 Nov 2025 01:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824547;
	bh=AaSuHM5R4dv9yVkktqDVzXn9ievVjelhU2oV8Op6x3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVYnSy0TRbZ0m08h6sKp8ijFiLNMuSrIT8VUCJgeyxizlqXZAkghNqQ4HI/e7rM0T
	 y+HjIXrAGwabZr6tLW+SrIksV+59+GHegtHPw/mOE4cqYSal4u8FF2xuFY/TA4dUVq
	 4Y0uQZbMIE3WT2uepFgAozOsYxCpeaB7UkQ+r3jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vernon Yang <yanglincheng@kylinos.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 521/849] PCI/AER: Fix NULL pointer access by aer_info
Date: Tue, 11 Nov 2025 09:41:31 +0900
Message-ID: <20251111004549.019934434@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vernon Yang <yanglincheng@kylinos.cn>

[ Upstream commit 0a27bdb14b028fed30a10cec2f945c38cb5ca4fa ]

The kzalloc(GFP_KERNEL) may return NULL, so all accesses to aer_info->xxx
will result in kernel panic. Fix it.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250904182527.67371-1-vernon2gm@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 9d23294ceb2f6..3dba9c0c6ae11 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -383,6 +383,10 @@ void pci_aer_init(struct pci_dev *dev)
 		return;
 
 	dev->aer_info = kzalloc(sizeof(*dev->aer_info), GFP_KERNEL);
+	if (!dev->aer_info) {
+		dev->aer_cap = 0;
+		return;
+	}
 
 	ratelimit_state_init(&dev->aer_info->correctable_ratelimit,
 			     DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
-- 
2.51.0



