Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA613D6CA2;
	Wed,  8 Apr 2026 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673362; cv=none; b=f333Rs1zUDsdpkqV+VWjB6q1rS41aZfEiqxVPL38MOxL7f0U/WDaQvhZWjQQuS03lTPWwfW34dQTyGaskj/bDU5JXitSf0FsHOAwrX+Y6jFiBYK3wE4U/5GH1biZigLgsDo/peHXyHP1WwUOPezIsW5nSKaWiycLQvQN9pbN4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673362; c=relaxed/simple;
	bh=zHv5rUXX1wS7x07KXwy4PiOl1x3csQ/MUbKcZTz1Kl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs9rKbhiccW037ydpQCf1IvHnPeFpRj1e1m/3r/ojubHXGqPk6P+IOkzJ967V6thVom8CZqmQhjzM+7MlQ2SZLgE4jIAz0+piOsSOVf65FuXn7zfOsDf//lNywdm8alx4QkGCFQ8VhkFhQpoSh0CKt2NIb01WbzQaOjpaNSPwJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCl1s0pE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCl1s0pE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E51BC19421;
	Wed,  8 Apr 2026 18:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673361;
	bh=zHv5rUXX1wS7x07KXwy4PiOl1x3csQ/MUbKcZTz1Kl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCl1s0pEQfL37CsS1xSPKySN8SigpJp+qobFUflCpLKcNBOk13YiKKBFE8hcyk0im
	 KrO4FhDfiR2LZ8sDfPeDo3HbjpRWfwbWfjad0tbLxGf79lij4vPTEogemvFHj52RY4
	 oX+Ax1Q1mh00zN67OLEWnRxtfKrJC4LekpL9Tgxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.18 202/277] usb: ehci-brcm: fix sleep during atomic
Date: Wed,  8 Apr 2026 20:03:07 +0200
Message-ID: <20260408175941.406098325@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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


