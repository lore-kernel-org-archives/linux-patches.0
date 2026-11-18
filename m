Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036553;
	b=2yNyyvSsCF4iBHijBm9cqlPtsqVtbqmMOqosO8MjcepiCPdYCVgazTXrJzs/9ResWKPy
	 kpeZETc2Zh/jwtei4R9AgqLVZobx/AUcE1Rx4Dt/Tjd8oYT73qLz6tPbHFtpc9lqjRRO/
	 NfrFNUDoEsTFxwMs1ayT0kMVJ8O4equ3je6Lp0xdosdb8Lp3o8oOHkwwO4Rk82/ocMAfX
	 jDsQoDk9m946su6USDD2AxhVU1396NHXiJnpqrRHKMNELmzHGolzzW0FZU3br/wXRHMtT
	 kL8cJa6ge3Dx8Uu0mSnnEezzCCjN5JINnA2hD21fsZ6dJQ0Cap7xxMBXYKNltBYq6Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9GI6QcoVJ7iL4yL/+Ox0+ERdpOIecJhIHHkcLd/Vn44=;
	b=ZULnDafXHOu4OhwaxE6/GHWFB32W2VUVRUMxP1UL1bv1ffmD/u6qCECAjJRmkNAg1LuT
	 QaIwqqAGF4VgG+Nx95so8GbQCwaOPDAkUp5tVhj6rgUA6RchhKCR6JwwPgdYHX1qzbhtb
	 yMDyvOID1qnrk8ckd/2JlZIcDVazDqXBiMJhTpod3Vs03OZASG+Z+rHY575qS6Cb6GZd+
	 THLKq47ul8Fs0JNwzcRR3CsQ2v4m249dTqokzl4fLA/ehiFMjutJE+1D/8s0+URS6zXQR
	 IYqESTVRpgZESaT3myZCqb0d99t4v+Nej5otFur2YBA5Qf4wDa6+fUmm0Y2hR5AEnYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZhX4PSU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CB7606A339;
	Wed, 18 Nov 2026 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZhX4PSU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972B01F000C4;
	Wed, 18 Nov 2026 21:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036553;
	bh=9GI6QcoVJ7iL4yL/+Ox0+ERdpOIecJhIHHkcLd/Vn44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZhX4PSUCaXiJ7JL3pU8whsg9nWTANM6L9LwTVVkNuxpJo5/TtubgRPAGN3mJbF9f
	 hyW1+HbqhPe9GiCfIaBCdveh0rkRnxAafk5PpP1yv1UtvheV4viFXjKBROJz2m84E7
	 LR4BMvif/WFIwudvimTM49v34S9USIOZGsEhwY5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1064/3318] USB: serial: sierra: fix urb leak on write completion
Date: Wed, 18 Nov 2026 15:28:06 +0100
Message-ID: <20261118150351.878776732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



