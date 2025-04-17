Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD01A1CAA99;
	Thu, 17 Apr 2025 18:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914655; cv=none; b=DicHWBixE538qTxssozNvu2arAwLtC94517tuPKx2eywChMbQW08fp+kUmR5U9QfnfgIS3+8riqAAnbdmW92ISgvwa+frsErJ8QkZevuL67AyOEK/OXZEpoYBBwHMkt5QLRj8WMJ/cBOpP5F6q4L4Ugof3VNFAcjZ1lW6Jg6Unk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914655; c=relaxed/simple;
	bh=SRVB5KvJx455FKkaguFPk9PtefkwcgQEek8bhlqkMqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqODS2bY127+SIuEL4VP6zssLn6mHtYIzMmeGyEpxO8EJ75cj/y9aZIpUyHiwDioPaG/M4UjhLGbyEtQTMutKLqr90VRLGTMCQvQbrFCQbFH83/S3R5Yd469Dhxp/kl1h7Yc2sAoM36Zmb+DJoCX0olcn227zcFTFHBLtJrRZAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWlE7fDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWlE7fDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D6DC4CEE4;
	Thu, 17 Apr 2025 18:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914655;
	bh=SRVB5KvJx455FKkaguFPk9PtefkwcgQEek8bhlqkMqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWlE7fDMDv3hzxnYzOwYbRI9UbYw7gVm24LLDv6G2KxThdiQj+KOi7iVHsnKQZ1aJ
	 fb1ojFTqkAglcTpleeo7MmhKFnVy0ysLW4V/w4CJEM3BX6OPignuKcsW74T6gqYKTM
	 GYtUIspH6ECpcKi9yQ61DJbHzoM0uQ/Yiz40rCGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.13 288/414] i3c: master: svc: Use readsb helper for reading MDB
Date: Thu, 17 Apr 2025 19:50:46 +0200
Message-ID: <20250417175123.011199274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

commit c06acf7143bddaa3c0f7bedd8b99e48f6acb85c3 upstream.

The target can send the MDB byte followed by additional data bytes.
The readl on MRDATAB reads one actual byte, but the readsl advances
the destination pointer by 4 bytes. This causes the subsequent payload
to be copied to wrong position in the destination buffer.

Cc: stable@kernel.org
Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -378,7 +378,7 @@ static int svc_i3c_master_handle_ibi(str
 	       slot->len < SVC_I3C_FIFO_SIZE) {
 		mdatactrl = readl(master->regs + SVC_I3C_MDATACTRL);
 		count = SVC_I3C_MDATACTRL_RXCOUNT(mdatactrl);
-		readsl(master->regs + SVC_I3C_MRDATAB, buf, count);
+		readsb(master->regs + SVC_I3C_MRDATAB, buf, count);
 		slot->len += count;
 		buf += count;
 	}


