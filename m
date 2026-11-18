Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045434;
	b=mFfwHIe6sURMpE42X5rxaO4SxB1xqdMVvSLY2quM/aCjMuz7R/Q8QS22vAtr0T4j1g3+
	 U2Fuo4NVo3IxGTaV4I36c9ALblXrcN5xxeTcZx/d6AIkURPh28MaeodyL6VIdXvnnR/67
	 IaKAcSbXXzgjjlkYxAJ5PlmkB1IG3mvvAH9Q6afMgnGYzyYeQYu9yU0qwiyIVXHeLjlYf
	 xMeCTkfMaxIJo+aJj842FrveOC8LcgNl3jE62OmfU/lIvCr51Dm/1TJgrlK20z08YFSIO
	 xu3SEHoufETJNV/GV5jpaU5krgg08EZ9qAF7Q2O45wlpyCFHwKSNRknDci0WqxPSLBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5f0GLQr7B5uHYjDjk38H1OO12OeJUD1LaMD+UxyAX4o=;
	b=viZrOfwMaQVRyZQBULjQ5pGepxMmbKmN0AIIzOAeQpAzFQbT/LcKpjMWAZCoxdasrv/E
	 AWMWAYM/UR/j7QBk+MMr1JSQs9AghVkVShn3OdJeAmqDj9KKlJA5FVEfPZHb0uUHsmwMi
	 gIt0x9xE+OJmozekbZ/NngrIq3sEYJfMCM0kXKlI1I8vl+RLHAUszMmmtmO9L7sEY+Gte
	 U/fKnSbAY1LkCiNtTmRyMJAsXjjsryIwGwRGJ9U8qQbcG23XhXNdpz5shprqOYRQey/RE
	 IRxuYpGWJShfLumRnyHWXvmMTA2jLzpZDVjy8s/SVMF7yDkfQKyG0yLrtxcqq4hOWww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GlDZ99Gk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AEF606A31C;
	Wed, 18 Nov 2026 23:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GlDZ99Gk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6731F000C5;
	Wed, 18 Nov 2026 23:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045434;
	bh=5f0GLQr7B5uHYjDjk38H1OO12OeJUD1LaMD+UxyAX4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GlDZ99GkxmGoLDndLWnAPMQvBZOK4OJwLaLgSsWPPh9bfRGqak0M0k7U/vVj3U5v9
	 427ad8qAmJTBoDJ0Sk+KgdOTk4lBRGPGVXQVPY4udjTI7Oivdm3fp415iWrODwch66
	 QPu2q3yyE0jl8mW3pyfdEC8Z6xe0pH86i3hw7gZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0921/2857] USB: serial: sierra: fix urb leak on write completion
Date: Wed, 18 Nov 2026 15:32:35 +0100
Message-ID: <20261118150234.744151901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e7daa54802c566ed3f22e81513f84c8c9197c5d1 ]

Make sure to drop the reference taken by usb_anchor_urb() also on
successful submission of delayed write URBs during runtime resume to
prevent them from leaking on completion.

Fixes: e6929a9020ac ("USB: support for autosuspend in sierra while online")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260916165352.2085480-1-vulab@iscas.ac.cn
Cc: stable@vger.kernel.org	# 2.6.32
Cc: Oliver Neukum <oliver@neukum.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/sierra.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 353b2549eaa8a..8cc4e04e214bd 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -972,12 +972,13 @@ static int sierra_submit_delayed_urbs(struct usb_serial_port *port)
 			intfdata->in_flight--;
 			usb_unanchor_urb(urb);
 			kfree(urb->transfer_buffer);
-			usb_free_urb(urb);
 
 			spin_lock(&portdata->lock);
 			portdata->outstanding_urbs--;
 			spin_unlock(&portdata->lock);
 		}
+
+		usb_put_urb(urb);
 	}
 
 	if (ec)
-- 
2.53.0



