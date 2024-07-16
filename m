Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A8D1DDCE;
	Tue, 16 Jul 2024 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145056; cv=none; b=T06qu4dQh+KgPb6MWK9B1p8uGQ+iW3JIwa57jfRZhSpBs7bVZv+2W/Ib0o4oXZ9ImTmzPZF3+NKDZ1zGMgT3GBg30FjMNCqiOnS7ueO5zmXuVrRbnkhnz9W+VPfKS+anptY/GMKpgpniNIyXIkjYGoZ8m4XDIegU212AVI3cGWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145056; c=relaxed/simple;
	bh=OtJxmrrCFkT+K7K7W6vA2YoyqZrSfvN7s872bpv0/UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZLcklTJBxyvr1lTopWHf7Fj1RAsEx3GWssxjuCp6s08rOdSJCGE7vbI19DzAWIgAbOzbeJ5IdVkQ1gosgx68JS/PIztd4PhEGB2VtmDKZ0MzJEaT7D0k9ezoLoUWp9qje7y7EdZBNm8HpwBuCL1wUtB5KSShHEr+i70ExunQDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIUNOKI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIUNOKI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91E7C116B1;
	Tue, 16 Jul 2024 15:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145056;
	bh=OtJxmrrCFkT+K7K7W6vA2YoyqZrSfvN7s872bpv0/UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIUNOKI4COAj7rmyAA0+0co+UuEtjwm14PptXsRVaJhHWm6Ute1k7zH8rXc4S473B
	 K3YNUeih7621cDH/IMA+sgp8cNzJa1AWeRG/oGRCRdZ1wnOV9k6EH1aRiCFVnmoahO
	 944pkUyafVjc23A1TsOWVzmKU5m7X8NeRBtLsMjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.9 083/143] xhci: always resume roothubs if xHC was reset during resume
Date: Tue, 16 Jul 2024 17:31:19 +0200
Message-ID: <20240716152759.168873859@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 79989bd4ab86404743953fa382af0a22900050cf upstream.

Usb device connect may not be detected after runtime resume if
xHC is reset during resume.

In runtime resume cases xhci_resume() will only resume roothubs if there
are pending port events. If the xHC host is reset during runtime resume
due to a Save/Restore Error (SRE) then these pending port events won't be
detected as PORTSC change bits are not immediately set by host after reset.

Unconditionally resume roothubs if xHC is reset during resume to ensure
device connections are detected.

Also return early with error code if starting xHC fails after reset.

Issue was debugged and a similar solution suggested by Remi Pommarel.
Using this instead as it simplifies future refactoring.

Reported-by: Remi Pommarel <repk@triplefau.lt>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218987
Suggested-by: Remi Pommarel <repk@triplefau.lt>
Tested-by: Remi Pommarel <repk@triplefau.lt>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240627145523.1453155-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1125,10 +1125,20 @@ int xhci_resume(struct xhci_hcd *xhci, p
 			xhci_dbg(xhci, "Start the secondary HCD\n");
 			retval = xhci_run(xhci->shared_hcd);
 		}
-
+		if (retval)
+			return retval;
+		/*
+		 * Resume roothubs unconditionally as PORTSC change bits are not
+		 * immediately visible after xHC reset
+		 */
 		hcd->state = HC_STATE_SUSPENDED;
-		if (xhci->shared_hcd)
+
+		if (xhci->shared_hcd) {
 			xhci->shared_hcd->state = HC_STATE_SUSPENDED;
+			usb_hcd_resume_root_hub(xhci->shared_hcd);
+		}
+		usb_hcd_resume_root_hub(hcd);
+
 		goto done;
 	}
 
@@ -1152,7 +1162,6 @@ int xhci_resume(struct xhci_hcd *xhci, p
 
 	xhci_dbc_resume(xhci);
 
- done:
 	if (retval == 0) {
 		/*
 		 * Resume roothubs only if there are pending events.
@@ -1178,6 +1187,7 @@ int xhci_resume(struct xhci_hcd *xhci, p
 			usb_hcd_resume_root_hub(hcd);
 		}
 	}
+done:
 	/*
 	 * If system is subject to the Quirk, Compliance Mode Timer needs to
 	 * be re-initialized Always after a system resume. Ports are subject


