Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340B631A811;
	Mon, 27 Oct 2025 19:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593023; cv=none; b=RyT60JbGXUF6IVW2WaUnoNRi9Z3zz7U8CFYZKyxfSdYQmWTLSlyX6qCZhF3x7kTj3orfWwn3fS9Yz57v43jtmxn+CIRfhX+Vs9ZTfol7/1g0kZXFaFaw3Bwld0LSXgSluhGEurMKodeV92KbdZ1bnRhXbguD/hQd1zrc1FL+zqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593023; c=relaxed/simple;
	bh=7zk9wuL/KShE9P9mFSowKjQ+2vriNPGBPCSiA8vqsG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gl7o9JiXLLqZs41wwqOLS2Dqz6TJoWqdfC5sCVKHW918qON8s8Sf6XJ2B7LPkFlrPONANkBA/rh+3IgIweF2m5qOJTCfGxH8FRqTP1pdwW/LucSYLAo7bcyBW4wDUtyqx12J5Gol8iVW1u0ucYM/FIVyWK/LSIXYD6Qn8/M+gI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j67iOvPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j67iOvPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA67DC116B1;
	Mon, 27 Oct 2025 19:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593023;
	bh=7zk9wuL/KShE9P9mFSowKjQ+2vriNPGBPCSiA8vqsG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j67iOvPs3dgmY/IqFutEoaq3pTgGwUTnrNR4MOjN5oO2AgPi7FnU1xaeOXKck7NSY
	 hbtrIgzsy1Kbf8P8AaVraP0cKk8iA8UbBwk9quw2H8/P+K6FWEfr22We6LFN0t4t7H
	 OSZ+LoK9isOwO0lbuLjAi65v3F7C2jq0y4sHMovM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 099/117] xhci: dbc: enable back DbC in resume if it was enabled before suspend
Date: Mon, 27 Oct 2025 19:37:05 +0100
Message-ID: <20251027183456.698370310@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 2bbd38fcd29670e46c0fdb9cd0e90507a8a1bf6a upstream.

DbC is currently only enabled back if it's in configured state during
suspend.

If system is suspended after DbC is enabled, but before the device is
properly enumerated by the host, then DbC would not be enabled back in
resume.

Always enable DbC back in resume if it's suspended in enabled,
connected, or configured state

Cc: stable <stable@kernel.org>
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Tested-by: Łukasz Bartosik <ukaszb@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -1387,8 +1387,15 @@ int xhci_dbc_suspend(struct xhci_hcd *xh
 	if (!dbc)
 		return 0;
 
-	if (dbc->state == DS_CONFIGURED)
+	switch (dbc->state) {
+	case DS_ENABLED:
+	case DS_CONNECTED:
+	case DS_CONFIGURED:
 		dbc->resume_required = 1;
+		break;
+	default:
+		break;
+	}
 
 	xhci_dbc_stop(dbc);
 


