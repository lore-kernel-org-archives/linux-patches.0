Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DB42E49BD;
	Tue,  8 Jul 2025 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993233; cv=none; b=jI+ZGVb8Unza2K1v3NI9kYa4hINLU5PDHYWQGRmofuHQLEbN+qRmfvJCsZ0plEHTZc/q4oH4vtkU/mI0J+5f2v2JaSoKpL0wYuhXIS2dc0cgbGoyHNSWbf/EERpDLIyC0gyInAERzE2TMGXg+PcGAm9FpkzjaDsjUXn3+msL5oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993233; c=relaxed/simple;
	bh=7wtLDnVjQTQGw3RnFCfWGAS6YwKIMvRv3qzzz61wefg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyGMfkoCP0s0DqBbgpsjMxgBbAybVmnKritFUFQPe5/Q+dF1AQoG3x2WzYsYAgmY7/qzaYjkNMvTyk7Bdps4KyzhUCS/BzQWCMczDqZgniTyUorbD74h1R3wg7/WvHsvmS1CfrKFWOgX0GYXG1U7WGCB8AhBTuwkEISDLnQln28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye3UZAwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye3UZAwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28BAC4CEED;
	Tue,  8 Jul 2025 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993233;
	bh=7wtLDnVjQTQGw3RnFCfWGAS6YwKIMvRv3qzzz61wefg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ye3UZAwOioguun9fpAIlD9KdwRspzQoataivVI0z8+okmb43a3We152V4V/cSlM5k
	 kivOlfaccA2rfnjKB0lihjY+yNMZll/03nQwSJAwu05b/bAHbz28p+WfgSnyluoxGA
	 GYOXpHEybJv2SRBEOZ7YB/h1vUzhwQzmas0ednOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 203/232] xhci: dbc: Flush queued requests before stopping dbc
Date: Tue,  8 Jul 2025 18:23:19 +0200
Message-ID: <20250708162246.749382974@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -651,6 +651,10 @@ static void xhci_dbc_stop(struct xhci_db
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


