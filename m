Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A926B18A6A5;
	Mon, 27 Oct 2025 19:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592766; cv=none; b=sewTCr0nghIYoIiZiwu1AZsgjwjXxHGS6XPZsJ5H6LDvmYOmSbiVq1TLjlhRZZydwKxJSALG0BJNsa8/OO869DnsUn9RmA4Hsq8wxysQ4gKcpD3b2NLPkSsiosIcdmeJeGbh/1jqm1mgr7Inc1wf+2/+eYO1TTNktfG0JXM+fRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592766; c=relaxed/simple;
	bh=JnFPcnKf5afBsCYhEpK9sVNfxfAqxnI1R3U/pwXapbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ph3LefXPLIhTeau1uS1EpOvo5k4QBvl9O4pXsrTCqVVPB5SjN81ybaDACNvJBVo5YPMI/poaCqwvjPBpNLOcHs2+YVmRMsnj+6LrnFM7LnRm8GF/sghJZ9LpxllMfVQjgZjzyl5hQ7WiP8IfEYSkhYHXsbez5JUKIE+RIb+Msco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6LXG2zG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6LXG2zG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A56EC4CEF1;
	Mon, 27 Oct 2025 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592766;
	bh=JnFPcnKf5afBsCYhEpK9sVNfxfAqxnI1R3U/pwXapbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6LXG2zGqxpAxpX2SdtS4bB+Ld6f9jfLHo/ar793CpaBjom1agsfAaNPDPrcloeAL
	 jtYd/JXnsj+HnH5wQw7dSrTk7ZIEJEFPzlvyCNzLI2YOuJCihp0/uqveR7yqN5qMWV
	 uwS8Ad/1KZ9rR+M98nQea2eZ6LCwCmvY6js0ykAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 64/84] xhci: dbc: enable back DbC in resume if it was enabled before suspend
Date: Mon, 27 Oct 2025 19:36:53 +0100
Message-ID: <20251027183440.518873566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1319,8 +1319,15 @@ int xhci_dbc_suspend(struct xhci_hcd *xh
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
 


