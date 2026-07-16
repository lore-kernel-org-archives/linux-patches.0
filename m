Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CB33161AD;
	Thu, 16 Jul 2026 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211068; cv=none; b=iCYfAq3OhhCxeKCUSRW2UOJSEmrv/vFgSCpmT/oljr0Ea7eKyMHrxEHEzxKMVz8nRhRx2VubN5iED9Up4z5WL8EGV9hZFjw3eP1mg6QtK51tBys7s2wFsvOlfYamtrwTTCCmAdrXEzXB0D+iA9s3s6n9LQYtkfcMCHenAOHcLl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211068; c=relaxed/simple;
	bh=GcuZak9mcw5s3xjzuVp8fjrfSqJyMyVlco/8xF2L6F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIssBYnYpakJdK9zwMNV5tpEIomOelNhCSo+riIztCrr4n8TF9aQ9VtsRKBbkLupmCtKJT9uzsK6sVALaoN01agd6wBJRm33f2d1tzK/l0PTnGFeZHJ2VN3U2ocFikUQ58WyafP772ZlqiR8XyheKVSuZAB1PguxUW7YNlcz8bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVwqSiDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVwqSiDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA14A1F000E9;
	Thu, 16 Jul 2026 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211067;
	bh=XC3daYyKcEIGTmAP2dKvIEbpYqENIiGSBQpx42HqqEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVwqSiDfAcYwpctMGFwU/gXFneI/pAZNHCnpP79W5giKCg+Eb7/58yTbsutcLCQ/A
	 F9RAyWMDsQnNjYIr7Teo/pSW930nYVTywZWHzKwMstEAxXLLlk7zvrohzXBIuYmfNQ
	 hasi9ZupexUVES/3Tq3CX7yPwKypOA9j50HM8Dxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 288/480] usb: free iso schedules on failed submit
Date: Thu, 16 Jul 2026 15:30:35 +0200
Message-ID: <20260716133051.053903048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit b9399d25fbb34a05bbe76eeedd730f62ff2670e9 upstream.

EHCI and FOTG210 isochronous submits build an ehci_iso_sched before
linking the URB to the endpoint queue, and keep the staged schedule in
urb->hcpriv until iso_stream_schedule() and the link helpers consume it.
If the controller is no longer accessible, or usb_hcd_link_urb_to_ep()
fails, submit jumps to done_not_linked before that handoff happens and
leaks the staged schedule still attached to urb->hcpriv.

Free the staged schedule from done_not_linked when submit fails before
the URB is linked and clear urb->hcpriv after the free.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. As we do not have an
EHCI host controller with a USB isochronous device to test with, no
runtime testing was able to be performed.

Fixes: 8de98402652c ("[PATCH] USB: Fix USB suspend/resume crasher (#2)")
Fixes: e9df41c5c589 ("USB: make HCDs responsible for managing endpoint queues")
Fixes: 7d50195f6c50 ("usb: host: Faraday fotg210-hcd driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260630071419.349161-1-dawei.feng@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/fotg210/fotg210-hcd.c |    6 ++++--
 drivers/usb/host/ehci-sched.c     |   11 +++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/usb/fotg210/fotg210-hcd.c
+++ b/drivers/usb/fotg210/fotg210-hcd.c
@@ -4267,8 +4267,6 @@ static int iso_stream_schedule(struct fo
 	return 0;
 
 fail:
-	iso_sched_free(stream, sched);
-	urb->hcpriv = NULL;
 	return status;
 }
 
@@ -4562,6 +4560,10 @@ static int itd_submit(struct fotg210_hcd
 	else
 		usb_hcd_unlink_urb_from_ep(fotg210_to_hcd(fotg210), urb);
 done_not_linked:
+	if (status < 0) {
+		iso_sched_free(stream, urb->hcpriv);
+		urb->hcpriv = NULL;
+	}
 	spin_unlock_irqrestore(&fotg210->lock, flags);
 done:
 	return status;
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1624,6 +1624,7 @@ iso_stream_schedule(
 			status = 1;	/* and give it back immediately */
 			iso_sched_free(stream, sched);
 			sched = NULL;
+			urb->hcpriv = NULL;
 		}
 	}
 	urb->error_count = skip / period;
@@ -1654,8 +1655,6 @@ iso_stream_schedule(
 	return status;
 
  fail:
-	iso_sched_free(stream, sched);
-	urb->hcpriv = NULL;
 	return status;
 }
 
@@ -1967,6 +1966,10 @@ static int itd_submit(struct ehci_hcd *e
 		usb_hcd_unlink_urb_from_ep(ehci_to_hcd(ehci), urb);
 	}
  done_not_linked:
+	if (status < 0) {
+		iso_sched_free(stream, urb->hcpriv);
+		urb->hcpriv = NULL;
+	}
 	spin_unlock_irqrestore(&ehci->lock, flags);
  done:
 	return status;
@@ -2344,6 +2347,10 @@ static int sitd_submit(struct ehci_hcd *
 		usb_hcd_unlink_urb_from_ep(ehci_to_hcd(ehci), urb);
 	}
  done_not_linked:
+	if (status < 0) {
+		iso_sched_free(stream, urb->hcpriv);
+		urb->hcpriv = NULL;
+	}
 	spin_unlock_irqrestore(&ehci->lock, flags);
  done:
 	return status;


