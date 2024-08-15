Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F223F19F49A;
	Thu, 15 Aug 2024 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729053; cv=none; b=RDOZkqRdAc0Tcid24kjOCV9HmIbAPMCVoNBb1pQ9ylf9R+arAudvV0COs4XzpGcsC/i9vwfbkh/dPJJ9NV0Je/qE8oQHjzVPutLUz13Z4qTGntXgUm9TbgS+X3791fE7f2pMBWUwlccBNTpTSVeIJPBOIF0oxxfUSwQquVUyHRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729053; c=relaxed/simple;
	bh=KH9fAm4Vt9PLWX2GnmabCQKDeQpSmTxYnNhepj5rdXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EK7svbXeqlK3Lkikr8NRw1TeV3rr5s/wsKUr2izQ97LGgTYZ9+GhTN+/QZWq8ZkuXfHVhZLLK9/58kj1kQh98O6lDKSvTgF44G7zcOOn4Y2u/lp9gV2ECVvMp8aosZ4bPqyPQUXL8dWnJNmCuBg1uSDbLbrv9+TJQ3gjJ1k51sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmleZOyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmleZOyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DA1C32786;
	Thu, 15 Aug 2024 13:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729052;
	bh=KH9fAm4Vt9PLWX2GnmabCQKDeQpSmTxYnNhepj5rdXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmleZOyL0kkS7Lre7M6uKmDLp7CDmLAgZaymBSwQtbO2vaf1rDDsQiWhuD+kCzCbW
	 2N1Sjzh7pzAJ8jBygV/PtULtxDk3OeO/fLEcU7Ax0QrEUUEgKdYftvNtKgm6Fx9qSF
	 m/vtCiguMLRVfdUSFucRbNoHfp9CO90iP2AuZfZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmy <huanglin@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 4.19 196/196] nvme/pci: Add APST quirk for Lenovo N60z laptop
Date: Thu, 15 Aug 2024 15:25:13 +0200
Message-ID: <20240815131859.571861730@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2481,6 +2481,13 @@ static unsigned long check_vendor_combin
 			return NVME_QUIRK_NO_APST;
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
 


