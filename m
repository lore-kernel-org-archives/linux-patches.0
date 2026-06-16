Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860D04502F;
	Tue, 16 Jun 2026 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628843; cv=none; b=lODa19F15k180GOugY1BoGyRChjeDSw8s6t4HAwCwypxrV54YrbBnZFFqxjIrtWxJVzFcQcz5bOK4ZYAxpPGb7oO2/EOxzHLZ+lEzxiVuaIiq2XLkH+pgOI0wNAu1FaQy+3rjZ5aA9urjWgwSJUC4N9zp2K30ImYwuoDkDq8+YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628843; c=relaxed/simple;
	bh=Ne+HD3SgHY0VuGB6fJ67KkTjNGqaCpz1UgD3mOzVbvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYQrSOBDhxr9CIZ71Hl/12fFnQFxsMuIZzpZoysVmMZAYlD621moSF955ZSm1oU9REwO0fDNjzrZYbkZGC3lvhchHRXYo9Vr4lwkKe55Tnb2FN0P4VRt8CyFBCy65FbwQyTYnb8Ujnq84q3u0+B/J+FNCkG7aRc4a787Q95tDmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woNVJxem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woNVJxem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709171F000E9;
	Tue, 16 Jun 2026 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628842;
	bh=UANzWeRwokRAttfqj9zMhHXk6S1OSJbOaxpkzbVOKKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=woNVJxemcH8XIo0iSFqATgGB4WkHdkHe7HIHBvFmHtm4fRVn0NrWZpu9as5aQA0uJ
	 aJ6LRKpZ+JiN7F5HmMiZ2+fADjEKPHP7IfH9YxBHe//4aCZ7IXF2DMoysJ1r/K8uis
	 3yeHAiBgmDGs3BlSoWkA8aoNgt2/82CS0bndh1V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 172/452] scsi: fcoe: Reject FIP descriptors with zero fip_dlen in CVL walker
Date: Tue, 16 Jun 2026 20:26:39 +0530
Message-ID: <20260616145126.929478312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


