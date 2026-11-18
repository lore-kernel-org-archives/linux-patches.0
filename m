Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039767;
	b=uUMJLasju3pj14VI/lOW0zddZ5jdkPl3quLPTsn8vcf0BKM69Rlpwjr/vZmOSq3rhQIi
	 b83tPtPhLsWCQ3u/uJAkUakUkTClPTtgYpFM90X+pL3fJkaQrkFltqWwAN6IoMkrGDCV0
	 d0sjoFI9soivmWckkoCJYE8Gd71gfJ6nUAa3gj0Ujcf3y0bYHrSblDatS7lIt+UEQ9J+/
	 c96pJxxJa2xoofDppYMKdGRI98CU5a7gPu6MKWx3MUMZeD2zimBU3SAX2A9D7OM8HQrTv
	 mozQC8InvuaroUPpa1HQ0GPgH8UJa97+FzhGmr5WepjK2IRVE8UZeEIHLDDoXNPExNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TX0kkGg5czlp6bTpXaHfHDZGARJyW1LM0ZhTbcDQGec=;
	b=K68N9t9sIN/SePGdOdcEBHu3EbdHaVSTOcYNDPdcr+ggAWTQEYf2k7EmZB6YI4puQYw4
	 mwni8PXwwIHOC0ICKHB89KvehRLO9lnC9vZuKwcnr3KPRQ4ckcK62lZd+J+UrZ23URn8T
	 nquOXuio8TsaSQYueHI48GvAIL33JsVpLPfafwHDsvGDpCHw6iv9lScmpv0ySOfw2Qgna
	 mTRzG/khNmrY3RB8+q8ZdhpZd9uGP++GCAd44mruy4UAKUJ8FcNNlxPjOoRYyN3xp2jUX
	 aqAXmKdx/bt0WM+bvDg1TuP7R6IDYJrQxllGcCL7Fs8XCop8QewNGZZRZPVtootlKGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6QDvv5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E5F606A320;
	Wed, 18 Nov 2026 22:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6QDvv5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5791F000C4;
	Wed, 18 Nov 2026 22:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039767;
	bh=TX0kkGg5czlp6bTpXaHfHDZGARJyW1LM0ZhTbcDQGec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6QDvv5R4UE2WmCi3Ed3txFFZKA5m6m3TK751jN9G3+W+yISj+MjwfJ8cErWP3qOE
	 fK2smkVyivlO3PJ4ksxvXrOSWHnpDtHh85ZiZ1jixgJ1scedjI+jV4dO+sapA/YXDq
	 hKtXdYoGcxDUdVG7A+kJVXGe9yx1Mqer3WoUgaY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2217/3318] firmware: imx: dsp: fix mailbox channel leak on kasprintf failure
Date: Wed, 18 Nov 2026 15:47:19 +0100
Message-ID: <20261118150428.408780547@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit e3631d0242842940f9e902afaea98202e56277e8 ]

If kasprintf() fails while setting up mailbox channels, already
requested channels from earlier iterations were never freed. Route
the failure through the existing cleanup path.

Fixes: ffbf23d50353 ("firmware: imx: Add DSP IPC protocol interface")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-dsp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/imx-dsp.c b/drivers/firmware/imx/imx-dsp.c
index a48a58e0c61f8..0bb224861900e 100644
--- a/drivers/firmware/imx/imx-dsp.c
+++ b/drivers/firmware/imx/imx-dsp.c
@@ -99,8 +99,10 @@ static int imx_dsp_setup_channels(struct imx_dsp_ipc *dsp_ipc)
 		else
 			chan_name = kasprintf(GFP_KERNEL, "rxdb%d", i - 2);
 
-		if (!chan_name)
-			return -ENOMEM;
+		if (!chan_name) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		dsp_chan = &dsp_ipc->chans[i];
 		dsp_chan->name = chan_name;
-- 
2.53.0



