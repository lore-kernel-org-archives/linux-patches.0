Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A731E4113;
	Mon, 21 Oct 2024 10:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507676; cv=none; b=qimWwQUGFImeeRD5tOd+jdMGXWGslvNtr0FBfLj2lGBkFLq1OJ6xriZBfu+PpJMbuPdrV/Sh9pyRlwk68dmTUvXUXODcqmdXRlY/ilgYIqFb9kwbd8kbXwUKLtH6EHv8ct34+7ThmZ5o1v/jbay0CWTI18Hb4S74XxY+cezVelY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507676; c=relaxed/simple;
	bh=AOY/rO+qSpcWh6aXSwEFkZQGKiaMtR/mV3iRTdodTDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0gGTSiVYHz5ZqEWu5SnqNYoRA3lNdgi3DAKMsUsgkKj8p8Zy6Xm84XSqRm9Xc2KKbx59y5L9VUOKyPsUZ0TcCYs1isjx4FD5Py4LaFXvSG5pE14fDsdnic+fx2sdSm642ploTRtf2bcruLGjqs7wjk4Uj3ZJrMDXXH/b/hDh9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlSlwNjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlSlwNjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E798C4CEC3;
	Mon, 21 Oct 2024 10:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507675;
	bh=AOY/rO+qSpcWh6aXSwEFkZQGKiaMtR/mV3iRTdodTDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlSlwNjntYxMn+SGccZnlY7QwnPafGdf+StvZ5hRLiv1JkSv8ci52jYX6QCDNp1gN
	 BKLbCViBQroriII74BqQwo7i0TTVCyx/HHrEyYhTRYqzQ/50t3l/1C+pkjwPvRkTEo
	 +X1DTMUqXoCte/3wuHKGyAcNqsVw/l9OWCc6o6QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 64/82] xhci: Mitigate failed set dequeue pointer commands
Date: Mon, 21 Oct 2024 12:25:45 +0200
Message-ID: <20241021102249.757022702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit fe49df60cdb7c2975aa743dc295f8786e4b7db10 upstream.

Avoid xHC host from processing a cancelled URB by always turning
cancelled URB TDs into no-op TRBs before queuing a 'Set TR Deq' command.

If the command fails then xHC will start processing the cancelled TD
instead of skipping it once endpoint is restarted, causing issues like
Babble error.

This is not a complete solution as a failed 'Set TR Deq' command does not
guarantee xHC TRB caches are cleared.

Fixes: 4db356924a50 ("xhci: turn cancelled td cleanup to its own function")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241016140000.783905-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1013,7 +1013,7 @@ static int xhci_invalidate_cancelled_tds
 					td_to_noop(xhci, ring, cached_td, false);
 					cached_td->cancel_status = TD_CLEARED;
 				}
-
+				td_to_noop(xhci, ring, td, false);
 				td->cancel_status = TD_CLEARING_CACHE;
 				cached_td = td;
 				break;


