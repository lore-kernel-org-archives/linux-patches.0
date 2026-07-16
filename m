Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A2E422E10;
	Thu, 16 Jul 2026 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211139; cv=none; b=QdFdxSwC7kQyxFdn0aw2btav8+2PxfLoOqvniFOPzD0V0Y3k/PDNFsUSdhDR1nTf9tAk3Pgplo4nbggvWt8+9/RbYYXT1ngJ7AFf1SjaUfy40i9s/tVbZ3bvOPVvs0Y9k3ZSp9wPU6lGKfnOoNXzdzETPTCrPhdTls1Tn5h2pzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211139; c=relaxed/simple;
	bh=qXXQFBHdIKpHFt0e0zbZ/AmQKytfjAn3UhHDcfiuniA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llcS14dw5fRz4nK4XQaQRCAjsdxBx8Yn8yHbqWirDstde3MCvR0Hhq0CVRR9lsXdYIQU1qNlh1nHel+VfjYpzgYxeyWRgrRgdAHpH6xckyFN6uuA56fQ+nYZJjz9puleIfDHTWpFxfeHLUFcHGbhQMnKaE4OIrQx4y8HJlgFifA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5+1zCya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5+1zCya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE331F000E9;
	Thu, 16 Jul 2026 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211138;
	bh=NmIvKkpDAdcIn5FKFaGcy93+Ti0XgrGkRtm8q4uw9iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5+1zCyaR0h78Qz8pagHAwEBbLcNj2HwqXp+AmXmg7bCdJjBrJqu7E2mL0XyMOAnn
	 iGYUTBOwGVpkY2Caxem/ED9TcPV5zFujHQOprVYEEkZ5zwdC27OMaeL0zMIQaWuiwS
	 L+twOFrYmrDZeJRcRO4ckLDxCXjP+bdLlzOJsMKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Yan <andyshrk@163.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 313/480] usb: typec: tcpm: Fix VDM type for Enter Mode commands
Date: Thu, 16 Jul 2026 15:31:00 +0200
Message-ID: <20260716133051.592382744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

commit 9cff680e47632b7723cb19f9c5e63669063c3417 upstream.

VDO() second parameter is VDM type (bit 15): 1 for SVDM, 0 for UVDM.
Using 'vdo ? 2 : 1' corrupts SVID low bit when vdo is non-NULL
(2 << 15 = BIT(16)). Enter Mode is always SVDM, hardcode to 1.

Fixes: 8face9aa57c8 ("usb: typec: Add parameter for the VDO to typec_altmode_enter()")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Yan <andyshrk@163.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260604105059.18750-1-andyshrk@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2928,7 +2928,7 @@ static int tcpm_altmode_enter(struct typ
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	return tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0, TCPC_TX_SOP);
@@ -2976,7 +2976,7 @@ static int tcpm_cable_altmode_enter(stru
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	return tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0, TCPC_TX_SOP_PRIME);


