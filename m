Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1FC340D95;
	Tue, 26 Aug 2025 14:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218913; cv=none; b=LHn+mbFfeuqc0XfvmTFVMlHDpvFFxZFuQYrb5E2u/mtgOXUlghtnrG8jGNGK26OQWpXfhNN5n+8bA0u6lgK+Hr837rOtDb+fDqCee6B0bPZyJVsCLFXhBKd1OLBPzLvFq8ybdFZIVkV3w7F5lE7/eBGQBH/DjyEPEMKUxECMQsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218913; c=relaxed/simple;
	bh=ygSHcBORPv1vGrw8+IY53VMR7nAGWoavgQkn20/bFq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8G7Uk/ocZgoJexTyCwtX3Qv5//6I5NEyxhYqw24geOnCnlFdXk6dfL1uop1+XZAKLuJMOQeBfLzsoC3g9AzNhgd/WifJ9wOwE19fGD0r2lhSh6bHdd/9sso16Edjkat8Aw9vw9VsESZK5i1X38fVt8xzRqtm5q+BUawpSoRdz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10M5ozh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10M5ozh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ACDC4CEF1;
	Tue, 26 Aug 2025 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218912;
	bh=ygSHcBORPv1vGrw8+IY53VMR7nAGWoavgQkn20/bFq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10M5ozh68QzrT5buSUlbl/5uirw6/UxBlubAiMbnnMeyfdNdEp/EITuTxMYUlm+YY
	 N7xYg+smfYaTMs7UjmfOOPg3tBmP0/cawnAEk4uD0YX+qBe5f6uPr25AXDYQSinUSe
	 MM2tAIjcQTZLlInE0BUT8sT3jKeXXuyofetEjK/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/403] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Tue, 26 Aug 2025 13:08:26 +0200
Message-ID: <20250826110911.854693637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 7919407eca2ef562fa6c98c41cfdf6f6cdd69d92 ]

When encounters some errors like these:
xhci_hcd 0000:4a:00.2: xHCI dying or halted, can't queue_command
xhci_hcd 0000:4a:00.2: FIXME: allocate a command ring segment
usb usb5-port6: couldn't allocate usb_device

It's hard to know whether xhc_state is dying or halted. So it's better
to print xhc_state's value which can help locate the resaon of the bug.

Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20250725060117.1773770-1-suhui@nfschina.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 08b016864fc0..71b17a00d3ed 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4076,7 +4076,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5



