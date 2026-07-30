Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFA94457D7;
	Thu, 30 Jul 2026 15:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425197; cv=none; b=NhqcxvS9FKUh73saqwSh6BXrp6meIcg46iTN5Fvgp8Vc3RiSn6KLCJJA8NPbQWqrPGNnkk9eLQcutD6f9ypTWk7DLtaRe5mMlh4xXFeKThc7Sb4Vh9Py3wjkCSiPlop/hnhtu0SqI6aY7bkNJ5euCydv5TOkReDVlPq8VfhOWFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425197; c=relaxed/simple;
	bh=yKORot17TXnPTdjUfYJjOY5l5L76h4yDsMMRlqGXP2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2V+ldlBg4u5BX2x8HRaMSnGJAWeyIC0iCepCIbFfb3eg+I6oojv7iyW+vSVf3tUstFXuxPmGKyjUONXpmGiNZbpUnIgden4AjAIOQ5tIRJ3Vxueye3TUUxvcMLDPiLwXJenBJxwdgSI6RH3iAGG1btv3d+EZKDGWbdS9vlwcRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/W1Mijw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/W1Mijw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652DC1F00A3A;
	Thu, 30 Jul 2026 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425195;
	bh=qLZstezXH71RDO5Y+2KoYCNKC3pd6UZiNWHRZDFhJfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/W1MijwdIRdNF47Yq+QeIqFKLdJY3NGmYbBQmLb4JahH/nzIjXewV/v6CYEf+r0I
	 OLbjWmujGfT2h5iUSn03Fa2haBlnYG6gimZJZGgH/IeeZs5tY1VpUkkIKnQLF4NDdj
	 Q6VfjbsMhZcqriVoCwldXGTJZC6a7BYzql63WHRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 658/675] octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF
Date: Thu, 30 Jul 2026 16:16:28 +0200
Message-ID: <20260730141459.134142023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 8cdcf3d2caacdee7ddd363705fb4d93b0c1a0915 ]

rvu_mbox_handler_lmtst_tbl_setup() uses req->base_pcifunc as a direct
index into the LMT map table to read another function's LMTLINE
physical base address and copy it into the caller's own LMT map table
entry. The mailbox dispatcher authenticates req->hdr.pcifunc from the
IRQ source, but req->base_pcifunc is a separate payload field and is
not sanitized.

Reject the request with -EPERM when a VF caller's base_pcifunc is not a
valid function under its own PF. is_pf_func_valid() bounds the FUNC field
to the PF's configured VF count, keeping the computed index inside the
caller's own slot block.

Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST regions")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB78811656934E713B77DA6CEDAFE62@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -178,6 +178,15 @@ int rvu_mbox_handler_lmtst_tbl_setup(str
 	 * pcifunc (will be the one who is calling this mailbox).
 	 */
 	if (req->base_pcifunc) {
+		/* A VF is untrusted and must not redirect its LMTLINE to
+		 * another PF's region, so confine VF callers to their own PF.
+		 */
+		if (is_vf(req->hdr.pcifunc) &&
+		    (!is_pf_func_valid(rvu, req->base_pcifunc) ||
+		     rvu_get_pf(rvu->pdev, req->hdr.pcifunc) !=
+		     rvu_get_pf(rvu->pdev, req->base_pcifunc)))
+			return -EPERM;
+
 		/* Calculating the LMT table index equivalent to primary
 		 * pcifunc.
 		 */


