Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A742A1B78F3;
	Tue, 26 Aug 2025 12:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212738; cv=none; b=MQ7oa1EEAYeMGOb0EtPGN1DHxgQmeC702+y6egtVO24Ki0F1GxjYyE1M3niplExjCVoNi9pZK9H4xxybMNXs19jB7t089J6iky17rFm5Ppeqiw+RLpqvMcYRrqvbqYHygYq6RXCJbBQMwy/prGe3phUuRKjbEszCzWpFApCCSms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212738; c=relaxed/simple;
	bh=GSzkq3xgRYvEIh7X65gkJOJccH1iduCsdbGZ0Pd6Lck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clyUXBM6F8yR2VEZ9UzXfNx09JOg+4nM5BG5jo4WhsBvcKQbAGCMk0z0jmJXYpHqJ6jqYYSGR0ke6TJWRioA1ce8zOLMNDyx78CcTSgmFUXTqGTz0aNtbdFU1ua6E7e0U32GMUWo+6S498/LZo5LFcaFs6ijabrIPazVh5+e+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBNWUUq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBNWUUq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36081C4CEF1;
	Tue, 26 Aug 2025 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212738;
	bh=GSzkq3xgRYvEIh7X65gkJOJccH1iduCsdbGZ0Pd6Lck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBNWUUq+AY3V/ms4wOuiVLpyHMTFqaRh/7dynXSydSmKQJwtJvc3MdbDlsswfYx8R
	 4rmTXzgBuRpKkSbTXul7HAC3m/2mwImuDwn81T7toSBu184hWEwqRmvHH5MTb5WRhA
	 LksTpSN26lZRPJWeoNokUAHyd16lY2WR1OhPsjL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/587] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Tue, 26 Aug 2025 13:03:52 +0200
Message-ID: <20250826110955.045530930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 44352df58c9e..c6d89b51c678 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4454,7 +4454,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5



