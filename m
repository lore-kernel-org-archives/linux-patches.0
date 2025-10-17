Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10B432E13C;
	Fri, 17 Oct 2025 15:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714224; cv=none; b=cKj3i+S//kvlW+6D7ioRrSRpXTvRNB9wpqDCokCih5vwsFd6knr0Ms0y5IiGTnu1cNhph/19lg4CzwcxlSDz9xRTwE2j4KkLDR3ETjsaDZjdQ+V83mhX22v5wRHxuJpmB0Th7wxIpTtaG8z4/ycQVOHAE/p1PK/WLZ0R2Rdd73Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714224; c=relaxed/simple;
	bh=WBnkIiEbGbssaWzKTCswtW93IqRnrUlvdswIFUhiM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFird6QCYQ26ZExXNPCCVs7gz+77Qv4CUl+rcKYqpHtN6OBh7OnmD03suD/oN3osMyThOgl6d53Q/g8dALNDngxDv8VxE5lHHEOjusIyrjPqgABmSDGNl3BSB1Pgj9x5lHJXQO2Qn1j9+1wKTGfU7EXbZJtkwqqOOTk9Lr21xvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/ZJ3X5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/ZJ3X5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5B5C4CEE7;
	Fri, 17 Oct 2025 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714224;
	bh=WBnkIiEbGbssaWzKTCswtW93IqRnrUlvdswIFUhiM5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/ZJ3X5lrKn6S+DAEwT1TeBBdXS11XrXCVJbqK/Djh9ErwIVrwkhMYhm7ldzn/3h0
	 6w7b9jWyEmuyT9j9bc8v01gbcV3oscKpHYxBLV9oAZNRDwDz6ZfLrOXQ8kYo2I+Jx7
	 pUKvncOTQVzEzWqKcYMbd7B1YaCszn1lUtGQGX1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/277] mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop
Date: Fri, 17 Oct 2025 16:51:10 +0200
Message-ID: <20251017145149.445233912@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
index 411bbc10edeaf..fab897b5724c1 100644
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



