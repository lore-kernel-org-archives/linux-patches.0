Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211886;
	b=xyUkx4UPvkldyq8lzxT2CmXYIRy052hVFmMdeD8y8j2FmuXm1gmDzwQ8rAZKgO6CZhYX
	 Z1GPds9/5MRPG9hppxliDUPu54voI31GlyF/hLB9aQDl2M++dWCuHKzL5uU0m0tOPYmop
	 WANjmzmJN4/UWDwn5Aq4T5AiOBv5Ce9U1Us5ggO74HnDdG7IaTdtBODvHrRQaJwOTKbom
	 HGO4+HDSRwkgf9y3FTnHeE5jMkdp1Ht7Z81+2hk4+lslcwB7FBYD6aSNPCvBF2CEhj90w
	 5YgFzMHt+dIzk7afPiqWyHTVNnsBBQXZ0an6T2L55bRVPZ4GZOQGS2OVIq7uQikgLGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=51k1m/ocNPlnv6aLGZwkh3T81Bs2N3tGfQAIxbCEB+E=;
	b=fOmlZInrjW/6KJcZ62eUeqA7FltEiWHkM0fVBbYzjki/Dbn7/Nv9JCVhLt31Yp3mJtiv
	 gYTyBkWHaqGKu2GFNWTivjZnkvbhgDSM7BnZJHAMlQ4F2oXNuekScVtg/xRMpJtCDG0WW
	 XqDV8Q8MoEQB5nkXRVZeoaUlVSrt1LxehfrgAx+yRtqA2WdtaenceVlw7EgPAb0hXziN9
	 /g5LjE4XjgdJrs8PP22jiuBWnzrTilx2P94iaT30nG7mRAAsevYIQXIpHQ5mQZnWQbQAP
	 Hi6zLpMpfoM+dzgNkr6TDX8cLfexRVzkp/OCfFqMJ5zxc2hFYHfN8j4gfzH9hMRuIVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3k6St0r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE2606A33E;
	Wed, 28 Oct 2026 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3k6St0r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB771F01825;
	Wed, 28 Oct 2026 18:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211886;
	bh=51k1m/ocNPlnv6aLGZwkh3T81Bs2N3tGfQAIxbCEB+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3k6St0r4/YIp6UpFLVrv7wnHpnIMIPN5QSVQcekvGgkaJJ7CNMtqmQOBy0+Iprib
	 MN/gEcdfmg+3XGt8x+CELrvvGmMLc30uUy00N+T0X0KFjyrUnleZ4qP/Xi7u8umi9Z
	 0ckVLftionL3RtF3RjxDdsWtPxfuRaNGqyYRXAlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 535/571] Input: byd - synchronize timer deletion before freeing private data
Date: Wed, 28 Oct 2026 18:01:22 +0100
Message-ID: <20261028170020.726583441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit c83e79c0842ed29860648bcce5022ef0ba5001c6 ]

byd_disconnect() uses timer_delete() before freeing the driver's private
data.  This does not wait for a running byd_clear_touch() callback, which
dereferences the private data and its psmouse pointer.  A callback racing
with disconnect can therefore access the private data after it has been
freed.  The timer can also still be re-armed by byd_process_byte() while
the disconnect is in progress.

Use timer_shutdown_sync() before freeing the private data: it waits for
a running callback and turns any later re-arm attempt into a no-op.

Fixes: 2d5f5611dd0d ("Input: byd - enable absolute mode")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260720061259.1601281-1-lilinmao@kylinos.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ changed `del_timer()` to `timer_shutdown_sync()` since 6.12 predates the `del_timer()` → `timer_delete()` rename ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/byd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/byd.c b/drivers/input/mouse/byd.c
index 6e0c5f5a2713d..90553efd25224 100644
--- a/drivers/input/mouse/byd.c
+++ b/drivers/input/mouse/byd.c
@@ -426,7 +426,7 @@ static void byd_disconnect(struct psmouse *psmouse)
 	struct byd_data *priv = psmouse->private;
 
 	if (priv) {
-		del_timer(&priv->timer);
+		timer_shutdown_sync(&priv->timer);
 		kfree(psmouse->private);
 		psmouse->private = NULL;
 	}
-- 
2.53.0



