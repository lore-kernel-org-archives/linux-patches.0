Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5C024B28;
	Wed,  8 Apr 2026 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672291; cv=none; b=i01RSsVHb0hhAbAOAedM/ZFdk/4YDcIvDiPf80SH9UTrAjGDddQDsL3DqFy4eLWIfdus01YeIqeTxELZZRowitIPGWZ01dtgBHpO1+A5aCo2gfmvHzqiCyC33A+BC+ujvyZT3pWI5265FfVrggAIAv+OMUP1scPuB65oQHMY0Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672291; c=relaxed/simple;
	bh=RyI6W3HbW9C0H6vMDS7lzmIBfJl4YTEcPEXDLnu/Yvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1oULgreVgchbq65KyYkmMoMU8b2fFQoMGjz6uan1HvGttzNdl9AlsA8dIQgAKIfTf9R5Q78tO419CxBaQe6tyUu0z3tInnASD0LsyCFT52aRuQB1sRPQwZmsUfSj427QcGOuY/xhJIH+s9sY3IX/XMJJH0T/0HoDxoTIBPZYdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mH2x6onO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mH2x6onO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A1DC19421;
	Wed,  8 Apr 2026 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672291;
	bh=RyI6W3HbW9C0H6vMDS7lzmIBfJl4YTEcPEXDLnu/Yvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mH2x6onOT9pMFLiRNgC1AVyshj6nR6Wh1PsigK25tpuwtZimA//55oz01T83SXlG8
	 lwW7WW+1nW9vmQLrES1zgrlXH/Pukp13NBx9AdtbphJ7q03gmS8+7tZ8mYNsvQU//u
	 tq6B3OeUjeX9Ub92iCBOXlw399S/hfzJpbvQ65VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 230/312] usb: ehci-brcm: fix sleep during atomic
Date: Wed,  8 Apr 2026 20:02:27 +0200
Message-ID: <20260408175942.345333200@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


