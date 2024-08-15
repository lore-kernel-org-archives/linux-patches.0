Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429D81BC067;
	Thu, 15 Aug 2024 14:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730778; cv=none; b=nnUVbjO0/kQmXbgI925MRMzOb+HjmNuYZ/bzIrbYYJry0MHX+tjkxNQcNoi/E8Ra91PXyDppTy5I5jAykPdV2LlsmRsy6XgjfUliTYbhbtIg2s7UQX0hePMIQ0kkgNe/RhhhcXmJHqYO3KtkBsGARbCvNLW3JNgisFrvGuNKPm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730778; c=relaxed/simple;
	bh=mU2Ommb+vtnjDdOjtMujex3BEb0n7WXmaq6Vy7sR5wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JT4DcaHSPIuJALOUo9EKBn9fay3MVrjcSQVbyaZ0X6x59/iIKpS38I3t6fx7DAykhqsOMhn/Erh7v6cmIw4HNydgSIPCs5DZhlhc7WlyFzEkuDULfhwMFDXSX5oGkIZKM7It3c76bDNz0OsDHzvCfJjv4/3uqvLq35mUEJAN8Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gykr7V93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gykr7V93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B044DC32786;
	Thu, 15 Aug 2024 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730778;
	bh=mU2Ommb+vtnjDdOjtMujex3BEb0n7WXmaq6Vy7sR5wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gykr7V93L0bILLTt+AV04l/mU+fz8+i74yNQDllkEJCzGF29nqdhbJL37gpLpSiGG
	 MYkvJKU4csmXclzMyT4n4v2wpCmQyPthMv8FPJiuNHfB3UHlXU6NrYu+jnUXpGhstQ
	 tp1LZcRQCI4SM/D4mL+SIpi2iMDoaPEbMjn77PQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmy <huanglin@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 28/38] nvme/pci: Add APST quirk for Lenovo N60z laptop
Date: Thu, 15 Aug 2024 15:26:02 +0200
Message-ID: <20240815131834.040603743@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3109,6 +3109,13 @@ static unsigned long check_vendor_combin
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
 


