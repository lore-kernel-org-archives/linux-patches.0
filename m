Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2CA60DCF;
	Fri, 17 Oct 2025 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713077; cv=none; b=QlzVEWo+6caOrtJo/EMbLVnAX9+Nsxzzxt0pKtsqWvff/eaPq/dGaFuMPaJTv6vDvUemdJUT1TARawHHWk0cPr/Tx5UGZHIMyxX/pz+hmhVgtwlvo7XpwY6Sc0xXe7E8L4ytON4xuMN8E8ar+Y4cSCyHSx/nnOwXFY+qLHRhDL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713077; c=relaxed/simple;
	bh=zTMz+VEPO0Yh/GOYti26W0P5e9hAo6wN+rKUy1bk+0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Srra2iSjNyEPyT1or9iVA4LK4MrQssi4txhBri9JYmLyq/xi7w7yefi660iyK924yZvXoKP0dEu5wwzfCCOenI/TQQkKjS0VpIP04BbhNQ3Mwp7Yx7v5swO0TEATBrjRg5btn79zXQEn+VFEQ/MYFrM5IOElKekAuT5XFhTym7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtN/93Ne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtN/93Ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684FFC4CEF9;
	Fri, 17 Oct 2025 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713076;
	bh=zTMz+VEPO0Yh/GOYti26W0P5e9hAo6wN+rKUy1bk+0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtN/93NeqzR1njbuDeTpHPXlpHYNJfcL0AfU/RP/Z9y45FZpKTPFcRDqW54IReWhT
	 REVuIn0J99tTVPjSyyFgkWlK2Q3e6Ixzmhfoy5R8zlj4vOqD72mS3TnY6mWIn/jJ6o
	 RQ3VyIZ3apgC1BJY3rRXR6cPn1T/bhNNYvLdhG3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/168] mailbox: zynqmp-ipi: Remove dev.parent check in zynqmp_ipi_free_mboxes
Date: Fri, 17 Oct 2025 16:51:58 +0200
Message-ID: <20251017145130.458405973@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 406821a78d510..6a48b832950db 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -618,10 +618,8 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
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



