Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912EA2ECE9F;
	Tue, 15 Jul 2025 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587743; cv=none; b=fgNHFvM2Wxmpo+LiBjEPxr1vSqbYgrxCwlbugpra2GQIxfi9fQaUptrPhTs4A2zCBc8pXP70v/GiKH9H+OnJd+47Xw8Ye9sCeZfRtnDTOdCAn4t30YiEhmH0fmGS7uzJ94DbrKEHKQnl+IzbHs52OmDxoYqw+WXoNEMwB2liK8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587743; c=relaxed/simple;
	bh=ThnFMDYm6JyP0RMD2Uod6fzc6P3fyKVLzb3MyY3RRLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCNAPC+eSOcBu5WL73mRN1ycDD/MFuQ0MbeLoKtaZJM2mOwskgvRwK3ENJMWl7j20dAxfDqr7H+zrxkUOyIgnDyZXDqF8hvn3h6t0j/vifTaZrTu+m1b7Fu06YXSfVHe9ixQ2v2GM8OdCJmG/Zy5ewzWDJNppnoIur7IdBPZa2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ql3cHWTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ql3cHWTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA8BC4CEE3;
	Tue, 15 Jul 2025 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587743;
	bh=ThnFMDYm6JyP0RMD2Uod6fzc6P3fyKVLzb3MyY3RRLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ql3cHWThrOrw7JJur2chuKny/7chzkqOpHlTmtizulCZrDUsT+7+aZHTKAeNdguMp
	 hdo3Vs60K+jhEuW1WFsygs68WomfXQHJ8w77Xzb+khdzTpDp3ag+14yzjF4Nyrmjff
	 cQ8tGCKBuaKUDafIKF6MXZ3Fgh/A0btADZLKRuYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 125/208] xhci: dbc: Flush queued requests before stopping dbc
Date: Tue, 15 Jul 2025 15:13:54 +0200
Message-ID: <20250715130815.949733761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


