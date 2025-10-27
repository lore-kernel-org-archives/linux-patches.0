Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7387328B41;
	Mon, 27 Oct 2025 19:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592001; cv=none; b=NXgaymK9LYaUmLHGTYpoZTMIALZx9x345DqXA/J6/A7+/+Vfkbzz/cYwVLm1mDAVR9EVYKIHGEjjRpuhdE2jgVIehJ456sGnokz/kuxXaTbfHnrXUcXyNuH6rn/YrZ4VxjCi4fEf3NMRVt/JGDGIDtnFvDDx0P1byaLVCqSzryg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592001; c=relaxed/simple;
	bh=3Qeg1WJwslVrQUTGDpSZcgysglo/MQug1B93l6siZxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0GzN6ABYMdTcPdNzaMXyQBsoMgtN8YhfPOBbveDws9kKa99xTwWeI9qwmpfD8HLS7+Yc8xVZKb+IhjzkTtb1ivFZa35/OFFuc+3aWrPLJYAKi5gDNPzEvwqbtfP1KRVaeTJcJHyS3b7iLb6XV9ZMjc6vDvCW2d8ZbWp/43+Fyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJ3/OaSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJ3/OaSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA144C4CEF1;
	Mon, 27 Oct 2025 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592000;
	bh=3Qeg1WJwslVrQUTGDpSZcgysglo/MQug1B93l6siZxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJ3/OaSoe/BwWYwN6p7poAJkqkCjpwTYtVONcO8yL6VOpEDw9BElXEHZLsdsBZGk1
	 ec2b1R1Z42AQtE8cvgr8VaX+bDh6AHXCMeCoXiCAmUiX86kV0UtlKd78PEemKsgye2
	 YG82j+U8vCbneXmiJP1AxnTC6WdzP2pOegs2hR8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 080/123] xhci: dbc: enable back DbC in resume if it was enabled before suspend
Date: Mon, 27 Oct 2025 19:36:00 +0100
Message-ID: <20251027183448.535039205@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1136,8 +1136,15 @@ int xhci_dbc_suspend(struct xhci_hcd *xh
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
 


