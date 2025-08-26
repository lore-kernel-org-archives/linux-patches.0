Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6407D3469EE;
	Tue, 26 Aug 2025 11:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207880; cv=none; b=XYPqOL49hHujKEWcaw5EswT9ItIJH2leSP9GaAvRXKy+cBbtWDfUmcxHjCapKmYS6vIdK7torYZfDGdFWs9s7u2rynAFp95gT1veuILTophLPtHnIBoXtD1CG/WejQhDzPpX3KIA8xGAhaTBdiqNCK+AJCG2DFJlgN4DtUmg3Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207880; c=relaxed/simple;
	bh=FktMn8yBIRbOzavJpqvZgdkB0C52lW2XgNVjkHSYk5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7YDZB/h7xiRsdkiK7QKG7mixoxltUZWojDYZDdfqLRFs0VI64QlDfPlBsqM/dhIKOD6UKUZeTvG/dZ6XLeMjVr7VJNaGJsVBPuGmuxyzk8CmbDckvgTQTto0RFHHfTSW+JLDFsXVDEhE6MAPukXzWwCSFc8Y68zXpJ7cDQM5kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwrHnlsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwrHnlsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9137C4CEF1;
	Tue, 26 Aug 2025 11:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207880;
	bh=FktMn8yBIRbOzavJpqvZgdkB0C52lW2XgNVjkHSYk5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwrHnlsRzSk0wdGN9sJsRfwt6DuMNTE6ysXSV2wVEnC3876SFJqppjvt0gbM6vUrh
	 S7j7IrWveLjmLOMRWzCduPABLpA8tP2/pNDETJ5+S6QqQN9MsRXhNAAd62u8a5rziG
	 DwOgH8MYQ3IeNdl7SZ7LhDAMIRY7ezQq2B7dZknQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.16 322/457] usb: xhci: fix host not responding after suspend and resume
Date: Tue, 26 Aug 2025 13:10:06 +0200
Message-ID: <20250826110945.310016167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

commit ff9a09b3e09c7b794b56f2f5858f5ce42ba46cb3 upstream.

Partially revert commit e1db856bd288 ("usb: xhci: remove '0' write to
write-1-to-clear register") because the patch cleared the Interrupt Pending
bit during interrupt enabling and disabling. The Interrupt Pending bit
should only be cleared when the driver has handled the interrupt.

Ideally, all interrupts should be handled before disabling the interrupt;
consequently, no interrupt should be pending when enabling the interrupt.
For this reason, keep the debug message informing if an interrupt is still
pending when an interrupt is disabled.

Because the Interrupt Pending bit is write-1-to-clear, writing '0' to it
ensures that the state does not change.

Link: https://lore.kernel.org/linux-usb/20250818231103.672ec7ed@foxbook
Fixes: e1db856bd288 ("usb: xhci: remove '0' write to write-1-to-clear register")
Closes: https://bbs.archlinux.org/viewtopic.php?id=307641
cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250819125844.2042452-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 0e03691f03bf..742c23826e17 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -309,6 +309,7 @@ int xhci_enable_interrupter(struct xhci_interrupter *ir)
 		return -EINVAL;
 
 	iman = readl(&ir->ir_set->iman);
+	iman &= ~IMAN_IP;
 	iman |= IMAN_IE;
 	writel(iman, &ir->ir_set->iman);
 
@@ -325,6 +326,7 @@ int xhci_disable_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
 		return -EINVAL;
 
 	iman = readl(&ir->ir_set->iman);
+	iman &= ~IMAN_IP;
 	iman &= ~IMAN_IE;
 	writel(iman, &ir->ir_set->iman);
 
-- 
2.50.1



