Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132DF387373;
	Sat, 17 Oct 2026 17:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258206; cv=none; b=D3dh/lhLcxR+YdXPOYIielM4KGbgfTfrVjW/hMus0RRfTTQQY5lhkuQo/NyF5RhJy5AUmtJ7+y9HVxoZ/F0od+zaD5M5bhOD7f0xs2Xlw09aU1liUvDcc/b+/CUk0Ni417Mrbp0HMWbJ7y6NmLA58TmO+W5CopYBmWbPYdL9yrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258206; c=relaxed/simple;
	bh=STQLYvLYaKGUDy11/P6qH53kq0GPrQaZjlMZtHn3Hx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPEWTVBXsGw2YFKKGsh0lem6sh4XmkyR+I+uZ4nXutc0/LLhrrNECl3vJycHML9IiUANIrhsdmp0Y2t6IKeyKaEHIM5jdaXr6FBT6ZivsXR6+6hiVSXdxbOhwx8hdP/XoY7X0DquXV4s3kircwwHCYD/QiZ2xOqpGe6deBRjmyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZPlhux4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZPlhux4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6902B1F000C4;
	Sat, 17 Oct 2026 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258205;
	bh=5pIxknCMZXTMPGRLhh8Ra4RFPQT9eiEpv5lvDf2QPYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZPlhux4Uk48LK+c20mejNUeGZh3Bk4SdOv7IZVbwiu01Zt/8CSOe8wUYxpu8Pk+G
	 gaHD+fqoziEG7IZire8rhwCkOtFucyXxaXOKdBLuL033Z9HrUuc0xgllNdy21mFP4k
	 DZx0aChXxrdpy8XCoSlC/ExDAOk5Yve0MzyG4Q34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0808/1674] mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop
Date: Sat, 17 Oct 2026 17:51:20 +0200
Message-ID: <20261017160451.855140000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index b3428c714e2f6..c89989c234111 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -646,7 +646,7 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	struct zynqmp_ipi_mbox *ipi_mbox;
 	int i;
 
-	i = pdata->num_mboxes;
+	i = pdata->num_mboxes - 1;
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (device_is_registered(&ipi_mbox->dev))
-- 
2.53.0



