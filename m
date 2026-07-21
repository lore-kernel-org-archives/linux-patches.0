Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9CB3E7141;
	Tue, 21 Jul 2026 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655027; cv=none; b=KZSbG8IgxS4StXhf2r5kVEodmeKVp3TfGSt8LOQhF9jwImMeIKj4d922ye+1kH+5o6xhfbOj+sZcz9yTmQ2gFoHGGW9B9JK2SzlfEl6LdN0ZY65r9/Alj03QdaEaVtp2s3HYm+emtvp9Qo0itbl7EnQQy682MqVdi0eclBY9chw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655027; c=relaxed/simple;
	bh=rScPkVK6DlVd78s1Ho92ddM/uSP8cXElarK7s+1TxBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQBT1/arIib476c4cacnc1Up7nltMXwQPpb8EdsWV3f5+8BPX2OuSm+7BedxSUfgwyNAc0b+E7lU6MKnB+ypKm+K5MWwUje6QLozHUg+d5XG/yarIC8H6yoeH0Xx8zRNEDp9I1HF52VMMXAN0A1Pj0p7WMQq+oVPbFauclF5N1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k07jHHqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k07jHHqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF1E1F000E9;
	Tue, 21 Jul 2026 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655026;
	bh=bjPdiTWG4d+/142nfz2X3i2ykytoenJpAEQuI1x8sl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k07jHHqRD/YA3B/nlXZpCWGRybpPz5eCU7d3tYHaK+LqW9j+rzsmbmgJnRixyy+d5
	 /Upr8cxvBxJt5b7buUbnD9Y0hCsslsevcidLauxZnA6zoyeh0iLG1ugb3BMOJ6VMLR
	 A2GBcZmq/HvVffppScee97QYeopQEa8Lip4ARl0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1927/2077] octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF
Date: Tue, 21 Jul 2026 17:26:40 +0200
Message-ID: <20260721152638.161648467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 8cdcf3d2caacdee7ddd363705fb4d93b0c1a0915 upstream.

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


