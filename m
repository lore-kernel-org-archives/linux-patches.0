Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCC5335BD6;
	Mon, 18 Aug 2025 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523244; cv=none; b=BR07E1lUD0JYhBc0CvbMY6lFNsmiMP5pctva5U6oPLNxo6tdBubUJ2pdUewC3FSOUeDymwMQNfGHtYbdk021WCPKXQb9dKCn9+y6TDLfSCG/MLXSsfwQXGdDIVjlaTYfUKaXmVCJssrHBJzWX36XKxkTbj+SSj0fV6Y5NW2fO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523244; c=relaxed/simple;
	bh=rDmwndWNjmpZkeDs0sRpHuxQzLJVQcJ0EZa9mGM5SXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4QfoJkVs9YXhXMew4yNUykYGYEwEJZbHsxOELV/F17YfOk82Ab8glXlxD3/4Il2Ll8UCk2K+RSzlWkgTLTvzsCJNAgoIfdqAate9Xj1Sc7erR5KfYj4kR/1TS6poLjIu/rM7MGJOaBy06CpTDwxtk7U7uILbaDQnWJSgByAz7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwiu8uIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwiu8uIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D179C4CEEB;
	Mon, 18 Aug 2025 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523243;
	bh=rDmwndWNjmpZkeDs0sRpHuxQzLJVQcJ0EZa9mGM5SXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwiu8uIAh30jE2Bm7xSoIsL7/22fB29iFzo6Zcm81fLSNFzsj86Q1yeH0eYFWBP9+
	 ThRughGYymB/t0sKQTxC0acG/v2ddAts2LfH1eGIbHmKEvAe5UBE163CWuikkkWWAE
	 QiwLigFF7EDT/nXZF/VslN9HYTgnbKlVGzq/3JmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 112/515] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Mon, 18 Aug 2025 14:41:38 +0200
Message-ID: <20250818124502.666678887@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b720e04ce7d8..8be033f1877d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4337,7 +4337,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5



