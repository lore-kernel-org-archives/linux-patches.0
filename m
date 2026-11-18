Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048082;
	b=k1hd8id7LRBvpM9TAOHq0RO7+pCs7mdUEbOtmDm/ck7WcT7lrbnUJY5yBxbJKgLa50vi
	 1iqcqHgANlxbcGxI/44s5tE7DxQlEMORXkhUJvTMgc7ca7v31IO9KOZBZYb3A+en0K9tw
	 ECzMa16vykwe3cKszHBexAs+hB/oqZTVgS0ojDRcZ0+bfy4eIllOJRixllnTtjF3fwJ4p
	 /1f7pTzlYEXELf1EslWlsVqr1fZ5t0Rj15p9KWARpWEJPYaNEeGdKYz9xxN1PFDWIQ1D9
	 qA+FCl1l7e5w3q3J4NnLkhQsbS+iYMSJ+L2qHMBYSpY7aHnpZo8LwiykHsbBHKK5R6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f2X1pN1dXhaeW5wlmFDahAaE8rd90bLiwng5o82IYpw=;
	b=BD3Fg/LMztCW7gLap/KpagisfN6KNUBX+u5ODL+Uv2HIKjAN913SWbLMwZ9CcOcksElk
	 NxFgTPaIJbBrejxynww1c1JNHSUn8qq0vADHFUfF4N5SI/eeDAqbaaVqKdN+C5kcCYxRU
	 NLOsituLJnEroT1OjNAto6T3IeHuObbFqAt/DejXui2xHZeersktaIsfocnDYYarvLdzZ
	 jjeQAH1MI20qWqYH/ShzKMakr1pp0zCq0WSCPZMfVSiI0XDWsn/bmGbIUtFSC99jU7XS5
	 gL1YxRzkPnfNSnHewBx+vtGbdfoYH8zFpKIayfdMGGoSovfJFf0lB5oCohWAz4dzcrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBSrbEEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20565606A320;
	Thu, 19 Nov 2026 00:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBSrbEEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7173E1F000C4;
	Thu, 19 Nov 2026 00:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048082;
	bh=f2X1pN1dXhaeW5wlmFDahAaE8rd90bLiwng5o82IYpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBSrbEEP+T+tOnwjFbbvVEqvFtx68ozkPbjzQ5Z/ysguda16ktHQNazFoeJBkfyVR
	 nKNh7+iDMLR/y+O63joPSTyPh3BzTcrlNUo//2j/uNd9mIfCQsMiIjGFCfr9adWBFs
	 nxk9vo2F0aNi+REGP5sOD08FOSO4AjGCcfYy231Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1869/2857] usb: image: microtek: stop SG processing after transfer errors
Date: Wed, 18 Nov 2026 15:48:23 +0100
Message-ID: <20261118150308.528952092@linuxfoundation.org>
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

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

[ Upstream commit d937ca39cc44a01ce64865dd25b1e205a05ae3a0 ]

When an SG URB completes with an error, mts_do_sg() calls
mts_transfer_cleanup(), which completes the SCSI command through
scsi_done(). However, the callback continues advancing the scatterlist
and may submit another URB for a command that has already been
completed.

Return immediately after the cleanup so that no further processing is
performed on the completed command.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260723195654.152104-1-diegomancera.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/image/microtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 874ea4b54ced8..8293d6d946f88 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -501,6 +501,7 @@ static void mts_do_sg (struct urb* transfer)
 	if (unlikely(status)) {
                 set_host_byte(context->srb, (status == -ENOENT ? DID_ABORT : DID_ERROR));
 		mts_transfer_cleanup(transfer);
+		return;
         }
 
 	context->curr_sg = sg_next(context->curr_sg);
-- 
2.53.0



