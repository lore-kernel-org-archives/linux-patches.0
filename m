Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063282;
	b=eIDCDsL/AUf+/FY4LyirtzxZ7WvmPkhLWL++wYcyMzvaFBRX0hrgF+cQP+0M9k5pI+4g
	 wuj2gjabNLqQVhCChIKk/s2eL2XVhAwdSHqnWAC5HTiiddpVSkdYQwgvGMM4qV1FKwHg2
	 O++feNIQAo49PgM8m3PFI0t24pCIoeJ++LM798qTVPow56VJz/Nmc6UHaLnzYiivL5pIn
	 WZSSFISgrRKB6gZ9+lXHPDb/bF1MUfv+hHkFEEZXnbTvbXaPkpPJ85SeQLoW8SzZ1YCSg
	 VU9QBkAO6+ui4Bf6wZSOX9fkRreWWW5vksUtcXJtb24EuDdycWXieq/e2RyW+P1nZ3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WJpKPgFfeshsJ0lnO44fSvr39LsbaEp+4yqr1m/EyIU=;
	b=WAZdR/2o3E48o4gvzht8MsmW+JmPGxT9i8zvnIVF4aQD3dz9SJXsfPM3XSkSx8lGooaj
	 xkpWhqvOSNFaB1PttYO1okXKK+cYSN6symBASKx28TpSPejkUhkIUHnI4M7whCix/46GH
	 49szRWXhtHZJtTdaB8itGQAUYlCwY0lhnwCZgCbRUZdFcozhPTkR+mgWhRmKN6YVrITw9
	 ZnNTaWsl5dH6AJpkVEmVtm4Q4L7GBPervHcKW7m0NqmQgK6KUORXU+y0cWVLuTFAPkepZ
	 joLgfsw6UWL+ivMibzGaTz4Q3dwrUnqIpmaL2psTVovs9hZj5bY+mi7c2iN6rail30g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TktNeLGM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38363606A32D;
	Sat,  7 Nov 2026 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TktNeLGM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE611F0089F;
	Sat,  7 Nov 2026 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063282;
	bh=WJpKPgFfeshsJ0lnO44fSvr39LsbaEp+4yqr1m/EyIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TktNeLGMV82sf81IEU59KRk0WD63nNkJ6mW4f8JKW3krdxTgZpP0FW2yXfiVOi9/W
	 GAI9uKCGWO8tPZgRkVtdBgW5QF4LzCAZvxoDijZjy8Y1fIkAB3/Ugey/hH/7GE64BP
	 ib/xj3I0SkvBWojKFaTRITVWrb6YViZY5/6NoZS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/869] xen/pcifront: check that an AER callback exists before calling it
Date: Sat,  7 Nov 2026 08:52:01 -0500
Message-ID: <20261107134908.659347229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 3b4854b69ee70fffb2fa7acac09e715a7efcbae1 ]

pcifront_common_process() handles an AER request from the backend by
dispatching on aer_op.cmd to the bound driver's PCI error handler.  It
only checks that err_handler and err_handler->error_detected are present,
then for the mmio_enabled, slot_reset and resume commands it calls the
corresponding callback unconditionally.  Those three callbacks are
optional -- the PCI core NULL-checks each of them individually before
use -- and many drivers (for example igb, igc, ice and ixgbevf) install
error_detected without all of them.

aer_op.cmd comes from the shared ring, so a malicious or buggy backend
can send XEN_PCI_OP_aer_mmio (or _slotreset/_resume) for a device whose
driver leaves that callback NULL and make the frontend call through a
NULL pointer, crashing the guest.

Check each callback before calling it.  When mmio_enabled or slot_reset is
absent, return PCI_ERS_RESULT_RECOVERED so recovery proceeds, as the PCI
core does for a missing callback; returning PCI_ERS_RESULT_NONE would
instead make xen-pciback tear the guest domain down.

Fixes: 956a9202cd12 ("xen-pcifront: Xen PCI frontend driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261006023443.338194-1-yhlee@isslab.korea.ac.kr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/xen-pcifront.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 11636634ae512..451476ce10ae9 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -599,11 +599,16 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 		case XEN_PCI_OP_aer_detected:
 			return pdrv->err_handler->error_detected(pcidev, state);
 		case XEN_PCI_OP_aer_mmio:
-			return pdrv->err_handler->mmio_enabled(pcidev);
+			if (pdrv->err_handler->mmio_enabled)
+				return pdrv->err_handler->mmio_enabled(pcidev);
+			return PCI_ERS_RESULT_RECOVERED;
 		case XEN_PCI_OP_aer_slotreset:
-			return pdrv->err_handler->slot_reset(pcidev);
+			if (pdrv->err_handler->slot_reset)
+				return pdrv->err_handler->slot_reset(pcidev);
+			return PCI_ERS_RESULT_RECOVERED;
 		case XEN_PCI_OP_aer_resume:
-			pdrv->err_handler->resume(pcidev);
+			if (pdrv->err_handler->resume)
+				pdrv->err_handler->resume(pcidev);
 			return PCI_ERS_RESULT_NONE;
 		default:
 			dev_err(&pdev->xdev->dev,
-- 
2.53.0



