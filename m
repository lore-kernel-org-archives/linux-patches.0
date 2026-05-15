Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535343F6C30;
	Fri, 15 May 2026 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861083; cv=none; b=PxpWPs5xXRxE7YrvMdc6RMFaL2rdenf25CN3xSawzmxYzWlqHUm3UfbJPlSQG6x8sx21AHcl6UpX5sAkUL8MJUbgXBI8s0CWSJkjsyfsiwSabBN9E2hmSeh8OoOssymqEwkbU5mwOxJwDzBPGiYrBsc+js0hbgz2m/Op3A8XkaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861083; c=relaxed/simple;
	bh=fgD7HhFKxbBfRzqkUgo85sN/REJoLZzCUq76y5hN6/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IkfNwfOzqdPdnWkiLe8d+myRhgaZNlL4RtN1pXIkAX0fmIqsDWRk1ojqQIayWNQqwT2RVHGeQ7dUc/bKh5d7m2rRDGlwctiYUMyjz6f69K7EmBLvfuRR/W6n1r+3x7X06SyTkgg4nhFmy+mIFAYLAF4itgaNXXJMgEmQdyI8ryc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFAIEUPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFAIEUPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2C5C2BCB3;
	Fri, 15 May 2026 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861083;
	bh=fgD7HhFKxbBfRzqkUgo85sN/REJoLZzCUq76y5hN6/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFAIEUPg07e2v7rB2OsDXwrrDyIZ3GWvO1mDb9iEvMqSuD13GI02J6bHQ1HPWig4C
	 NL+y/Y1qz1j0Unmcxb+4Lxob7AhstijToHT2Dwj966AiLIx+0m/fDqBwraFNnEC9+e
	 3ykB870JeQfbmYgKKmDCzx8enwQ21vUsQ9H7NuC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Tristan Madani <tristan@talencesecurity.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 191/474] wifi: b43: enforce bounds check on firmware key index in b43_rx()
Date: Fri, 15 May 2026 17:45:00 +0200
Message-ID: <20260515154719.153232694@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 1f4f78bf8549e6ac4f04fba4176854f3a6e0c332 upstream.

The firmware-controlled key index in b43_rx() can exceed the dev->key[]
array size (58 entries). The existing B43_WARN_ON is non-enforcing in
production builds, allowing an out-of-bounds read.

Make the B43_WARN_ON check enforcing by dropping the frame when the
firmware returns an invalid key index.

Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Acked-by: Michael Büsch <m@bues.ch>
Fixes: e4d6b7951812 ("[B43]: add mac80211-based driver for modern BCM43xx devices")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260417111145.2694196-1-tristmd@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43/xmit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -702,7 +702,8 @@ void b43_rx(struct b43_wldev *dev, struc
 		 * key index, but the ucode passed it slightly different.
 		 */
 		keyidx = b43_kidx_to_raw(dev, keyidx);
-		B43_WARN_ON(keyidx >= ARRAY_SIZE(dev->key));
+		if (B43_WARN_ON(keyidx >= ARRAY_SIZE(dev->key)))
+			goto drop;
 
 		if (dev->key[keyidx].algorithm != B43_SEC_ALGO_NONE) {
 			wlhdr_len = ieee80211_hdrlen(fctl);


