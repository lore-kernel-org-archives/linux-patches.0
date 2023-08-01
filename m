Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59CB1F957
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59917C433C8;
	Tue,  1 Aug 2023 09:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882613;
	bh=EdJlco+J4sUdxUMYVRQuIKYB38LSkBEY2e1cyt17zm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCSIn5DBZIogAgrh6o5n3AF6enmlOo9CSOXDx9pHNsHGAgKmw5Yo2ZBIl99Lz8lw0
	 eMe7xs8pjMeXxEgCZPOAp//Z4xEEB5HGuHLkwvu/+SNM9UFQeytfTppvyOXKO1FwcA
	 On/aIrDLIktjfC001hdHZsCAcitfdNfjtahhdh3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guiting Shen <aarongt.shen@gmail.com>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 168/228] usb: ohci-at91: Fix the unhandle interrupt when resume
Date: Tue,  1 Aug 2023 11:20:26 +0200
Message-ID: <20230801091928.932213709@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guiting Shen <aarongt.shen@gmail.com>

commit c55afcbeaa7a6f4fffdbc999a9bf3f0b29a5186f upstream.

The ohci_hcd_at91_drv_suspend() sets ohci->rh_state to OHCI_RH_HALTED when
suspend which will let the ohci_irq() skip the interrupt after resume. And
nobody to handle this interrupt.

According to the comment in ohci_hcd_at91_drv_suspend(), it need to reset
when resume from suspend(MEM) to fix by setting "hibernated" argument of
ohci_resume().

Signed-off-by: Guiting Shen <aarongt.shen@gmail.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230626152713.18950-1-aarongt.shen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-at91.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -673,7 +673,13 @@ ohci_hcd_at91_drv_resume(struct device *
 	else
 		at91_start_clock(ohci_at91);
 
-	ohci_resume(hcd, false);
+	/*
+	 * According to the comment in ohci_hcd_at91_drv_suspend()
+	 * we need to do a reset if the 48Mhz clock was stopped,
+	 * that is, if ohci_at91->wakeup is clear. Tell ohci_resume()
+	 * to reset in this case by setting its "hibernated" flag.
+	 */
+	ohci_resume(hcd, !ohci_at91->wakeup);
 
 	return 0;
 }


