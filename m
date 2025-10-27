Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482EB31D36D;
	Mon, 27 Oct 2025 18:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590574; cv=none; b=G1azkTki9am9TvXRicUbhhVE9LjgXgL6wGf5lslrGhuqe7jhIkX6fy/aeeXuBls2HKwkxZQAvegw3XrLTKriioq/gv2DQCp3v1PhYbOO7kzy15BVXFPreNMg+wDOQ8VEMpsCt2W3TV2cs7z8LMqygBMREX8llcST3IdwCjz1vgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590574; c=relaxed/simple;
	bh=AqXWdngtoQTNfc656/amsq+Z3Cgkfvv9wORH5X1WdAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XInheFBxGcQOeUiBMBIgKoInkimXv4b4mJg03q6B+LZjLMkuEq118++2TL4B0RYI70+LnYZK1xUhFMDYt9wo5HegNG1et4g48qUTxLP8xJzWBOtYneZxqa1rujl6skiy9m383W9xWKXvAThYcI4Vr2rz6T+AurYwW9Wn5wlVuhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OQjGDuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OQjGDuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0546C113D0;
	Mon, 27 Oct 2025 18:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590574;
	bh=AqXWdngtoQTNfc656/amsq+Z3Cgkfvv9wORH5X1WdAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OQjGDuETON5RgHBSBqwT3YyxmW/MjZueV6wWfjC37LeYXGFuRPUIROsHkwGxrUjh
	 8sj2SMznz+laQkxXPfXw9oeOSlWMk/5w16VFmgVvKeQnTugQ3GDlUUregQaKJeix0q
	 vKOtPwYNXkCZtNTkkCNxFWD6fZT2gaB2sihY1Peg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/224] mailbox: zynqmp-ipi: Remove redundant mbox_controller_unregister() call
Date: Mon, 27 Oct 2025 19:34:01 +0100
Message-ID: <20251027183511.531970490@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit 341867f730d3d3bb54491ee64e8b1a0c446656e7 ]

The controller is registered using the device-managed function
'devm_mbox_controller_register()'. As documented in mailbox.c, this
ensures the devres framework automatically calls
mbox_controller_unregister() when device_unregister() is invoked, making
the explicit call unnecessary.

Remove redundant mbox_controller_unregister() call as
device_unregister() handles controller cleanup.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index bb7bb17386475..8395f4013b111 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -619,7 +619,6 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (ipi_mbox->dev.parent) {
-			mbox_controller_unregister(&ipi_mbox->mbox);
 			if (device_is_registered(&ipi_mbox->dev))
 				device_unregister(&ipi_mbox->dev);
 		}
-- 
2.51.0



