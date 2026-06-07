Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21661296BCC;
	Sun,  7 Jun 2026 10:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829606; cv=none; b=r//wtHeE+R4Vf890cOwNPTRxQlTtIHnKzCf1UMVW6GQbuEXRcyUPaS7T8TlOI8QrO5oAHZttA/SR5b+fHHshZgd459na+Z6fgy/FMcfmeSWXvlPj9N7vgIGf2AcT04bzfqTKnTQlLRtAIo+v3SLChKInKN4MYFmFKSkNdUsmUkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829606; c=relaxed/simple;
	bh=uwweY3IP2xjT5lFbjnKVl6vuK3kGKcRE1L+kCBG/fVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2QDt1oMxJQ47QSoGGEAVWhBtUYDJjrtne540nnuO0z+TnRdZV+O9dZJkav4I94zw6mUkkUBvf8adrzIXcsY8KWDY095L0qBZHYzjh5bDEK24kcWl4uPvDPZpkPphtdkO48bZMFMFWXn1Swyw2U11b+XXr2b58FYtwHlbjaLyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmFpXYR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmFpXYR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268651F00893;
	Sun,  7 Jun 2026 10:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829604;
	bh=zRvihZZzJe/in2qW9FaxXeLqvG2x8AtsDb3YCSizxHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmFpXYR2D0wczWT39DYvXUC8Nx7jSOZSCS7/9a6eh4xM2PneUR/nocZYLRhgDCq6J
	 ClofGkLS+ZY56WKJsTj8rKGF2txUQLoroGk1dgQto9C7K6KUkHm0dzMdDSDeDq/h4j
	 9cCvrwnIFgcHj+8uWdBO+1xywvr/vLZY9s+yFIIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 239/307] scsi: fcoe: Reject FIP descriptors with zero fip_dlen in CVL walker
Date: Sun,  7 Jun 2026 12:00:36 +0200
Message-ID: <20260607095736.477535172@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -1386,7 +1386,7 @@ static void fcoe_ctlr_recv_clr_vlink(str
 
 	while (rlen >= sizeof(*desc)) {
 		dlen = desc->fip_dlen * FIP_BPW;
-		if (dlen > rlen)
+		if (dlen < sizeof(*desc) || dlen > rlen)
 			goto err;
 		/* Drop CVL if there are duplicate critical descriptors */
 		if ((desc->fip_dtype < 32) &&


