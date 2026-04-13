Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAFE33F5AA;
	Mon, 13 Apr 2026 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099653; cv=none; b=QE1aDa3dWG2+lRcpVkj0ikQoBqeLVTjtqhtQaSA3N/8/pkbOhqXIbGRcQrLMGtEa6FAl3QrvSBqbyQZZ9uVzYOuSZ42iWditmTavC+6hIG1fcbgPw2Pb+q3LcEau2JCq3ZRt2yqBLnLfYMxqe2bZk6/DgJixQ/rkXaI5q0sZbF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099653; c=relaxed/simple;
	bh=B7zMmvH/GmCCp7wHzVycJNbJLulvEPO/6MF4Elz3dWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNRd6QtKLzUiipnjTEwCa9mt52oimLBBqMj8z+eGLMrsUZGRSxY6/Vap/QiV2oG0euuOjxC9JpjNSSz7O48l0Pd18OMM6H7qenTnAkgjcSh4uy5HWJZNzHHPDr3FZFE54Ex+Kt+6POZotTj17ys6tS849Wso5aPYFtWDHyBxXVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVJnhIAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVJnhIAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AC3C2BCB3;
	Mon, 13 Apr 2026 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099653;
	bh=B7zMmvH/GmCCp7wHzVycJNbJLulvEPO/6MF4Elz3dWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVJnhIASAK7VpmxQ0OguPi/P1u27AO+xwga7UL8qdwBhNizBnsx47t5uSs1SfbiWp
	 pNo3T2n+9k8Sp5WHuTt53QAlXnSUYIOtz/yof166UnDoaoZfd+1cHNOq+N5im6nj19
	 Qspyw1PRUuGj5m3gb4g8katg3veD5EgOOunzMPhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.10 390/491] usb: ehci-brcm: fix sleep during atomic
Date: Mon, 13 Apr 2026 18:00:35 +0200
Message-ID: <20260413155833.635641690@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

commit 679b771ea05ad0f8eeae83e14a91b8f4f39510c4 upstream.

echi_brcm_wait_for_sof() gets called after disabling interrupts
in ehci_brcm_hub_control(). Use the atomic version of poll_timeout
to fix the warning.

Fixes: 9df231511bd6 ("usb: ehci: Add new EHCI driver for Broadcom STB SoC's")
Cc: stable <stable@kernel.org>
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260318185707.2588431-1-justin.chen@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-brcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-brcm.c
+++ b/drivers/usb/host/ehci-brcm.c
@@ -31,8 +31,8 @@ static inline void ehci_brcm_wait_for_so
 	int res;
 
 	/* Wait for next microframe (every 125 usecs) */
-	res = readl_relaxed_poll_timeout(&ehci->regs->frame_index, val,
-					 val != frame_idx, 1, 130);
+	res = readl_relaxed_poll_timeout_atomic(&ehci->regs->frame_index,
+						val, val != frame_idx, 1, 130);
 	if (res)
 		ehci_err(ehci, "Error waiting for SOF\n");
 	udelay(delay);


