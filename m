Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9E12F657F;
	Tue, 26 Aug 2025 13:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214245; cv=none; b=L27HK0CC8OKgNVpPqO+Blme01t1WQgRfF3aWo8P+deZ/cN+VTuWJIDgNiOGkmjD2gBVtvlxjwemxaUetW2NA5CutLBuI0dEZT6O49UstAYnSENpzqjavyN5FOYHUXm8IQEgLFyGLmLncJ3sIhrX/a4F3ZvJmLkeCM4hAchsrC6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214245; c=relaxed/simple;
	bh=HlWZap5rM5kvY9YmhjMkNJONjVUtUx8ERfJAF2yB04Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii4DW80OEiKtOy4nfJL7SVjqvzv6wSgpDZaui8xN8L4MiIXLNfjiU5MK/aO62xStdGCA0oO9zT3zcGcSKmyqTCTiWPQUQEDyHkaCZillc8EQncy7qx03SytlluiQ33kNQp2ipEA/RKobAj8AqCBNZdPb7hyuBnvpXOLmwPpxJ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVIzCnUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVIzCnUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA46C4CEF1;
	Tue, 26 Aug 2025 13:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214244;
	bh=HlWZap5rM5kvY9YmhjMkNJONjVUtUx8ERfJAF2yB04Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVIzCnUMmVMcNa3T+fZgJt62M3Qfrrhjyiq7PqCFS13tUaGHlnjeHXTHarsFxOrFN
	 VAhrg0PC6ah8RacuCVxAb0eWewJKTUpsnv+5s/gSN9tJQ3lrGBfgAhPe7o+jwJe8Jb
	 vHhdnZYjkHzqGp3byDFts1r8KmGC/8cqOSgo/+80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/482] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Tue, 26 Aug 2025 13:05:18 +0200
Message-ID: <20250826110932.434114805@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0862fdd3e568..c4880b22f359 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4421,7 +4421,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5



