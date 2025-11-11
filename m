Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D582DCF6E;
	Tue, 11 Nov 2025 01:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824342; cv=none; b=ciXYIMgTFhMqhJGEu6PjWq0Ai6LVk4VaLp5J5uGjyRA9L8LWwYwqFn0ZIzwkYgWFCI3AhujggOTa2xuHlulvx/1sso3QzS1JerzgarJLRZbKuYfNK1DFbcuOB3wV3K3Th++HU6IZJOLVAvq0ONIov04iCQh8oRArEpDo8TGhVgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824342; c=relaxed/simple;
	bh=ZEgVsRLcSVPWxPG9sqWRQz4iwboqVNgWPCesFwrTlX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6YHemU1fI7x4SEEAnCRGc2KY0K8lHjRG3w1etvNjPTqshx8j3uQPya3aQZsUKlwSJZwNCNsjsS+5Naayg1SnEA4CbD3jwBISmLNhuKDelMRrBYSYu/exVXBoUT15PUE2iqlKf9B0VHv0afIe3bf1ZrnOOeT6UxPlT6zs0AXTGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tv0Iglbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tv0Iglbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC51C16AAE;
	Tue, 11 Nov 2025 01:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824341;
	bh=ZEgVsRLcSVPWxPG9sqWRQz4iwboqVNgWPCesFwrTlX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tv0Iglbti/5jAGSfI6mjuqRhWlp+Ivmqj1mHP6irTJp/US5+Vz6aYi9utsS+0LvXq
	 iUvbKFYaejg1EuvOSzbQaVu/sVZsKEH4ELCSc2XIbsImA8zxqzI4rYipO0npL5aoj0
	 ThXWYijrBiEOt94wd3sE2T/flF0Nzqf+fcl2ALEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Sinyuk <konstantin.sinyuk@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 425/565] accel/habanalabs/gaudi2: read preboot status after recovering from dirty state
Date: Tue, 11 Nov 2025 09:44:41 +0900
Message-ID: <20251111004536.424063948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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



