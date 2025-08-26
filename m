Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B9F34F490;
	Tue, 26 Aug 2025 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217645; cv=none; b=EgQkfZJZO+kAy+VmeVKTHpzKCsg7IDwIyawSjQLwmv8x1rygNk+Go/k6PmFXFexKbXDNxKJp1ga+LsYlFBz63g1iP7m1i61PONB/2FEHX+mh6J0cHx7BZInlpP+OeWBE1Ydy0yQ+uDPakkTGjLw/WK+s+Dg0Sx/eud05pEv3Nxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217645; c=relaxed/simple;
	bh=lsFx3SB3CmxW9iuvx9kAJu/QcU7twZyQKb4tdWtbZOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAwHIfUYKL5uRK2yIA/Mr2sDFowJlP0KhAX6XjOSW4owFQAlOyAUToU9J74l9G/y4hjZ5aUDjlKGJ/eRWroyvmADqRIVv6O/ETdglAZxoEmW5KrMObjV6YaByBIrjwaCk181Vf2OcL/f8VohoNJcv8OaH2bo1g+3E6i3W7O3rGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6JLYmRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6JLYmRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54049C4CEF1;
	Tue, 26 Aug 2025 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217645;
	bh=lsFx3SB3CmxW9iuvx9kAJu/QcU7twZyQKb4tdWtbZOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6JLYmRdXRNgY2XUlVwoJ3bA6EQD/c+SJlcMpN5JDlWm8MjAWox/M3NI71f/yBrGZ
	 8dT5BfpEfznecatThNAGNGxoslV076G8Sw/s6matr+uTiMxTewXP0TEQHRNwuZIsGp
	 y1PNv/JbPEKOqGN2QBX1J99/qbeapEe7d/99dvEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/523] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Tue, 26 Aug 2025 13:07:11 +0200
Message-ID: <20250826110929.910940399@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 954cd962e113..c026e7cc0af1 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4183,7 +4183,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5



