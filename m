Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4C91A6822;
	Sun,  7 Jun 2026 10:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829486; cv=none; b=l2f/qVxsDrdN1QPdj/FDqYfvj2WxsbZosGcDOA94uCf/T691WLEGF2s6mRyN+7DXA2oi/du606LC8cPjODxbhoZSLPt5o8B2eJ3jzSSXWdaffhmKlKMAS+BShUF6J8YmznGFS6e/U5ASwvFueRiVJ/yiTHDz4f8uw9HjIt3SOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829486; c=relaxed/simple;
	bh=RjhHY/QAY2S21ZJAvN6FgtIMmk+D5N+D06zeoduum4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO+u1XKiFwScFJOl+wPuVnPL2Hj8gxyqdnf5TJcmXiwK8kteN4HS18n7PnPd2nyOG95m3WpsFO1hpq+AKax1s7AyaE/DWaCSYxXeHEKIkykY6HatpvYF+NJuZPKa8r8TILIOPKhlRJ9ZP+uADOG5XhIEuqZqJT94sD22H9Rxq+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mbctaAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mbctaAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D601F00893;
	Sun,  7 Jun 2026 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829485;
	bh=YH9SOihWiXxd+ELrM+UBrWyvOfere+ewW4eKS2w279o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mbctaAqtChi3unvykC/VjqZ7Irmgvk81y/TX0gyF/gfiQSFeqd0DQf8RiGhk1FID
	 GBZhwkGW0oB1dh6Zv4CJTFb/UsFz2ZwAVAvmOuucMgbt8AjGSVAmQuYHaY0HXalOqr
	 Shd8FWp3Y11Qs9OuJ+JKbCMMda5xztSLbVRksHus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.0 283/332] scsi: fcoe: Reject FIP descriptors with zero fip_dlen in CVL walker
Date: Sun,  7 Jun 2026 12:00:52 +0200
Message-ID: <20260607095738.440420398@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1385,7 +1385,7 @@ static void fcoe_ctlr_recv_clr_vlink(str
 
 	while (rlen >= sizeof(*desc)) {
 		dlen = desc->fip_dlen * FIP_BPW;
-		if (dlen > rlen)
+		if (dlen < sizeof(*desc) || dlen > rlen)
 			goto err;
 		/* Drop CVL if there are duplicate critical descriptors */
 		if ((desc->fip_dtype < 32) &&


