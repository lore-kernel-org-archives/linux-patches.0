Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2D846C82A;
	Thu, 20 Aug 2026 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248533; cv=none; b=NIdPYT46r8j+STVercgG/W0tCscL53VH2CF6MQM2xukP/MHcWjLFtlctmg5PZCk1W2ieswQ5CuAa7VX5mc4XJgiU2hOjgMygiLDVU3AJrbOZDXgv3WpGWjDQ886KrPMtKMDdq0KhQU6QsWgTilwJqv1I015bpzmENw8Mpb54Vuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248533; c=relaxed/simple;
	bh=6VD14zkw48Y7odGZM7XibR25QESA0oXTmmx2zW7HITE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvXqvQeBdY/riInz1Wi3orviKkO3nk4B7nbQ2/WPyUbHFhvOX9g0oN6VTjWo+VYDTWild0zZnhG8b2FEn8lCAdE+3SXc2YuNuC2jJvIClRHfcjKJtW39U2QYYMGiUNkse+x4mZsmc85zcA2Mpg/UySwCqo6rZYYuxTzpoh8lrwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPq7IgbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPq7IgbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F591F000E9;
	Thu, 20 Aug 2026 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248532;
	bh=hZKd7HMEUmzgT1wNA38K82CU8EiTJZkXA6ynt2YWSvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPq7IgbZGI5IvLoqC1jmL5rSJqsp5HRkljSkrciWzKlhLD7gQYDxD9D08mIYIA8Hc
	 Mz7QRSsoUPaiCyVt9a2WpYipkjcdwGgA9k6aq0IfBVceVuStYJPduSUpar+OLh3kog
	 18y2U0PxYqonq4+pkrr+5a0vjkXpk0blMvmrCUDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/303] can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure
Date: Thu, 20 Aug 2026 16:56:35 +0200
Message-ID: <20260820145301.229082004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 68c5724ecd159992f76edb7b57dc508a44c8b7da ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -574,7 +574,7 @@ static void gs_usb_receive_bulk_callback
 		if (hf->flags & GS_CAN_FLAG_FD) {
 			skb = alloc_canfd_skb(dev->netdev, &cfd);
 			if (!skb)
-				return;
+				goto resubmit_urb;
 
 			cfd->can_id = le32_to_cpu(hf->can_id);
 			cfd->len = can_fd_dlc2len(hf->can_dlc);
@@ -587,7 +587,7 @@ static void gs_usb_receive_bulk_callback
 		} else {
 			skb = alloc_can_skb(dev->netdev, &cf);
 			if (!skb)
-				return;
+				goto resubmit_urb;
 
 			cf->can_id = le32_to_cpu(hf->can_id);
 			can_frame_set_cc_len(cf, hf->can_dlc, dev->can.ctrlmode);


