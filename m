Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F90219A7A;
	Fri, 17 Oct 2025 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714201; cv=none; b=iT/hxQIVUUFD91XGjCU+2vn7CEeGJkvYtu3SpETPDOZTCqaskc3Z9AePdi55Bqc0nhLO+BZPItvFJpnJR4AAsEYN3q0x9WEy9EjqqluoK79+CsS4P68LWrJeeA72VNY3GmfD6qlIIQx8NlZ75rysGFzJlqXpakVUQrO+A0N4y90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714201; c=relaxed/simple;
	bh=qbgzpyLeW7/4Tw5LRdDx9rAjsNBzfPFceB9c8se9xI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZosGEYovpneDzdgv0SKUO5aINuaERbiouk16yietpSe3wFvxeoyUQVphonsWJXkqy0fvbepjSas4dB/venxCW73GaNVKMpAOJNHznd441w7U8EIzxd8IsaNrxjI7MDJf2LXvuFZaYmch5VzYWV9aDf/Nq/MsrrbnLMuh+EX45uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fiUSla4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fiUSla4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA46C4CEE7;
	Fri, 17 Oct 2025 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714201;
	bh=qbgzpyLeW7/4Tw5LRdDx9rAjsNBzfPFceB9c8se9xI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fiUSla4dlb9Bk1apHPtvEnJJt5ZdUGcrpmRz6+9yarWWSfhc53BuJCro1gzUCTfz
	 jWpit5mOVYZWvJfid5B/4P9aVy+j8eHdlVln9r/0HveCHS8asUtYz+tpYf3uu74llY
	 ECaYKC0yPbYUdVc1+c80VtGqIeLM+wgIK5c4OfnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/277] mailbox: zynqmp-ipi: Remove redundant mbox_controller_unregister() call
Date: Fri, 17 Oct 2025 16:51:08 +0200
Message-ID: <20251017145149.374247512@linuxfoundation.org>
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
index d59fcb74b3479..388f418aebb72 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -894,7 +894,6 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (ipi_mbox->dev.parent) {
-			mbox_controller_unregister(&ipi_mbox->mbox);
 			if (device_is_registered(&ipi_mbox->dev))
 				device_unregister(&ipi_mbox->dev);
 		}
-- 
2.51.0



