Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062292;
	b=WrzHa2Ozb7RSoZEc739KszuStPA6qIhPUImiKlZiAUYHCQnx+P02j4l+Mog39OKGvv2M
	 vb4Ihr8gU8X0aUgdA3HHjxo2XwAlJGIVTh0vD88jRLR0tbO210RK5WmP3dRxf0qkgXPph
	 pZ9t8ux4lI6qj7HQIZHgoXjP6BCTTmy3hibWbX9CvzLZ2WzavhzP1nRn6IFt/+vQs+dxA
	 GVNXTqRsa6sdu4FV+sv8ThtupWoKUdC0YUbtCD0LU2XmpmVrmWAcwNFKnDmhx/YRm16W4
	 a/BYy4OnTsMYtQHMCf/TSbgrbaI6ZshXb0s26tqqBqQjTI/AeGZIdlcDPmyT2R0tzUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4F06CyB08Ap5yYY3WzdBXY3Gp+ihQ1drsD6TGLLwc/I=;
	b=hlCGCaf+9/LPkKJt8m5Y4LdolLDaWylB/jQDE9Zc5jLOaqagpKcRE2g2Nj+c2+q98CWG
	 pSazuMx3BTHC+dKtjfaWNN5xDTlz+9asGhei7eY2tKMzjMu1t6XMpZj/pnGArwIPtC539
	 kkRrhtW8ebxMXZDLq//ZdJ4isSvCn/6p3IXST47Px4PTJtlZwBb+hEbeY9k8ZncWoz6vF
	 kdhYd3wBCvySXp4AYLS8HykpJoABIddi7RhUrjY1yIAD511p8u0iUC3799z0qEXB2Jj+O
	 2Tn1woEbPTW4OSeCmVVYxNhkMoPSOrzuuFRKZQJtwc9mkxGaw40sawRgB5+kPx7I5JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r++2gLvO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9842606D816;
	Sat,  7 Nov 2026 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r++2gLvO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD5F1F0089F;
	Sat,  7 Nov 2026 14:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062291;
	bh=4F06CyB08Ap5yYY3WzdBXY3Gp+ihQ1drsD6TGLLwc/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r++2gLvO7DIdwFnTZ0SUrmrcLk5dPCOpIz59FjXMQo2b5sw4WEak5Ut+ifDjX/HNG
	 REs+MLUwNKTRjwZK7eWVGCilt6terY2wp+awScY8w/yi/YKcn22WkMGcddWlTBsuej
	 h6vxKFj/Si+pioo86vMG5K8DEUodcQe1ohHcPkqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1228/1536] USB: serial: sierra: fix urb leak on write completion
Date: Sat,  7 Nov 2026 08:54:04 -0500
Message-ID: <20261107135032.249149737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 64a2e0bb5723e..abeef92e24817 100644
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



