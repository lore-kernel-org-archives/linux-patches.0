Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7F4330B18;
	Mon, 27 Oct 2025 18:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591299; cv=none; b=ZNygTcZsSul9ABGV5SUlqwjsx0wFh8XddejYcgxY2/tnp+XiTzcZpnA1L3tw8RDG+ICPmO5FMQkRQFH/4N2xGwU3aKjRp+9CC6flQ8E6ULsR3F5gFNdKzmkIRLTzxLp52j4wy4WPv/ltEnK3ByqA7UN9kSB5zTPY+TcLkVBHJ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591299; c=relaxed/simple;
	bh=pWgBKTFk11Sd39JeTLbf+P7mUWlu1Nlx++QR/v7PAEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6GhC0U24+C1vNvU/0xOjGkysVHJfZZre8xE9aS/FdrlxWooc2OXZtxl6Xq2bfVSHthfqReIrU7fSUiXdyN1CHsEKLscW1F4o8aMah1MMZDXoFGx9WISbWt7EWWWE1Olb7Y0n8IddWsaqpxWEpLMxh52o1QqLFp4L2vKQfI9MbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ic+Ml6YY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ic+Ml6YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1488C116C6;
	Mon, 27 Oct 2025 18:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591299;
	bh=pWgBKTFk11Sd39JeTLbf+P7mUWlu1Nlx++QR/v7PAEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ic+Ml6YYace9em6jqXXSCcVLE3Zj2vPr1dSrz96MuNJeSu8vKSWPDTR+D2PbghoFJ
	 EwQcf5has9jl9g4LuJ0dp1FPP9He3Nmu3JESgWShlvI89QRKtjUF+YLSlAFsQVqgWq
	 AndX+mKXM9pmVYYmK5PxMDos7lhET7CPG9jblB6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/332] mailbox: zynqmp-ipi: Remove redundant mbox_controller_unregister() call
Date: Mon, 27 Oct 2025 19:32:49 +0100
Message-ID: <20251027183527.679240027@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index be06de791c544..136c1f67dd223 100644
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



