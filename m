Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5844F93B4;
	Thu, 17 Sep 2026 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664251; cv=none; b=u/oKJIT8u8gAkbs39vg6VdlgcxhqkZPvFzFWASF7FJLj5x7BkqLg711CnI5XEBVldL2wQpq32HK5JcFmNa0up8aR8CLoAVFUPBBr17thaM0ltM8vrvQEP0dv7p2d7PM1qusPba8bbogneXTe67rHs55uAuQ88kStp5bDH2v05u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664251; c=relaxed/simple;
	bh=XOuP2j0OHxQ8dLvw+drMPoR+l4vS06yW0uLBk0z5Luo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCeI+h7mHyqhzMJWaz+PQsoeUiTRxl26Gmm63kkFKCtDh32dJWvhsbyrUgBUp9utKDnJUWQCatEKQXe4JFDxmiiystoOkHkUex1fyIJeSUVNT8zNcw3f6oB4Q077cOtbj2mO5mOYukIkgk1lrvxjpFwD9FxutY105c0N7WqkhRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twjwEYFI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twjwEYFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F1A1F000FF;
	Thu, 17 Sep 2026 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664249;
	bh=CVj5HlsOqR2IpffAtO8MDHCT3RsF+zdNPx51LCftuaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twjwEYFIbHLueA4NiY0xZbUZj8NWwA7okk42nQDSLKkXJTQtTMnLFn7WoCs1dnRz0
	 iJfGE4cmq8AGuTMmU9lXSLPCM+x1MqVqGWRPXhF/doBcv9Qpwgzig+cOwRv8ZR9B99
	 Jb1QpbBay3k9e4Sy+HloobBbBGMXdHHHpXvQh4Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0310/1250] usb: xhci: Improve Soft Retries after short transfers
Date: Thu, 17 Sep 2026 16:01:45 +0100
Message-ID: <20260917151600.508868487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 71d292598de85..75f0e438f34fd 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2584,6 +2584,7 @@ static void process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
 		td->status = 0;
 		break;
 	case COMP_SHORT_PACKET:
+		ep->err_count = 0;
 		td->status = 0;
 		break;
 	case COMP_STOPPED_SHORT_PACKET:
-- 
2.53.0



