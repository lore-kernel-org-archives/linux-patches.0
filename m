Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4A02E540C;
	Tue,  8 Jul 2025 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992547; cv=none; b=f70DGSLjKQG6NHEePmE4Ip8xJJfxSV7E7IyvZbkAuPKGsvfUAayFbgyg8Zonefxo3VA/DUfJdZqBmNN4jpteSPC6dKwwTmgAm439kU17/WQmTMy7+gcwsjAtcovRBENHirHP0pB/5bFHGxboKNpdogkwMhFMUASYlRYXBOvo6bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992547; c=relaxed/simple;
	bh=R76SUBnWj+1jLd5W+sLoBhX/zM3FwASZmWfEhYF906o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYilPQbKLgFeVsONXxO+FTvrtwXL3VosDbFBZoFTXrTjyA2WxiXV302UeBjjFt7dQQSS7gPWRCrR3ojvRi/1YIFb6vULdApq/z3s7Fla0vz1VDiK0Ex63dop4dE+BxpEzPgyY0Sgu2D3RKyayWQn/pYiOhIh0mRX2PPVnnLxox4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qy8hmPGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qy8hmPGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0584BC4CEED;
	Tue,  8 Jul 2025 16:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992547;
	bh=R76SUBnWj+1jLd5W+sLoBhX/zM3FwASZmWfEhYF906o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qy8hmPGX8aOWe2bIXW/Kb2zoQE4T+pHa0h4pvEn1YB0hWX6XyJS0hd+awSqVCNOGA
	 ZjpESF6hphTL0j3NLEixkr/4kYXJQuthjsh/6XBzTFA+fyf2uMfIwmjSCNLydgSZSn
	 uWLwPCfoC4GSlKGKBVC2oPcDgk37yG3lV1C5Z72g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 111/132] xhci: dbc: Flush queued requests before stopping dbc
Date: Tue,  8 Jul 2025 18:23:42 +0200
Message-ID: <20250708162233.830538683@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit efe3e3ae5a66cb38ef29c909e951b4039044bae9 upstream.

Flush dbc requests when dbc is stopped and transfer rings are freed.
Failure to flush them lead to leaking memory and dbc completing odd
requests after resuming from suspend, leading to error messages such as:

[   95.344392] xhci_hcd 0000:00:0d.0: no matched request

Cc: stable <stable@kernel.org>
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250627144127.3889714-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -639,6 +639,10 @@ static void xhci_dbc_stop(struct xhci_db
 	case DS_DISABLED:
 		return;
 	case DS_CONFIGURED:
+		spin_lock(&dbc->lock);
+		xhci_dbc_flush_requests(dbc);
+		spin_unlock(&dbc->lock);
+
 		if (dbc->driver->disconnect)
 			dbc->driver->disconnect(dbc);
 		break;


