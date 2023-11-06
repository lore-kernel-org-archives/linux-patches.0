Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54794250EA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umD+fRh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80CEC433C8;
	Mon,  6 Nov 2023 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277627;
	bh=H5oodI+zNPrmliIm3JY7QueUrWoxuNyDZsTrBBuCZq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umD+fRh8z6pPt9c5Sw6p3cvDDcrX+e071DDvrRpf0q0NqU/lvGa4C2OBEeyIxdLy4
	 OZVUoxTVDlQklx0N1CHXKSC+09l2ozMZ6gL7KOcdMo0QKlGAevEDLyhWxLw86+ibsR
	 m8Gop/qJgVwaUHzJezJAqDMIJFhyvHT8jU7lgZgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Will <derekrobertwill@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 82/95] can: isotp: isotp_bind(): return -EINVAL on incorrect CAN ID formatting
Date: Mon,  6 Nov 2023 14:04:50 +0100
Message-ID: <20231106130307.703149999@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 2aa39889c463195a0dfe2aff9fad413139c32a4f upstream

Commit 3ea566422cbd ("can: isotp: sanitize CAN ID checks in
isotp_bind()") checks the given CAN ID address information by
sanitizing the input values.

This check (silently) removes obsolete bits by masking the given CAN
IDs.

Derek Will suggested to give a feedback to the application programmer
when the 'sanitizing' was actually needed which means the programmer
provided CAN ID content in a wrong format (e.g. SFF CAN IDs with a CAN
ID > 0x7FF).

Link: https://lore.kernel.org/all/20220515181633.76671-1-socketcan@hartkopp.net
Suggested-by: Derek Will <derekrobertwill@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1142,6 +1142,11 @@ static int isotp_bind(struct socket *soc
 	else
 		rx_id &= CAN_SFF_MASK;
 
+	/* give feedback on wrong CAN-ID values */
+	if (tx_id != addr->can_addr.tp.tx_id ||
+	    rx_id != addr->can_addr.tp.rx_id)
+		return -EINVAL;
+
 	if (!addr->can_ifindex)
 		return -ENODEV;
 


