Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058485;
	b=goPCXLuUz/hBsq83Y/6cbvTnWhLvmt6B3RwyeZgBxDbrUB6zqa2WxmKITdCz7VQyv5jV
	 8AW+3syb7dVzmc+AWETFYJ4rqz+TNhwNukUsNfMDtdbBFY0JcH/hbjGTgHUGieIjmEmZV
	 CxlhNn+u51OVzItJLGyvzfTUPy3MFu5MNpQeqbuKRflOHYeLcrAfu6XshW/UfTB0Jpd6j
	 m+dAu4gb6QXJL44FIwQNRt/aiwVG8Gp6ngazcKxez+4FKtgWxFH2tZ/T/NSPV2CTuvkVi
	 am8n6i0pQfsdllonWMxC1asEFf36/GCRUPU61ho1ZmFuilZ71bvnIPZo/yCJJ+HOihg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a5agEtp7+oZVymoXajkyfcSKuvWktzNyMNU/wnbTyuo=;
	b=EJckchF3pqtfoIqp07rI0F4ZDgAAZqZovhT2XjCYmnE+kJhJk/Ckp2ghIK3a2Geo4Qvu
	 tYBtROItvXJhZUKBOcOYLIy0kAkso/ISYN+THGFsChssdW7wUgvg8yR1SFG5GFBRohwKk
	 +0UQGu1y6nAkzydPxRA53ZnzFx/CBh78bMQqGxgXZZwA+Ot6HT0gm7bDFePNCm+YwQYOv
	 7RpamtPsUAaWlzjTVDYg+72oyl5cO5digUNLGmT3nBm9KHsHMhPGRFFn05WiK4yT18t+1
	 +XQ0oWXLr98N5yYXm4N1RP30woeJiV4nu8lHoVYbii0ntE2CvLrIaxiwvRxlziQFoLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAl1L1mC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA391606A31C;
	Thu, 19 Nov 2026 03:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAl1L1mC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0311F000C4;
	Thu, 19 Nov 2026 03:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058484;
	bh=a5agEtp7+oZVymoXajkyfcSKuvWktzNyMNU/wnbTyuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAl1L1mC5wMWE8pg+HYqjWiq6wP9E204PhraWopNlKsrjIW/0RTdWEv9KqdMcMg/3
	 N8F+PNk0JvkSOYZaowIMij+uOrg5zdMfgRH64/9CgG5KPT71vihzK9+w8b3G9lhgC2
	 tYc70R8BYqYXYjZZPanKeIC89z3AN4VQ6ZvBPUS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0503/1848] USB: serial: sierra: fix urb leak on write completion
Date: Wed, 18 Nov 2026 15:42:21 +0100
Message-ID: <20261118145935.865898161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 018a27d879b8e..177dbcedcba9f 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -976,12 +976,13 @@ static int sierra_submit_delayed_urbs(struct usb_serial_port *port)
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



