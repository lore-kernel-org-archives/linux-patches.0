Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28CD242907;
	Tue, 20 May 2025 14:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750034; cv=none; b=RrcX7PKRLJ+VXl6L3MsaObhusTHC67sY/X7nrvzWzo7bOk2CKZ3+o437StgN78h5xeQIQB9L42aVGNAEp8hJC2b66d6VuL7BTyO0g+BIaj2lB740h0Fx9dqj2PyjPgISMYUu2ezBpdXtj76zYZe0lWr2bLuqs5VU20QWvJI0+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750034; c=relaxed/simple;
	bh=uDC30n3SAollFF5UrP+CLspnfRrvheieKqrQnnIptsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ni0CROfuq1ThKvUCBjNeiV8Xa69PWmDgrsFbSqDxu6GdLAHe7cY17a7j7IK7AFWw36Jr+OSFKhvrhb7mmTiShahNlg4xnUnIs63VWVYc0iXOR4SGW67dKJ6YmWK+Kxyq3Y5qPOurxqJZMHWFQe1LFoLC6NeOu3zs2xfdYg5+4yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btBhoUVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btBhoUVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E66C4CEEA;
	Tue, 20 May 2025 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750033;
	bh=uDC30n3SAollFF5UrP+CLspnfRrvheieKqrQnnIptsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btBhoUVw8c9veSbcB4HOli/ca4TnbCO04KG+bS5rsGHPMHUXb2R2m6tafMM0gaxax
	 uJxfXc1INFfq/4/w9y8U7AUdj9gSgM4cqqWddrcwsUyViDIJB0x4/fD1lu3AIsHlvX
	 dm4B1/4ZFytSOQeV5aPCjOASAqX4/Ki0G/X/fmXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/143] xhci: dbc: Improve performance by removing delay in transfer event polling.
Date: Tue, 20 May 2025 15:49:36 +0200
Message-ID: <20250520125810.889634705@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 03e3d9c2bd85cda941b3cf78e895c1498ac05c5f ]

Queue event polling work with 0 delay in case there are pending transfers
queued up. This is part 2 of a 3 part series that roughly triples dbc
performace when using adb push and pull over dbc.

Max/min push rate after patches is 210/118 MB/s, pull rate 171/133 MB/s,
tested with large files (300MB-9GB) by Łukasz Bartosik

First performance improvement patch was commit 31128e7492dc
("xhci: dbc: add dbgtty request to end of list once it completes")

Cc: Łukasz Bartosik <ukaszb@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241227120142.1035206-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: cab63934c33b ("xhci: dbc: Avoid event polling busyloop if pending rx transfers are inactive.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index 241d7aa1fbc20..6b239b3770d15 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -954,7 +954,7 @@ static void xhci_dbc_handle_events(struct work_struct *work)
 		/* set fast poll rate if there are pending data transfers */
 		if (!list_empty(&dbc->eps[BULK_OUT].list_pending) ||
 		    !list_empty(&dbc->eps[BULK_IN].list_pending))
-			poll_interval = 1;
+			poll_interval = 0;
 		break;
 	default:
 		dev_info(dbc->dev, "stop handling dbc events\n");
-- 
2.39.5



