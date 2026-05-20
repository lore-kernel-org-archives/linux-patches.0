Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59760318EC7;
	Wed, 20 May 2026 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295919; cv=none; b=TCd5ciA/OgEuTxUE6pHj/33VBEWbxPGZUrvIncaxt+4+HVGngCuPtXOtsTH4rZXgklPShHKp++1OkCUz/ocrwhfs9mjryKXjq9jyXgeolqoQtpaf9S5/QhJbYlPui4X7zb4B5oHu4G+BuQzIjrF1dM6hgiR2aMl9+lEJ4gMyyDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295919; c=relaxed/simple;
	bh=FfeUc7z8XBoBn+6EN8naX2hWzZsB8DfZ/YE+8JFzJ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXmP2JiC57gVLOLzBe7Tg+4MMxjxmOoOEnq5ouVFD+AZRdZmZLilx58tPouViSDD7QfOQApwFmKCrTnEYuUOyal3jnjDVCOYAamrsza3jWBhS++rrTAIp5X2pe+ugZ+6FJ2982sLbUdD3q/xuRVeVqvAGbt6YKBOYvodZ4ULO6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfW/lNIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfW/lNIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB161F000E9;
	Wed, 20 May 2026 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295918;
	bh=0K7uFWk5rUk/x3MH0Kkik6AW1XiZFS4hmYjUXNtTKL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfW/lNIag1Y9wq/3zM/sc+lx00RZYtGV1hoUNT/VSrnbddiooC6jC2v5EaGwN0WJ2
	 KtsNA9C01WyADlGgzDiOCKHaUnKql4xWpFq2+QzYHyTIGnMV+Cnuu3f6T3ORoL7xfV
	 pLSFbeUTztw2SwxN1tn8xPL8MYWU7vqEaCItkLEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0600/1146] cxl/pci: Check memdev driver binding status in cxl_reset_done()
Date: Wed, 20 May 2026 18:14:10 +0200
Message-ID: <20260520162201.757244349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit e8069c66d09309579e53567be8ddfa6ccb2f452a ]

cxl_reset_done() accesses the endpoint of the corresponding CXL memdev
without endpoint validity checking. By default, cxlmd->endpoint is
initialized to -ENXIO, if cxl_reset_done() is triggered after the
corresponding CXL memdev probing failed, this results in access to an
invalid endpoint.

CXL subsystem can always check CXL memdev driver binding status to
confirm its endpoint validity. So adding the CXL memdev driver checking
inside cxl_reset_done() to avoid accessing an invalid endpoint.

Fixes: 934edcd436dc ("cxl: Add post-reset warning if reset results in loss of previously committed HDM decoders")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/20260314-fix_access_endpoint_without_drv_check-v2-4-4c09edf2e1db@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index fbb300a018302..a5922116db2a8 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1043,6 +1043,9 @@ static void cxl_reset_done(struct pci_dev *pdev)
 	 * that no longer exists.
 	 */
 	guard(device)(&cxlmd->dev);
+	if (!cxlmd->dev.driver)
+		return;
+
 	if (cxlmd->endpoint &&
 	    cxl_endpoint_decoder_reset_detected(cxlmd->endpoint)) {
 		dev_crit(dev, "SBR happened without memory regions removal.\n");
-- 
2.53.0



