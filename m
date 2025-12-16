Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7DC341069;
	Tue, 16 Dec 2025 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884235; cv=none; b=cDHq1RFDAtq+dpYz/uSRS66oFChZsjCOYnVGbWHEnS0xvw3xjzSP7YhoGELT/N0O6U2TsZ4eJrDyTC0NOeEe47AN54ra15wjBXCm4JjGQG1bEH1fR4Ty2Njrxp2Z2bMS0KCpP+T4Yt3bCrkme+yewij0TYb1EMkEG0huAGCfaeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884235; c=relaxed/simple;
	bh=kIo3EAJLJM0Td7jtmkMKnO9KNtzMsHk33nywyaVkV3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dt2oeDZdHHP4CP0R1dHzWNa4b81RYrhd38sdgTa6MTLnW8AJ5PSoxEN9eEZ51XUulPvO1iYYNTrV/IIoeF7C73HcM/6WnF2pGeE5MV8FWP3hNpFcbXJJ/+/7b9RPHzivavHuzzGSIEBvGo9y9wzNuKk1yQPgFiDQflu9jK9NfpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ygqw5f3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ygqw5f3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C088C4CEF1;
	Tue, 16 Dec 2025 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884235;
	bh=kIo3EAJLJM0Td7jtmkMKnO9KNtzMsHk33nywyaVkV3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ygqw5f3kvn8qe186mkDol4r6RiN3S0fCKWxkCs/gezyaBvSgTs1pCWMOM2IeWetT7
	 uTwcl+H/6Y2hHDpw1CaYN39gus4iA3CJ50nK6Cd2Sl5luzqBZvQZOTI0wbspv1wQj8
	 ss97b5/98GzxR/lWBOsB9hI9cNb03O7DccMW+obM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/354] scsi: stex: Fix reboot_notifier leak in probe error path
Date: Tue, 16 Dec 2025 12:11:38 +0100
Message-ID: <20251216111325.668338426@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 20da637eb545b04753e20c675cfe97b04c7b600b ]

In stex_probe(), register_reboot_notifier() is called at the beginning,
but if any subsequent initialization step fails, the function returns
without unregistering the notifier, resulting in a resource leak.

Add unregister_reboot_notifier() in the out_disable error path to ensure
proper cleanup on all failure paths.

Fixes: 61b745fa63db ("scsi: stex: Add S6 support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251104094847.270-1-vulab@iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/stex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 0e81125df8c72..7af0341a99d2e 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1844,6 +1844,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 out_scsi_host_put:
 	scsi_host_put(host);
 out_disable:
+	unregister_reboot_notifier(&stex_notifier);
 	pci_disable_device(pdev);
 
 	return err;
-- 
2.51.0



