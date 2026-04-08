Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FB42494F0;
	Wed,  8 Apr 2026 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672696; cv=none; b=ilx0XmYGejOMKPxn5qKm9Gb7QzjNZIuw+zepeVoI3W+bvkBzDDkkgZOIVMybea3itM9s2XH4ls96SEjfF6bdww/U8GQZ2t8/HdmTU+NW/YwLzKqiQXDityY0mFv/8Wd/ltRQT7I8EEYgrKWIUbp51tnmUDImz+QkVrbH7aTy9O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672696; c=relaxed/simple;
	bh=cSx+9nTicGlTSuy0Q65ird10mXUItwhhtdiPqNcJB2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8AJSo1VQamocdl1yZaazg/XKahlIV35T1khWYZCRGKkpnihwJI41qyH1h3/IDCtEjNcJ6fUyAJKEhqeLNC/xm5AGStQAe+1I28Vix5ddUEE861VYRWCISM6U07QLDrzlhsxJjb3GoDrLTJSBuP7P17qbKQgHGcXZ5L40bmuD6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwpPhZJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwpPhZJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293D0C19421;
	Wed,  8 Apr 2026 18:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672695;
	bh=cSx+9nTicGlTSuy0Q65ird10mXUItwhhtdiPqNcJB2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwpPhZJ5KylAYGfqZfWUKU3JBB1yz+6diAZKgHQQPvTGOAOp6YEdN7e6oRqGWq8Us
	 2ftjFFYAM274Uc+sOYEtp547DBNDNK5UDscXyv4neXC779Su+g3UaycS1kki/HFEO7
	 LCk1Jy+YvbWHpt9rATCAp1FNkW3C7wmkUVZFRJ4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.6 107/160] usb: ehci-brcm: fix sleep during atomic
Date: Wed,  8 Apr 2026 20:03:14 +0200
Message-ID: <20260408175917.177130241@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


