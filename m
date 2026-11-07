Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063272;
	b=cxLR8kaeTS37TDCINmfL5q9Obwb6XHYTrlZ6BT+isLALcWLvKcrXpmaAsqcWadU0NFBk
	 xMfgtoZQbldrbaFfeAo+92+U1vkOBgBDIDvlpyQZi0THMnejcKeuhBPXsjOWZ6X9yGtMQ
	 GmtSOicL2ZXakGwrwRth6yAReMY7khvEseq0DjoP4ltOibCi+iIvdnfHSKcXtnBjIB7hJ
	 gMTpxvio0Uq+Ihr3/rbPF24kgpYImzsSTQQ7UD6phYUg4ZKqpS6eT7ux2L0fCS+vCyTOC
	 77R+7l5FSawJBGDzBcaTvGmVLKOu9wCm2v86lZ8f3odJLE713LEK1oLnq6GlFpw5qTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=afAjmJ/VLaTJs9oGAzAAoBuot2ctajkYpffJCUrvwHo=;
	b=KItQr1U9N5KZ1HWyXX3/2lidHU2LYN8b7utNSxXrH6m/suy7y1y2z6i1s1hge3X07HnU
	 jczGpIvc5zW2BqCNJUEamwcV5tjSl923kCtClg4eXVeu4fkSGPchAF427XfXYNNnueIAG
	 +9pV4jUOK6qWKItPTOT2I6z+ATBVs7bKtdIuBuD4BURIjK56UVDYH+cgq2URBkM25B7ZB
	 cZ8u8za+DaCwRUyBu5CwDCnj+Wk11OHeWW2WWiuhuOUOYLHZaaEdJbcGaWUJf8z7yGzKF
	 bSnHW9RqeHSIEv6z7lAJAcvaBAEqYjZAfIND0SPOElJT1gV3Jl+fNwD5a9BaVETXNZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQa0bq2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD386606A330;
	Sat,  7 Nov 2026 14:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQa0bq2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6BE1F0089F;
	Sat,  7 Nov 2026 14:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063271;
	bh=afAjmJ/VLaTJs9oGAzAAoBuot2ctajkYpffJCUrvwHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQa0bq2Ad+Y/cQk8ziMquDH8bHeuIgsZ1VS3pLyAxIlEmG7xzpzVH1S1phH10UnbY
	 YrBvcVN9K+me6RBMaFt4dqDO8Cs7RgInbPEGBjG4JZShbakwM2dPPo8JDkNCnMooGl
	 peyPKI6iayusKgEnVYysKgy2Ly/ciGiy1c85EmKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 468/869] USB: serial: sierra: fix urb leak on write completion
Date: Sat,  7 Nov 2026 08:52:30 -0500
Message-ID: <20261107134909.512733048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 741e68e461396..bac926cfee282 100644
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



