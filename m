Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871A6210F59;
	Fri, 31 Oct 2025 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919392; cv=none; b=touiDQOhTWpkvP3QLyTdoHBwsJAy7sXtih323v1UFFe1uHwZ3lhauvw37rsTIc59LE5ZZLgVlyyuSv2pcelH0zb0u/Fx1RpJKb5D5GswI9LELvDhKSHvJLBkWgMHoKpx+Ynt8oK0e1aMWucApbfIWgFmLtdc0fhgA0AAR16PJIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919392; c=relaxed/simple;
	bh=aiCGSWOwkOekE/ozFEOp6wa+rdKA5AWHQ1d6/d9htX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eX/zyAPUZS9zjqRXDBWNUV4a1+0nJeNxF5La4dRyCWVaPnF7BNTZwc6jO5IeKsVKqKTDs2E5lavWt7Y5vSg/qJi0IswMPCE0bhRypuRvAgnmXA4Z5SIlN2XOlcSpAizZqa9WNpIp4ab1QLEroGJhYCrOV75QAOyxRxZEVNjqrxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAHmfrOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAHmfrOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103CFC4CEE7;
	Fri, 31 Oct 2025 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919392;
	bh=aiCGSWOwkOekE/ozFEOp6wa+rdKA5AWHQ1d6/d9htX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAHmfrOMq/WiGHWlDwDI/fORtCxcAZyxFN6dXQAq5SplyGp306Qa/xozu3UAb+k3W
	 U6J9btYvJWbLgvqL3rSKJwUmUhd3ZR6UZkqegPwUSIO0E4U0eTgRjL/YEF7/Z2Mp/H
	 IGjwiZU0mhs4msBcDVsRg9Ita4dUb/rSs0lQs3Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 25/32] xhci: dbc: Improve performance by removing delay in transfer event polling.
Date: Fri, 31 Oct 2025 15:01:19 +0100
Message-ID: <20251031140043.055808267@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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
Stable-dep-of: f3d12ec847b9 ("xhci: dbc: fix bogus 1024 byte prefix if ttyDBC read races with stall event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -987,7 +987,7 @@ static void xhci_dbc_handle_events(struc
 		/* set fast poll rate if there are pending data transfers */
 		if (!list_empty(&dbc->eps[BULK_OUT].list_pending) ||
 		    !list_empty(&dbc->eps[BULK_IN].list_pending))
-			poll_interval = 1;
+			poll_interval = 0;
 		break;
 	default:
 		dev_info(dbc->dev, "stop handling dbc events\n");


