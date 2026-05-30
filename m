Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584D835200B;
	Sat, 30 May 2026 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160874; cv=none; b=KRH7F2yZCrGvZp9bRFzVAH4yRJ6X0x1tzOUE/ggtScugiOi79WycRS1K/R1b3kJEAkz8QZyividqx+BtmiD/R2F4lhyIOd9NjHif+cr/tQ9JWk7rzgfphSQYoMJRU8RYtZ5GgyNdEC68p+KSWpIWYTlgIkxLQWXeKzvWc1cQAV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160874; c=relaxed/simple;
	bh=GRDrdGvO0CnEpyWqbi8SoeFESuQ8SSCrDSQoIvW1iZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fabwf9nPoKasVOFvPDhmobxpNMAX2ex47CIZ/pYoJMWAJDH+1JEJUQZtknGWV5lmffsN9+l8BZPXFYmkteE01GJE1umUtgoDWhXLcIIK/M3vGhn+aDojmgd738F2YlliHTaYiUD/co0h131xCB54WOyYdG56e4i1ejE1VMu4I5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=de5HoV8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="de5HoV8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1BD1F00893;
	Sat, 30 May 2026 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160873;
	bh=7bANKQV9Ct1qShfa+zQctdYFuJGvJQKlGrkMFpsuGbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=de5HoV8G6X2Sj//bHnr4oLD6ASr9iqd7KPwt/egRCrUtrQCS+5/4rjgcMh8NQJrD7
	 VRV/9HgZkR3VZYVexeBdQnS2GlcMPoYrh5HECAYKpMWdf9cn4JCZyBwsQ6wlmZI9ge
	 utKiP3wwUrxnf60LeoOJ+tOhZeixRDX0N1EI5VNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 459/969] r8152: fix incorrect register write to USB_UPHY_XTAL
Date: Sat, 30 May 2026 17:59:43 +0200
Message-ID: <20260530160312.955333108@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Chih Kai Hsu <hsu.chih.kai@realtek.com>

[ Upstream commit 48afd5124fd6129c46fd12cb06155384b1c4a0c4 ]

The old code used ocp_write_byte() to clear the OOBS_POLLING bit
(BIT(8)) in the USB_UPHY_XTAL register, but this doesn't correctly
clear a bit in the upper byte of the 16-bit register.

Fix this by using ocp_write_word() instead.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Chih Kai Hsu <hsu.chih.kai@realtek.com>
Reviewed-by: Hayes Wang <hayeswang@realtek.com>
Link: https://patch.msgid.link/20260326073925.32976-454-nic_swsd@realtek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 15979cd7d15ae..98e30291b0500 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3748,7 +3748,7 @@ static void r8156_ups_en(struct r8152 *tp, bool enable)
 		case RTL_VER_15:
 			ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_UPHY_XTAL);
 			ocp_data &= ~OOBS_POLLING;
-			ocp_write_byte(tp, MCU_TYPE_USB, USB_UPHY_XTAL, ocp_data);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_UPHY_XTAL, ocp_data);
 			break;
 		default:
 			break;
-- 
2.53.0



