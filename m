Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7629C2DC32D;
	Tue,  8 Jul 2025 17:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994171; cv=none; b=Bmi55cWJi9ooBs1WOF62uIDr8fm1FkvGYp5QLHgpRmnkywheYMKeew/3nNUxFWcJamH9Y0tTiUrHnfsBrV/SS1cjmxh6ocGP9TYkbKGTWfTPPV5Vz/zaUDv+n0aE2zZD2Lse+dWAJ2sXf2amezN4tTxhwSDBMux1zvgEdLruB48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994171; c=relaxed/simple;
	bh=XDGVV/asUrOS1HFp+I4VpibUpgoeMhLLR4+caaZcW1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyN6ErChBmLJMo+5tq/0I8VMChJAfROn2NLQX+OOsOKlurlPjuVtjRH98KQXwBN76dPELG9HX9DjqdwkehdeIqD864MwyKcTmMqPGHZTns28qu8WhmlipwiYE+Wp22Jr7zC2jzIpRjgm+uV5oLS2CB4lNyXJvBf9X6Fyt7HIxmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ii3kFIsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ii3kFIsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BC2C4CEED;
	Tue,  8 Jul 2025 17:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994171;
	bh=XDGVV/asUrOS1HFp+I4VpibUpgoeMhLLR4+caaZcW1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ii3kFIsadOlndt35CnkJjclskH0xn328R0PXtWJlhCi1Z33W8kJEKT9EbScy+OmAK
	 /ozzLNPXXcr6DMI3y8vMva4j90Mkgkr3UOigVv5UnNj5nrncz7LiNEpqSWejBEJsVQ
	 lsLbgszBSbUeRAUPFytOP3+iOzu19GxGZtxnGuO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 150/160] xhci: dbc: Flush queued requests before stopping dbc
Date: Tue,  8 Jul 2025 18:23:07 +0200
Message-ID: <20250708162235.477716032@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


