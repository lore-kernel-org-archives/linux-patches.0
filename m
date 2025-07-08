Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A53829B797;
	Tue,  8 Jul 2025 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992142; cv=none; b=MonQOlaPVcu1SbTZvKndmTPwpCZjGB8Bj9n2xau0pPrTGnIBaE9192LCubI29B5/OeDyVeUzF+kG7EDO1uw101WFVS2rfCCVuSGttbP+4nxvfecIC8p7aytGQMXwNuvFuODuoDbxkCsFvJkJH18Su6Kh6MO2qY1ZmnHK2vp3Pbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992142; c=relaxed/simple;
	bh=/DCPhZTb+uUE+CnmCS3jbm98MUaWyXJWUHlY9BknagU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1fIAGXhgzVynCxCU+04921vXeoDRisTUDg+9edEES1EDsHOFiyr3WwM6A9hbtlLlZGJVOcDPaU9/eYzBbQVzaoIHYiHyJ7Au9dipdbCKP2BzBXjK9SiOZmbfHOcYSTaBtp1QC26OTTrY0xNC8zWovp5TdvvNvmudGSAol92TDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yW8nQ9nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yW8nQ9nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A23C4CEED;
	Tue,  8 Jul 2025 16:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992142;
	bh=/DCPhZTb+uUE+CnmCS3jbm98MUaWyXJWUHlY9BknagU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yW8nQ9nznyQrpxn4NWn1AqROn0bLedONrCGazwmpNVxaKxa/ZEGIetXaaKJiar9/W
	 hs1hPN1TxlbHviUFZdySPQ5AQUxooA2W4ldta9Y7ZPwV6e8qzgsSQnuqeocIuTXoM0
	 BEYc6mf3hJ+/9m8YMZEmGFNG7dPVFVtCzAeW9mX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongliang Yang <hongliang.yang@cixtech.com>,
	Fugang Duan <fugang.duan@cixtech.com>,
	Peter Chen <peter.chen@cixtech.com>
Subject: [PATCH 6.1 71/81] usb: cdnsp: do not disable slot for disabled slot
Date: Tue,  8 Jul 2025 18:24:03 +0200
Message-ID: <20250708162227.208100433@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@cixtech.com>

commit 7e2c421ef88e9da9c39e01496b7f5b0b354b42bc upstream.

It doesn't need to do it, and the related command event returns
'Slot Not Enabled Error' status.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Suggested-by: Hongliang Yang <hongliang.yang@cixtech.com>
Reviewed-by: Fugang Duan <fugang.duan@cixtech.com>
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://lore.kernel.org/r/20250619013413.35817-1-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -772,7 +772,9 @@ static int cdnsp_update_port_id(struct c
 	}
 
 	if (port_id != old_port) {
-		cdnsp_disable_slot(pdev);
+		if (pdev->slot_id)
+			cdnsp_disable_slot(pdev);
+
 		pdev->active_port = port;
 		cdnsp_enable_slot(pdev);
 	}


