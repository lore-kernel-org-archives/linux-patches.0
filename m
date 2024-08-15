Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9BF1993B9;
	Thu, 15 Aug 2024 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732996; cv=none; b=tBEY6p329uF2KYVYy+15KIMb5hSRkFm3lKjisqHD/QKws8nb41H+cg9G1EvhaTz7igEO2jNdMS35+/sAHLRVJHtyr5DJP5wOKqNSELiE1TQWX7Y3/p4JaEpYcVcGqRL6z2kV/ITZzcGGnMtBTxZjciNZ9QxwXdOulXtKbDKNo4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732996; c=relaxed/simple;
	bh=5K5wUJPAQsGduWQAV/DoJGO6fz9DpEIi21tPQBJTqWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amYQcVra4ihH2foV+oV1BorFDmjhO6c+4iJuFmDlbhWsXyjpLVVQtJBtk+JIhfhxn8qyKKpyxETCQCjxxJia4F31RYjKoNToOY+7XRtgkmO/2L6GnT4bnJ0OvaDTIp0KTPdwx9ZOgBxBCC+vR5DEKyFiUIU6t+5tk9dwQlY42js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAB1VQUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAB1VQUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759E8C32786;
	Thu, 15 Aug 2024 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732995;
	bh=5K5wUJPAQsGduWQAV/DoJGO6fz9DpEIi21tPQBJTqWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAB1VQUZPNlFoRsXZQH0uyfAyB49nijPlbbh8Wyv3AmV2aRd16piD/PsC87jt7o1q
	 dblXCIj3SHaIR8J1Ey/0OwaWR5hvK9MB/LHgfHExNVmZxI2ijoYQ7hqQH920FMh3nK
	 vOGkx/gxHdsxLyV7b8v2MuYibCe5MovIk4YAvO5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmy <huanglin@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.10 348/352] nvme/pci: Add APST quirk for Lenovo N60z laptop
Date: Thu, 15 Aug 2024 15:26:54 +0200
Message-ID: <20240815131932.920439169@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2846,6 +2846,13 @@ static unsigned long check_vendor_combin
 			return NVME_QUIRK_SIMPLE_SUSPEND;
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
 


