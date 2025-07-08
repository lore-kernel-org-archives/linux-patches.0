Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44AF2DA77B;
	Tue,  8 Jul 2025 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993644; cv=none; b=PBvfbP7yRpJD3S2OfAhA0K5u/LsUrKByEJFhSkUiLidyKV3uR0QEHiqoy9hDnaNS+LYVlgSNy9aBfFPtuuYtalV2ol8+J1QyHfrKre8KCJ2mTx7ZURMJ6UckuASns3MmxNkKQHjsG1JzqNoFe9EuC4RCMF1Ch48GXaByf8Q1McQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993644; c=relaxed/simple;
	bh=FCcN88b4M/E+3p/N4nOfxXFpDOS13/zmEF+PbNDV1Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8B5i8Tu4wenHAs3xeuPz8ujlaMv8MyeaBx+chrFIfeKN4yaJG/9cY0FpYTEciLPP2W6AxBsnrZeE1dNOFH+/E4nBD1cttBmEB2igzSURJwLhyTaBtQi1Z+1Svjy1DZYT7LuMD5iTDWlM76R655sBqDn7TTIsu1IyqMIkN1bUWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Js+vd2lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Js+vd2lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294F2C4CEED;
	Tue,  8 Jul 2025 16:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993644;
	bh=FCcN88b4M/E+3p/N4nOfxXFpDOS13/zmEF+PbNDV1Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Js+vd2lRtUmN6lq1ay1X1mk2DHVTCggGpuOAAOU/o7Urb18OujZL93fUYG2h6PX6P
	 eGQ7d+zRPNBImBzEflN/0GW8WTs7IKSMamiTxYInzHpzneRJNP7a8cZ+xRj6pRlqQZ
	 eHRO8SDKzSXTLvfkf28nEp4fES3eJTZHcdx6vL7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.15 145/178] xhci: dbc: Flush queued requests before stopping dbc
Date: Tue,  8 Jul 2025 18:23:02 +0200
Message-ID: <20250708162240.317284993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -652,6 +652,10 @@ static void xhci_dbc_stop(struct xhci_db
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


