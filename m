Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5C935292A;
	Tue, 16 Jun 2026 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633872; cv=none; b=pIxG10mCHj5+IpXogMTm7sAcqgO0y3y1LrizRggGfUrSynNL0oUO5dXi7t07DBWiiwoiWo497YyaoPa/OC1C+lXaXY0HkjNVfJ0zYSJ3fs89xbTohoDMrgzdI9hmmMGPOCVqU1DGcUdv1DdxDSQkfi/rwyObRRSpsVrbMf/lWLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633872; c=relaxed/simple;
	bh=LPUYJrc1u2pnogvP3FAaWXzbea77gP81JkKxXnH6S6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ug4BARKziZnJ2to8zOYA0hn/ugJbMdByZFrQ9R8vUgASw5wR/TH+aeaYle63hXm85g8YEf4hfA/2WW7GJajHR89itrOclY10htmA5inObZad5odIOpp7A+C+YZjQRGj81BYaQQgJd7YCoVLx28MWvF7ozGQBHPfW1FFLmPF7UnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibvoDZXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibvoDZXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209A91F000E9;
	Tue, 16 Jun 2026 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633871;
	bh=RPsSgW1HQbomQ3QmyqwQIcms46OTxloCPQb705MMwHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibvoDZXgh3s7znL39fid2lWpD1Wn5aAFDnHfKMvlE8fqkWK6G0SDw3ImAEg2N3yhF
	 Ci/EBhFnIOWZ5u1J+oHTLD+BnmTX2RIuZ4k1HLxyexzDzO7kI/1D6s0igtZHSeDJv1
	 UJydV12Ao+7hBitxhkzGUO1Unw8c80fouT8gZX1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 126/411] scsi: fcoe: Reject FIP descriptors with zero fip_dlen in CVL walker
Date: Tue, 16 Jun 2026 20:26:04 +0530
Message-ID: <20260616145107.024973761@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 9eed1bd59937e6828b00d2f2dfef631d964f3636 upstream.

drivers/scsi/fcoe/fcoe_ctlr.c::fcoe_ctlr_recv_clr_vlink() advanced the
descriptor cursor by an attacker-supplied fip_dlen without ever
requiring dlen >= sizeof(struct fip_desc) in the default branch.  The
named descriptor cases (FIP_DT_MAC, FIP_DT_NAME, FIP_DT_VN_ID) checked
their per-type minimum lengths, but a FIP_DT_NON_CRITICAL descriptor
(fip_dtype >= 128, which the standard requires receivers to silently
ignore) skipped that check entirely.

An unauthenticated L2 peer on the FCoE control VLAN could hang
fcoe_ctlr_recv_work on an fcoe, qedf, or bnx2fc initiator indefinitely
by emitting one FIP CVL frame whose single descriptor had fip_dtype ==
FIP_DT_NON_CRITICAL and fip_dlen == 0: the cursor advanced zero bytes
per iteration and the loop condition rlen >= sizeof(*desc) stayed true
forever, blocking every subsequent FIP frame on that controller.

Tighten the outer dlen guard to also reject dlen < sizeof(struct
fip_desc), so a malformed descriptor whose length cannot even cover the
descriptor header is rejected before the switch.  This is the same
lower-bound the named cases already apply and is the minimum scope that
closes the loop.

Fixes: 97c8389d54b9 ("[SCSI] fcoe, libfcoe: Add support for FIP. FCoE discovery and keep-alive.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260518144307.2820961-1-michael.bommarito@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1391,7 +1391,7 @@ static void fcoe_ctlr_recv_clr_vlink(str
 
 	while (rlen >= sizeof(*desc)) {
 		dlen = desc->fip_dlen * FIP_BPW;
-		if (dlen > rlen)
+		if (dlen < sizeof(*desc) || dlen > rlen)
 			goto err;
 		/* Drop CVL if there are duplicate critical descriptors */
 		if ((desc->fip_dtype < 32) &&


