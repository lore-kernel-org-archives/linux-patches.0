Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943C91714A8;
	Thu, 15 Aug 2024 13:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729140; cv=none; b=jUyv4PlntZg7ktewxIBo/bmFj61/2juHtT0SxfV0cO5Pf1fDoYHcubh6nbM8DFyJ1SJv2mFyxBczn9cP/CM9zSi+RLdM39IssLLjbeRCWDNt7V/ofXTwTJAr4z6c0jtcBNT2dQUg8cfKGBYtif0tHuJXvX7T65yiW2Suatn+6jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729140; c=relaxed/simple;
	bh=0d2CgvO6bmuv03cAin/nCFXMcC/6ViuSMu5dgbmMd7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co20Nx5/GuLoDPDeVArjfywcLGClryWfYVJzEQRymci13LHNOwtNvIYLA/PA/cVcQL88ECHass2Ccsj8mLQ7FXpy/dPT6JnSB+kQmsU6G6PYId/Tb981ZY/eu8jRKGDKh3tUSPFJAxEaCj/VZlTvvgYnbsIsPGnKFoqO+fvUO4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGMqu+4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGMqu+4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBC6C32786;
	Thu, 15 Aug 2024 13:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729140;
	bh=0d2CgvO6bmuv03cAin/nCFXMcC/6ViuSMu5dgbmMd7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGMqu+4+Q3IP4+SfFPBtfeRHtFqqXt5kBw/BJ/fPzSo0S5r9uZZ8KZjojTkiPoPjO
	 rLoKFuxlWHcycANnkyHqLLhd7D5Hc3P2PWVx6drNLOi2mAIapL2tNsRthWOWqWXsq0
	 YZvh6OHatVnLzrfSASsBg4Df6PoAlkFP7t7fSLfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmy <huanglin@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.10 06/22] nvme/pci: Add APST quirk for Lenovo N60z laptop
Date: Thu, 15 Aug 2024 15:25:14 +0200
Message-ID: <20240815131831.509167131@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit ab091ec536cb7b271983c0c063b17f62f3591583 upstream.

There is a hardware power-saving problem with the Lenovo N60z
board. When turn it on and leave it for 10 hours, there is a
20% chance that a nvme disk will not wake up until reboot.

Link: https://lore.kernel.org/all/2B5581C46AC6E335+9c7a81f1-05fb-4fd0-9fbb-108757c21628@uniontech.com
Signed-off-by: hmy <huanglin@uniontech.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2933,6 +2933,13 @@ static unsigned long check_vendor_combin
 			return NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND;
 	}
 
+	/*
+	 * NVMe SSD drops off the PCIe bus after system idle
+	 * for 10 hours on a Lenovo N60z board.
+	 */
+	if (dmi_match(DMI_BOARD_NAME, "LXKT-ZXEG-N6"))
+		return NVME_QUIRK_NO_APST;
+
 	return 0;
 }
 


