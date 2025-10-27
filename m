Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FEC2BDC13;
	Mon, 27 Oct 2025 19:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593525; cv=none; b=AN2wLENGGmprZdQ/SXrnLyA9rqR8kFlj6A3jY1dcinXTh1sK5LMzu2XQqThbVDwvW/FZIPap2VI12zmwuzG8HcivVo2ygMPodG/1Wxez7B5me60BLy5hcVmN58feaoptnXUUDb04HNRtm07RmO04G4cCKNmF2+6wFZhixMkGmVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593525; c=relaxed/simple;
	bh=69SpiKekGjVbnB1SQWyraolkDH5mqAj5XdktBsheCBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DHotTsurgKHVABCQm1W5g7+xlwHC9Hrtjt7K85/XqT/Tz2aWWBLYCIq7+zE6Svoa99aZh8lDZv5BPKTRM6hCWcYd68tj9GlKVMwa89/tG2HBw5kBXTt1nTIT7dXRpF2nOarq4TZdzYlsRAvFrmCMSuUREVSxFs49nsJXQh3//2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOW5VL59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOW5VL59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC496C4CEF1;
	Mon, 27 Oct 2025 19:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593525;
	bh=69SpiKekGjVbnB1SQWyraolkDH5mqAj5XdktBsheCBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOW5VL59rFGA/C7BUhcQn4rvhosvmR4pm903PJ8BVheF/XXmMAiJXAClQRoigAXYE
	 uzaXE4esdKKtuz5oNBFZxkAOh1YRajFvNaewTv8Ep9MuFxwYRknzuhAwcPn3hlIYg1
	 blEEuzrUD7nSrrAbd4DFJWx1gM8AbNIqTr6N8pYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.17 154/184] xhci: dbc: enable back DbC in resume if it was enabled before suspend
Date: Mon, 27 Oct 2025 19:37:16 +0100
Message-ID: <20251027183519.076883329@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1390,8 +1390,15 @@ int xhci_dbc_suspend(struct xhci_hcd *xh
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
 


