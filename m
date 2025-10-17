Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF56333710B;
	Fri, 17 Oct 2025 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713591; cv=none; b=Oo1UGlEubu7W0yihrOIjwQR4OvXVy/12GE9zy+LrcoVHiqJGm1Whe4PuPw0yi412mgP9OcB3XnnNrFiCFU8NS6zs8KrFfppOCvysBTWbwf8BrTRTNKKCJnWJidvQf6mGo3s/XXMhctIorQrDR4OpCZKJ5iaP9szSx/x+zvYmU+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713591; c=relaxed/simple;
	bh=VCpecrqCP0/Go4wLyGS0uOwa3zcfKGgFn+8sd3VPfpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRJiolmEnqv2AsAYbTbpoQrdABioTfWz48UxdQ0aVmIaIEQKTVP/admds5o6iRpVB79ho0VfPbglriZwIqIVfPsxstCb4l/9Ddk04vr2pDWAU8YT00RbFAkoJnhtqMBsJ1j4Q1Wzd0/bz4VzTAkS2LYH85t/aNFEwuUCQ6+BL4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWDHDA7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWDHDA7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795A0C4CEE7;
	Fri, 17 Oct 2025 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713590;
	bh=VCpecrqCP0/Go4wLyGS0uOwa3zcfKGgFn+8sd3VPfpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWDHDA7GQ9kI9DzyaZWTmEwXuybyIdUtlpX2dWBnQhioDO5udd4s3O1ci1OzaOnZT
	 W+mFr5kHcVI4iXPFJxwKOISwTuBzwCAZ4gE1uBSejy+ciXRta3tvQdFLUQrw3LDnQ9
	 8rmfGrh7sRL1slX4nshgLM0s0kawYtxdupjtD1Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/201] mailbox: zynqmp-ipi: Remove dev.parent check in zynqmp_ipi_free_mboxes
Date: Fri, 17 Oct 2025 16:51:44 +0200
Message-ID: <20251017145136.329056255@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit 019e3f4550fc7d319a7fd03eff487255f8e8aecd ]

The ipi_mbox->dev.parent check is unreliable proxy for registration
status as it fails to protect against probe failures that occur after
the parent is assigned but before device_register() completes.

device_is_registered() is the canonical and robust method to verify the
registration status.

Remove ipi_mbox->dev.parent check in zynqmp_ipi_free_mboxes().

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 06529dc0daf3f..90f248ef2a1fc 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -616,10 +616,8 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	i = pdata->num_mboxes;
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
-		if (ipi_mbox->dev.parent) {
-			if (device_is_registered(&ipi_mbox->dev))
-				device_unregister(&ipi_mbox->dev);
-		}
+		if (device_is_registered(&ipi_mbox->dev))
+			device_unregister(&ipi_mbox->dev);
 	}
 }
 
-- 
2.51.0



