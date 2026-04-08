Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C13BB67E;
	Wed,  8 Apr 2026 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672299; cv=none; b=m3mmOcOGNvWWSchZbeJ45mt9dWjvvk2CflQTqa8ce/okt26gBoc9ZSBsAnVdpIfsMtC9I2ozwpSsM0hY2aDqUmmI9RBO1t0XEyGWJzzRSHCPqlDozLNByJ1ZvJjRCsbZonZsTRa0q8d6LTvG6LNvFBxirclI45EGd3+EL9O1rME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672299; c=relaxed/simple;
	bh=HeM7lOONMK8U97hNeO7z6h5Xqsgnp9J918Wb++k7nvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpePpXnteUUqjL3N3afRDEjTgy1DgQnC0t49cGmeguHb88sfEtSYRK66DqqaqluGN1dfzf+06I81zzXCsDbs1xKbhlIsu2+1XpqWwqUtDtzN7KpV1KMMeX2BqEq8WMPAo3qhmJg40rSwTVhppaoGWwQZaYN4TAsb1bbIQ85jybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trydlNq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trydlNq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54EFC19421;
	Wed,  8 Apr 2026 18:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672299;
	bh=HeM7lOONMK8U97hNeO7z6h5Xqsgnp9J918Wb++k7nvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trydlNq0HoP3NJaGfP+m1wAQVaSsRJw2tHJdcTP+VezjyEMgIoN/gs8txs7DYCPfS
	 kpvnycoTrPH9YrLw6iAplxYzNSKIFaK6FwNnhNrpXyhq+kamP65Utgn68qxmZ7S272
	 bNzERyUpkj5VgmfIeVlcvC4Mkyiy2BvCBAcna6QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 233/312] usb: cdns3: gadget: fix state inconsistency on gadget init failure
Date: Wed,  8 Apr 2026 20:02:30 +0200
Message-ID: <20260408175942.456903924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3427,6 +3427,7 @@ static int __cdns3_gadget_init(struct cd
 	ret = cdns3_gadget_start(cdns);
 	if (ret) {
 		pm_runtime_put_sync(cdns->dev);
+		cdns_drd_gadget_off(cdns);
 		return ret;
 	}
 


