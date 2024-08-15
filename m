Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182551AED25;
	Thu, 15 Aug 2024 14:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730668; cv=none; b=MEiE4KKfjUZ+Q/BR5l+tn3pK6KjZnJzkYXf545w6EO/waNUccqf56BDdlcGfqkLpCVyj2Nurz1oUBRtVBj8vfEmcO46g4d8BlVWHbmIWCkUb9EZw9d0UAWYepGF0sMjFcOjoJE4/hfoUBPb7NZCjc2NDka1DqVtD9zqhddOiUhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730668; c=relaxed/simple;
	bh=7R+K/wTD6GeFEEKC3Wvye7kS5fPluJegHfLVMG8dOSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqT2PB5ZyvXrN7BmS3iW1JSJqUEs+X9NLARffIXyNeSYSxHJP0teyDyTsWtiDd7SMc/rfJXppTzkkDpjKUvqif8H2oSjwz4gUHSSfZWXfV1NvWYMCDLcvsxoSsq8JPLadcIy2F8S2ZgjtqMHn9B/PkpkWUscyk3lzgPxL9utKKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mc369fgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mc369fgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309CCC32786;
	Thu, 15 Aug 2024 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730667;
	bh=7R+K/wTD6GeFEEKC3Wvye7kS5fPluJegHfLVMG8dOSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mc369fgsSx4s5dG4aLKSCCBqI717M8lc+Ziem9efbkJbBOr9Gqo6Z1rlYAc6m2Xa9
	 KIKiFFlOjMdpYm/Y3f2mWEAHX7FBnljqm5Dx3xS/Lpe9PFt438yFAypdKumm9zT5t0
	 TOP6EMERmcsPnol7ZqzWLg19QdAvSOSAvCVlFGdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmy <huanglin@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 480/484] nvme/pci: Add APST quirk for Lenovo N60z laptop
Date: Thu, 15 Aug 2024 15:25:38 +0200
Message-ID: <20240815132000.026107661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2976,6 +2976,13 @@ static unsigned long check_vendor_combin
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
 


