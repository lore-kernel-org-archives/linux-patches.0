Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102D33090F5;
	Mon, 13 Apr 2026 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098298; cv=none; b=vEG3ttYPwrf0lUsSBR8XhHzcz3XTlW9eYrYSF5Ijss4AK2n/ciu6D6nqUQ2t7jFSV2eXAvCVAD7W4pE7BfmT6zELsa3LzI+ba1yTUfjagb3cc0ofa9vTE2r2eABfbPiKnBEBeldK2MhuFGAPx3dHaEKQKXDhqvO+nC/cVc2sVHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098298; c=relaxed/simple;
	bh=xdM9s3AmofWFmiTHfTtNdJdZaqFR8R86zqupzd5Uboo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeNYtYdc/ZXud8vZgmAMk3fKHm0oU1wLHT4RfiUtZ9j8iu5DOxX+I4Frti3bd8z+hO8fH3aMBEeR0azEvGU/w/gQvkZ2zngOmviISFtcO0//rW/BXM6W0sxaIPD5BbjWokQv5anwxdUe6o2BZS0oepgE0bZBysmn9zViUOuqSP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8yVZADG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8yVZADG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5FEC2BCB3;
	Mon, 13 Apr 2026 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098297;
	bh=xdM9s3AmofWFmiTHfTtNdJdZaqFR8R86zqupzd5Uboo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8yVZADGh4F8hRDRA6IcLIYyHD8xivMoLdMUyekRerAlyeUOgFDb+wVj9CjpfV0fe
	 gCKh3XPkXn9jYHkgRLkZZCxSHpGL3/tsmmymL8iPTza2XFEJmS9zIbeq9P/gzAuDsR
	 lyRtUigyQQj3vA9iEe+TYTv1BDzTr9umyEfT0xic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.15 469/570] usb: ehci-brcm: fix sleep during atomic
Date: Mon, 13 Apr 2026 18:00:00 +0200
Message-ID: <20260413155848.034156121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


