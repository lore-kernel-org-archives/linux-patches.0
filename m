Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B34F5DE3;
	Thu, 17 Sep 2026 17:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667812; cv=none; b=ttCA86K6OwxzEj6pm41tS+qH0RL7119Led3M2hZGkfP6kqlKdtP+pVO7oJmZY2xOKE20DPNepjNCQrZLu+PFkxg2tawBAO8nbMvVNMcJBD8JUoqEADzk+C2nKDereKZONz/6IegwgHcNCbiW/XGAP+FIpQ2dGwbG9RcxSXcQY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667812; c=relaxed/simple;
	bh=zyVs8kk22+1P6LHdYHMd6pvgjUOcKGo8Z1WQC/eNCR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7j4KVnjYKO5PxXf09fuzDahYxSSfBxdPoqvRJvb2oAnDD3GamSYar6Kmk8XdJlL+LMDYleNBi4de3niYp9ViX+LLB7+49a/TUuFwvm2pOgr+lq/Q+O2L/hxkYT/hnLi6seWFvkFw1m3W42PDjD/orYTfPUxTi6FIA35ArA0gKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvIRg95c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvIRg95c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAED1F000FF;
	Thu, 17 Sep 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667811;
	bh=KXyvtZ6e0H7iDgPAvUXS0N9GAV5tJDgn85qL1xvlwxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvIRg95cCXphRIT9gXdn9v8VhuAaqYVICPiDssrN1+O1fzjnU/KLfobNzsocBVIAb
	 8qY0/SURtXL9RufKXFVwTVh2DaLuW7/YLaiMUFYwP7rQ5wWk/yNVoNnstcprtrjtEZ
	 TXNdGU3cF+xdCk7WRE0N8hnCFL91mE7bzJD7s7GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0218/1102] usb: xhci: Improve Soft Retries after short transfers
Date: Thu, 17 Sep 2026 16:02:41 +0100
Message-ID: <20260917151545.051697875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit e765ab012f73717238c95ab9c34bfc3c767fa48c ]

A short transfer is a successful one, so reset the error count.
Otherwise, endpoints which always complete short are limited to
three retries per endpoint life rather than per URB.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260603091132.1110849-7-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index df2617f6b60b7..169c126067e87 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2613,6 +2613,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
 		td->status = 0;
 		break;
 	case COMP_SHORT_PACKET:
+		ep->err_count = 0;
 		td->status = 0;
 		break;
 	case COMP_STOPPED_SHORT_PACKET:
-- 
2.53.0



