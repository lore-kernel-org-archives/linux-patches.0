Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84BE3D9030;
	Wed,  8 Apr 2026 18:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672703; cv=none; b=e6+BDMPV850JwWemNpJVeMuCtELff8SfpY8gIJBWIFgUZ8TcGDSc246oDdHpkZPjQXmPp4UvvOfGrO0HCDvaoVeRR6m2eDNx6Z30TBjIgi/Yz1MRsTOb2K1y/LQwicXHSKaSDNtOwmR4+3NQbaBiMDWKosft1Np5qkKADa9SCo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672703; c=relaxed/simple;
	bh=nb1QB949U8MLkllMPlQlWV7z4ZTywN7rFryxOEoyxAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOSRm3kjs+Jyt4aU2/ClSyBcttJgNK7EIwvPOmdoEGVRGY7eczBBs3n6Sl80LDz8/GgapcOG9zygYAxPGQPm29O3RyuLcSIRSfiZIHfCQiMfkYk+SrHc39zwumeWGeJXr+NBuFLGPC9vbhZ+yHkseeLTB+qJ8IXhp0fIqALzMHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weIGx8OJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weIGx8OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA2C19425;
	Wed,  8 Apr 2026 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672703;
	bh=nb1QB949U8MLkllMPlQlWV7z4ZTywN7rFryxOEoyxAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=weIGx8OJZr9Kh1rU5aaaaUtrBp+vcftU3ZwROdoMAee6o/wJcOSHhLjdTOkOb9Oot
	 Pb1cB3W8EjUYaDuZerDwdYwVqA7mBPz0uGGisOa/eDmeESdIvBTgECHieFGwRfDRHc
	 /LkFLR1LuGlT5M8yqxmwbm6qe+nH9r3Q2//NABno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 110/160] usb: cdns3: gadget: fix state inconsistency on gadget init failure
Date: Wed,  8 Apr 2026 20:03:17 +0200
Message-ID: <20260408175917.287994658@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Yongchao Wu <yongchao.wu@autochips.com>

commit c32f8748d70c8fc77676ad92ed76cede17bf2c48 upstream.

When cdns3_gadget_start() fails, the DRD hardware is left in gadget mode
while software state remains INACTIVE, creating hardware/software state
inconsistency.

When switching to host mode via sysfs:
  echo host > /sys/class/usb_role/13180000.usb-role-switch/role

The role state is not set to CDNS_ROLE_STATE_ACTIVE due to the error,
so cdns_role_stop() skips cleanup because state is still INACTIVE.
This violates the DRD controller design specification (Figure22),
which requires returning to idle state before switching roles.

This leads to a synchronous external abort in xhci_gen_setup() when
setting up the host controller:

[  516.440698] configfs-gadget 13180000.usb: failed to start g1: -19
[  516.442035] cdns-usb3 13180000.usb: Failed to add gadget
[  516.443278] cdns-usb3 13180000.usb: set role 2 has failed
...
[ 1301.375722] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[ 1301.377716] Internal error: synchronous external abort: 96000010 [#1] PREEMPT SMP
[ 1301.382485] pc : xhci_gen_setup+0xa4/0x408
[ 1301.393391] backtrace:
    ...
    xhci_gen_setup+0xa4/0x408    <-- CRASH
    xhci_plat_setup+0x44/0x58
    usb_add_hcd+0x284/0x678
    ...
    cdns_role_set+0x9c/0xbc        <-- Role switch

Fix by calling cdns_drd_gadget_off() in the error path to properly
clean up the DRD gadget state.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Yongchao Wu <yongchao.wu@autochips.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260401001000.5761-1-yongchao.wu@autochips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -3431,6 +3431,7 @@ static int __cdns3_gadget_init(struct cd
 	ret = cdns3_gadget_start(cdns);
 	if (ret) {
 		pm_runtime_put_sync(cdns->dev);
+		cdns_drd_gadget_off(cdns);
 		return ret;
 	}
 


