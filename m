Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EAF26B755;
	Tue, 11 Nov 2025 01:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825047; cv=none; b=P4hYWZ7YV8nfo/IAwkYH2Z1fhN4uUsrwIFCPq613GW8MLp4bMl+td8iiS3vHD8Vwqkj4pQ4bMJ35isdUSfe6CpF0mRfTKeHd3svknvDg/Y6+S1nXheEd9wpNhnbZzoOavtH9XbUvC3HEc0xGhSrDSSQVxPpUY3IF16BCcwLLd1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825047; c=relaxed/simple;
	bh=0+kNRjd0ExmTQdstCggnKcxEdsMxlPitSQxU+wyF3PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftkJRIQQmpEv8MMdcfHLj63tHs7p5FtIBedewdsnckSAHiQqZtf8kA29yVXikgP1YcMmtxsPZjyGY199djnwPNI8z8b7bqOHC/RXGBljtUwNyFlfMbUSXM1m3b5vzfmmHe5aoIvf946F7rs2IdSKsyklIFKO2t15fl82xv2OGxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vkrrw4V4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vkrrw4V4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7CBC4CEF5;
	Tue, 11 Nov 2025 01:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825047;
	bh=0+kNRjd0ExmTQdstCggnKcxEdsMxlPitSQxU+wyF3PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vkrrw4V4qeP8bCfoIDcFGfq8uO4+hq4mVawTeoKKUEBin3XHWWfgoAFyuIuHc+GS4
	 7ldRXkfMRpfICL5yQ0mD/pKhHCheTiLeqkZL4kwPJnrrCAt0NpqeN7zQn5aFbrFD0H
	 fF7UEIy4pnAdRDizBe8f5AnG6wW3MOF/IRQWHYrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Sinyuk <konstantin.sinyuk@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 638/849] accel/habanalabs/gaudi2: read preboot status after recovering from dirty state
Date: Tue, 11 Nov 2025 09:43:28 +0900
Message-ID: <20251111004551.851781626@linuxfoundation.org>
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

From: Konstantin Sinyuk <konstantin.sinyuk@intel.com>

[ Upstream commit a0d866bab184161ba155b352650083bf6695e50e ]

Dirty state can occur when the host VM undergoes a reset while the
device does not. In such a case, the driver must reset the device before
it can be used again. As part of this reset, the device capabilities
are zeroed. Therefore, the driver must read the Preboot status again to
learn the Preboot state, capabilities, and security configuration.

Signed-off-by: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/gaudi2/gaudi2.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2.c b/drivers/accel/habanalabs/gaudi2/gaudi2.c
index 5722e4128d3ce..3df72a5d024a6 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2.c
@@ -3150,7 +3150,6 @@ static int gaudi2_early_init(struct hl_device *hdev)
 	rc = hl_fw_read_preboot_status(hdev);
 	if (rc) {
 		if (hdev->reset_on_preboot_fail)
-			/* we are already on failure flow, so don't check if hw_fini fails. */
 			hdev->asic_funcs->hw_fini(hdev, true, false);
 		goto pci_fini;
 	}
@@ -3162,6 +3161,13 @@ static int gaudi2_early_init(struct hl_device *hdev)
 			dev_err(hdev->dev, "failed to reset HW in dirty state (%d)\n", rc);
 			goto pci_fini;
 		}
+
+		rc = hl_fw_read_preboot_status(hdev);
+		if (rc) {
+			if (hdev->reset_on_preboot_fail)
+				hdev->asic_funcs->hw_fini(hdev, true, false);
+			goto pci_fini;
+		}
 	}
 
 	return 0;
-- 
2.51.0



