Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DAA395DAA;
	Fri,  7 Aug 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116270; cv=none; b=FfGK5UF+uwSd6sveWejJeKrN4PSH5Nh/onSg4lccXE+zwrZ7BkX2T4bbcc9jf5T2awTauz1RFm4+8rPBhD/FDYUNGCe/XdfUTcZKvXs5EodUwC2+UOSQKkbcjAkUfkj4sNNG2uh6ixXv025d5MDlfuIre/Qbvl6Iq7PYszJagt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116270; c=relaxed/simple;
	bh=Nba7EfzbvU6MhRpT3WnrCIUlnych71klLI+laiLh9mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF0WXt74dHQLIHOQPZXX1Mlehp6FwCxWgYaaI//gNmurxXe4toX2P1+dciqZ1YtpNinTo3X7JpfowaLXJp3GC8mCRogDyfhANj0qXSuWzYmxUe+xL744qZCJn5jenGX7s5VTnw37htGaeUz9qQOcpb006ygaTr44LuHs9HdEZJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD5VcEZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD5VcEZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCA91F000E9;
	Fri,  7 Aug 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116269;
	bh=ZmoOba1PgfUbC3pqm3QpqBDqg2aLp4EHJF46vix3B+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QD5VcEZ1sPxD38iOyzuSveIa2ybKVCYRFNAtDTeJl17iDnU1wC0tuZOfYWCYj3ISV
	 slKksNAXFd1gbqVVwAzJs1Ifc9AN4x8QeJ29xSLbETgkgIQ3B7qb/td38LYT7AeBSA
	 oZSe0VFXORts48OmuFYijFhsPPO2S+UVgJZ4Vccg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 173/261] can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure
Date: Fri,  7 Aug 2026 16:38:50 +0200
Message-ID: <20260807143419.098923305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 68c5724ecd159992f76edb7b57dc508a44c8b7da upstream.

If the allocation of the SKB in gs_usb_receive_bulk_callback() fails, the
driver returns from the callback without resubmitting the URB in order to
receive further USB in URBs.

This results in a silent performance degradation which, if it occurs
repeatedly, results in starvation of USB in traffic.

Instead of returning immediately, try to resend the URB. If this also
fails, this is logged as an info message.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Fixes: 26949ac935e3 ("can: gs_usb: add CAN-FD support")
Link: https://patch.msgid.link/20260709-gs_usb-resubmit-urb-v1-1-4dd40030cc84@pengutronix.de
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -671,7 +671,7 @@ static void gs_usb_receive_bulk_callback
 		if (hf->flags & GS_CAN_FLAG_FD) {
 			skb = alloc_canfd_skb(netdev, &cfd);
 			if (!skb)
-				return;
+				goto resubmit_urb;
 
 			cfd->can_id = le32_to_cpu(hf->can_id);
 			cfd->len = data_length;
@@ -684,7 +684,7 @@ static void gs_usb_receive_bulk_callback
 		} else {
 			skb = alloc_can_skb(netdev, &cf);
 			if (!skb)
-				return;
+				goto resubmit_urb;
 
 			cf->can_id = le32_to_cpu(hf->can_id);
 			can_frame_set_cc_len(cf, hf->can_dlc, dev->can.ctrlmode);


