Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7273030DD3C;
	Thu, 12 Mar 2026 20:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346806; cv=none; b=RV0mutLXcZNpGyanZMJHpHnd51cN668bJtGcMY0PACSelDo3EPCaeyDuK57B5dWBeU5PjHmL0ebv8CYkg1ZvhhbSkma0uJgnLwO6EW9ve5pFcIl7SOukaf6MW4czq7xHGRDqHa/P59qA9g9klUbYmZn/eHT3aUIx5ZDA6Wsm+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346806; c=relaxed/simple;
	bh=NHK7CrtDOhgL4rslTTAsOhtU/DLr/t/HHKUJFr5esjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMpLoulC8y1V10M4jyiCfxDlHzNvaPdyh0SV3L0MJeKLRGFNBWDLlVIGokptdT47mtYQvH8LLWVrLLx7nkeLUKikBGUuXI+g4u1f9WEl+4gEF8c8X/E96ldsAPZEwNaGTSn3ko4t4KxLDUiOrO8uiMsO3cTdSLCMqSFeGN85ths=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDlHL/Gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDlHL/Gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C83C4CEF7;
	Thu, 12 Mar 2026 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346806;
	bh=NHK7CrtDOhgL4rslTTAsOhtU/DLr/t/HHKUJFr5esjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDlHL/Gi06sYZqFQ0HkQMSKetuB4LqZVDbhyKQMbi2PzRIP46Og5GXjJddbknQ+z+
	 XI7NyHyydqUD3swsJuoyliYGrqcPQ1tJLInq45SXw6THwGUKrwycvbJl1zgst06bUs
	 OlAltuPjU4Gudzo6gKOI6guvPialKEhq470nq4D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 129/265] nfc: pn533: properly drop the usb interface reference on disconnect
Date: Thu, 12 Mar 2026 21:08:36 +0100
Message-ID: <20260312201022.910249983@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 12133a483dfa832241fbbf09321109a0ea8a520e upstream.

When the device is disconnected from the driver, there is a "dangling"
reference count on the usb interface that was grabbed in the probe
callback.  Fix this up by properly dropping the reference after we are
done with it.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
Link: https://patch.msgid.link/2026022329-flashing-ought-7573@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -628,6 +628,7 @@ static void pn533_usb_disconnect(struct
 	usb_free_urb(phy->out_urb);
 	usb_free_urb(phy->ack_urb);
 	kfree(phy->ack_buffer);
+	usb_put_dev(phy->udev);
 
 	nfc_info(&interface->dev, "NXP PN533 NFC device disconnected\n");
 }


