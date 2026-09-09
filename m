Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B216E55C312;
	Wed,  9 Sep 2026 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964658; cv=none; b=ScWS4UtJn605ROzmt3koFcWoAkxpITTwrNGIt0Ct6M5yRMd2kE2W1+L8oM5e2mwf2YvDRDq8BRhOL9AjoGkdyGPPtri77nkc6N25+ZURslxo/1iSpMFXXO47mWs3moMUMQwv8YXMfvmwElpMzLPORCRkqTS3PoJv+w5w0nv1bpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964658; c=relaxed/simple;
	bh=2Z5cBSIxKQc5nB6jxomOHsTBhMsnNIfKPkcMdPlnKZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5jrQFe+8iL+qXYCR+0aNSQ1KzRpyTBaQxopVzR4JBIulrquzAA7BdYSLSTZH2w1hTQV07FUxLQZDBX+6kQurdJj6EatNgNPGAXvRrPVg3U+MjTaNguNT5Dhebfob6nEpyU2bNOd7xff6R+8NdeWhXYZFriQOrTgj7f1QcY4aLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GT8l1zDu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GT8l1zDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A1D1F00A3A;
	Wed,  9 Sep 2026 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964657;
	bh=q8/0h+xiz3gmP89Q54ZcP+PjuqYm60lGDDr0J3p2eR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GT8l1zDu2Y6qChmuqUllylsQ3Hk8EQQGHYTVvPTEcwY2f2P6vxzABQqwQVWDjEBfZ
	 LBCGWWRh3FHc/4elFJ3OuPFNKpyRd6kZaWzGTZoUbkM6AOcXDboKCAoX19zzzjkHkg
	 216xm2rKq+X9gSWoMK4yiM9VQ74u2bObD12tCK94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 499/583] scsi: fnic: Use GFP_ATOMIC for VLAN alloc under spinlock
Date: Wed,  9 Sep 2026 15:43:04 +0200
Message-ID: <20260909134255.062064509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 9639c6324524ea3f934908bd51f02430000954ab ]

fnic_fcoe_process_vlan_resp() allocates a VLAN descriptor with
kzalloc_obj() (default GFP_KERNEL) while holding vlans_lock via
spin_lock_irqsave(). GFP_KERNEL may sleep, which is not allowed in this
atomic context and can trigger a sleeping-from-invalid-context warning
or deadlock.

Pass GFP_ATOMIC so the allocation is safe under the IRQ-safe spinlock.

Fixes: 098585aa8aca ("scsi: fnic: Add and integrate support for FIP")
Cc: stable@vger.kernel.org
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Link: https://patch.msgid.link/20260731073820.16449-1-gonglinkai@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ adapted kzalloc_obj(*vlan, GFP_ATOMIC) to kzalloc(sizeof(*vlan), GFP_ATOMIC). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -139,7 +139,7 @@ void fnic_fcoe_process_vlan_resp(struct
 			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num,
 				     "process_vlan_resp: FIP VLAN %d\n", vid);
-			vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
+			vlan = kzalloc(sizeof(*vlan), GFP_ATOMIC);
 
 			if (!vlan) {
 				/* retry from timer */


