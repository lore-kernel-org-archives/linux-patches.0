Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07EE23EA9E;
	Fri, 17 Oct 2025 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715105; cv=none; b=AYzDXtpUSFerCMaomwIUJ2dRlaKVQKd9a9hXq/xZO3DeqsaG0bKc9RQ0+Za21wQQ8wAc8bzGTyoiK4s54XYxZdtRvxXdEZR/hCxQnNFTBh3GbzAFpdolF3DNfjP51l403XebCu40EEb2oOkOKxEdH0sZ9IqnLAaH4Sd9NQR7Ziw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715105; c=relaxed/simple;
	bh=yHUdTDAjqgRXuhh2nQ0addYi2exUeRwCWfAar13xzqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNHrO6jctINfDaCX56sFuRmgzKDhgNRTvlJbVbDWZ+ev4oCroyp7coSUPcmhLi6pSVwDZk5mUU0s7GmVXon+/hXcpX4lpXJ3JKjWdfPpaMRT7BShde+Ov2PL6GYGpULOxSShCPIsoUmO/iTyq8wdYr0PdIJDrhwAorHIdgSzvTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AsLEwgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AsLEwgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39905C4CEE7;
	Fri, 17 Oct 2025 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715104;
	bh=yHUdTDAjqgRXuhh2nQ0addYi2exUeRwCWfAar13xzqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AsLEwgdh42OH7jF37ragzZtCMzawWDX281QEPI6N33u+Be+Zfqu+XNal17OUg2s9
	 C71J/G9awa89GllIHJnAaac4ahF6iVc+Y8MIXTL5Q7AY2V/sCTYHoNOdQwkN7OS5aR
	 5AFI7mwhW0Ra0HzZM7jo2JmKJajShR0yIHRH+iuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 100/371] mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop
Date: Fri, 17 Oct 2025 16:51:15 +0200
Message-ID: <20251017145205.559384523@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Harini T <harini.t@amd.com>

[ Upstream commit 0aead8197fc1a85b0a89646e418feb49a564b029 ]

The cleanup loop was starting at the wrong array index, causing
out-of-bounds access.
Start the loop at the correct index for zero-indexed arrays to prevent
accessing memory beyond the allocated array bounds.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index bdcc6937ee309..dddbef6b2cb8f 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -890,7 +890,7 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	if (pdata->irq < MAX_SGI)
 		xlnx_mbox_cleanup_sgi(pdata);
 
-	i = pdata->num_mboxes;
+	i = pdata->num_mboxes - 1;
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (device_is_registered(&ipi_mbox->dev))
-- 
2.51.0



