Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058462;
	b=jv47OLmphcBS5WJy6TI/rhpOyNbukp3qBaBHVxVEQXfd2Bdv1OmwvfP9mAjp+oght7FL
	 G0Y62LQV+RbeOngtO3BRdG4vw+evNHBjbllEMQgdzVu1Ukt4UivyivvMRJuM2lRvdlWu/
	 hHbMzH2rrTHEFwpRuBjs4dsR76fqMRi4V+IEy5hjrIg8Pf2IQMktEg7KHqyeMsBrD7WVQ
	 rxScIuzPq4jmRl6F5llOB0zoibo6GiH67CfsKlU/HfUnZM/jC/htTEsQVbJiSE5ZwqzeO
	 OXmItKpst8v1Abc7aJDlsF/hC056kaal5qpe2/uf/LSd4c3ZIYrEbjHv/9cVHXKyXLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=en+aX+uW/rJoCPNK+iZlM+nNvaKqICqNUFdUrWOWQ/g=;
	b=e3KWziayCgzjaKVppDP4PvTTcA2MJ1puQkfiMseU2gmVMZiAIXxHn/pT8cq7oplwcYQF
	 dWu8Ix2ri/KRGb6CkD7H3M1sUg192+Jj5BKf8T84DOsdxG4JWtn9Iz52mYFhmKg5D8XRL
	 QP3qp3E5bGWBqO0BulRchSus0W7dEBB+/2ERKAjwwKAvT+T2hUEcNQHq47xauvY+c1Zlk
	 DzRhTOnnOG8rV6AHRytjlyXX9D5rB6YnARfA5vVrtcC/dh+nq/yiLSqEJNysWsNHJPGmw
	 o0L1LgeTMGoWN06eBHVxUGKejDqcdKj/vo72HiL//fiz4IHuhm+T3PrQkihpC5BEVHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPnbFf5h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D63606A31C;
	Thu, 19 Nov 2026 03:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPnbFf5h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B648D1F000C4;
	Thu, 19 Nov 2026 03:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058462;
	bh=en+aX+uW/rJoCPNK+iZlM+nNvaKqICqNUFdUrWOWQ/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPnbFf5h5kzXh9lSKy34f9St2AUKoMY2zZOY9a9mbsqCyY+xSWnuxl05IduSiJ5Nc
	 6Pu6itkHX7t2eL9BpNW7MvYnzS5Ejhz+B1fJFvFJdIlausjelzsFG3wluduUADRfoH
	 nb45kk1hHxHjV+bk7/H3h2IU8g5XQFeYp6SisnJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0495/1848] USB: cdc-acm: fix urb leak on disconnect
Date: Wed, 18 Nov 2026 15:42:13 +0100
Message-ID: <20261118145935.143404068@linuxfoundation.org>
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

[ Upstream commit 648b08aa37c1b24a61662ad78964f2bca659ca26 ]

Make sure to drop the reference taken by usb_anchor_urb() when removing
URBs from the delayed URB anchor to prevent them from leaking when the
device is later disconnected.

Fixes: 140cb81ac8c6 ("USB: cdc-acm: fix broken runtime suspend")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260917161217.2161883-1-vulab@iscas.ac.cn/
Cc: stable@vger.kernel.org	# 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261009122934.464142-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e3049f31b891a..056b55d121ffb 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -773,6 +773,7 @@ static void acm_port_shutdown(struct tty_port *port)
 		urb = usb_get_from_anchor(&acm->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		wb = urb->context;
 		wb->use = false;
 		usb_autopm_put_interface_async(acm->control);
@@ -1674,7 +1675,7 @@ static int acm_resume(struct usb_interface *intf)
 			urb = usb_get_from_anchor(&acm->delayed);
 			if (!urb)
 				break;
-
+			usb_put_urb(urb);
 			acm_start_wb(acm, urb->context);
 		}
 
-- 
2.53.0



