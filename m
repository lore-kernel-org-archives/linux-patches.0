Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A3D47CA9C;
	Thu, 20 Aug 2026 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243955; cv=none; b=Ni5Vh/0Xh6y3+Ox3ejqpyq8qN/Y8FP56Teeeijt1KRnVvYE9lpkMdPOzj5sE9uJw1UE5u2pdI+Cua2KUgwsqSxLPbOm9nMhVc7lzTE9wl+2paQfWbDtKrSaVsimov/Qany0k1/wYIqgAfrk2znfIIeLP7D9RyT6R5JtXISkzW0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243955; c=relaxed/simple;
	bh=1IH+XSQCJ5G9kYF9NpJqBpDele8/s3kwlteWdYcLGDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDZpuMFuQUgwRb4VZtx2ZW3YTWksHomElYSzF8T9C9DXX3Zwc6MQc1X4dnDA+VSSdRwhpJuqeENscV8yztNGCfOHT63hnT0LI+Gau2je+K/9Qgjwv/DLWqFKQegtUDjjLl3QcsMQRTzhnNMhgNUnwo0l9cnSuQXg+8VzLndeKMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StwQKFW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StwQKFW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05181F000E9;
	Thu, 20 Aug 2026 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243954;
	bh=3h9NLKgT0sZrNFZB32DJnxWZ5COKqgF6hFW+do1HCAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StwQKFW3p67ToD08hi4ZvPiwB5hN36w3ZNkGap98u/0tDR1p/1kNRkirx7VU90NUf
	 H0BFqA0BzhyJq/fgq0TnI5Qb3upnrSEFrEqZmtU/bowZCU9frigeUjoKdH2AOfpaew
	 zZgrZUZq76hd8V7En1ptQm86RQv6NpNM0Mm5Navs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/272] can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure
Date: Thu, 20 Aug 2026 16:57:07 +0200
Message-ID: <20260820145238.909546460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
 drivers/net/can/usb/gs_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -333,7 +333,7 @@ static void gs_usb_receive_bulk_callback
 	if (hf->echo_id == -1) { /* normal rx */
 		skb = alloc_can_skb(dev->netdev, &cf);
 		if (!skb)
-			return;
+			goto resubmit_urb;
 
 		cf->can_id = le32_to_cpu(hf->can_id);
 


