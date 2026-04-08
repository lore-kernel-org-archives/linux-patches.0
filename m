Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB33525A321;
	Wed,  8 Apr 2026 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674923; cv=none; b=m/JeesLMKXuCNaPmI93a0nPdGhPEoQnpy5oLuQ+RsgF4D9rytE3aHhgbsl0DKOG2Y0CSqqLDFNnCjYrBWZAl2ubT+CItKodrYX/0cUmdrTCq6S+Z3OJc0ugKJFnmQxnT1S/Mzs3gNE7BXk8HXHfVB8s5nu012aRs+Ftq3BCzKLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674923; c=relaxed/simple;
	bh=QO/AY42o/rDkS6LnCZIGQXVKHek46vJa5XwP96Zx1wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayTTKtmnPK5rQjaG74DkHVtmMzKaEjx7nQY7pKmBJhqqnNra7OexeWR9PhKZ3WakKD98/JHNhcZeFshckz31/4Jq564lF74OnGvTh/Vw4FHsMSUrkN8CGg0iOx421xwn3mu4jEi1GMFoIwx7CrDDUxiw3tpCDbm07k9XKVdlB6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OykeJMQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OykeJMQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8012BC19421;
	Wed,  8 Apr 2026 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674922;
	bh=QO/AY42o/rDkS6LnCZIGQXVKHek46vJa5XwP96Zx1wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OykeJMQPZ0EzwGXsNOlFUyLmzY2C7H62P3zKmojvc5TmTpRQHXpg8IJpIjw/INQMU
	 mS4bS01JuENboBmiUx/7vSjL43Z1g4Q5Tztd8qL/eUaWYmjZk0Hxo9+qOoa7Ck8+U8
	 3K7f66Ttq9N25GYhia3Dyko2jgwlO1V4Kple5+6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.19 242/311] usb: ehci-brcm: fix sleep during atomic
Date: Wed,  8 Apr 2026 20:04:02 +0200
Message-ID: <20260408175948.428115681@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


