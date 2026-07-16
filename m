Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EF74398FA;
	Thu, 16 Jul 2026 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212228; cv=none; b=op7SL/SmVgmVeF8ertLlxtp7vCpbThE0Ne54a9gRGOcocQJpe70Vk41YqPCM/mWMmvuOBODTLBkuQhNZbn9ZOL/0gjwTTxiB630eoGMzYdu7bt2bdnzDkIwknf+RedTj2OLqOj3gE5xPqk12LMoeYlCLy/NM1ZsGznlm9/vG5B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212228; c=relaxed/simple;
	bh=gIJWTXIH3DV39StpolNXMhrKjPDR32Osru9/MX6bJcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NK+edz7fRnn4ekWajGqud1UUv2DitTrNBnjBaA4JGX0kfoIrgzX/FyORYD4n0aTzrXPzNrjzIUCdKqHQ56KluYlv1GLTlYTa6xKTWrUfX2f1WSDf+XSCD/Bq0ehFdHhX4kZ+PHc0tMnrmLSDI62R18Yq0Bhmup9u7hCNzwINVpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIpuDBjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIpuDBjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427521F00A3D;
	Thu, 16 Jul 2026 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212226;
	bh=N4oh/GM389S7CVs815wmKbzxs5vwiAtrb/awYJ8ZYjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIpuDBjQhzSskcOLDt077dKUgN3LBItQ2T7D9s5rN8gX1nR/X/Q7gJDpfmsjKQn82
	 dIbIFLFPNiNdvtYU2u6ROpTQm4y5qvNe7Ic1nLCZySni4f1SWS9ZheKWpC1wSIQJ3L
	 /XOADQCGFrR/0/aa23p9TzETZDDH1nkq5Gxk3ezI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Yan <andyshrk@163.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 248/349] usb: typec: tcpm: Fix VDM type for Enter Mode commands
Date: Thu, 16 Jul 2026 15:33:02 +0200
Message-ID: <20260716133038.905943118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -2872,7 +2872,7 @@ static int tcpm_altmode_enter(struct typ
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	return tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0, TCPC_TX_SOP);
@@ -2920,7 +2920,7 @@ static int tcpm_cable_altmode_enter(stru
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	return tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0, TCPC_TX_SOP_PRIME);


