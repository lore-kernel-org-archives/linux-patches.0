Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CBA1ABEBD;
	Thu, 15 Aug 2024 14:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730891; cv=none; b=kcSsA9jxrFMmDpDkipLHpxd3BYTwZyTco7REr50e+SZwa8qZ2d48Y9nZQ8A2FYSz2sTM4IhdR5NsJcCS2FsAbJIiaWfatmswBVuahfBGNezSIqbUeSnNT8eM4xcUnj+Sf9DuLVBFUzwwOc9YavN2GTDqDsnDdBO9pTHG528kDY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730891; c=relaxed/simple;
	bh=gxhVeNozeR/EsjWzAYamZ9EHjzZtRRlg2+e3xJDyA2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmFMRIbi3i61alpaq4nSbJlFqWhtRbZr5eqFAEM3GwjO2qRGw4B1kzsfwWSiqL7GOCPvYpwzqVgIHa6eEw+i+uQ7bjAgtys9Pu3OjFh/QxvYzy1qHmuNTyXcrsm4+k7j7BqVA0OMTWV0Qpp2ACvuBaL+mSrft+a1JJoDYKCOVqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fojPdn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fojPdn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A64FC32786;
	Thu, 15 Aug 2024 14:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730891;
	bh=gxhVeNozeR/EsjWzAYamZ9EHjzZtRRlg2+e3xJDyA2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fojPdn+JZsyv0P4RTLDr9WOgx0n9a7F5RAtpWlFV9FL5ik/l6X28b4wt5cWXYn3i
	 H/D/HfEQzWuuOhdk5ybXmFVvPYb3tuN4aySaPoTnBd/bzzaBmyHurjK8zwHhI/YGOA
	 zBc9V2487ASsWGO7mOrcqyHNDIGGsMnB8kAJuMtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmy <huanglin@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 18/67] nvme/pci: Add APST quirk for Lenovo N60z laptop
Date: Thu, 15 Aug 2024 15:25:32 +0200
Message-ID: <20240815131839.034985081@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2931,6 +2931,13 @@ static unsigned long check_vendor_combin
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
 


