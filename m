Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7957234253B;
	Tue, 16 Dec 2025 11:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884879; cv=none; b=tjG+QtiD9pYHJcNzpRxKKXrzd6g+n4qq5/3Peg5+D6lm1+VfzGZWpqnPR3eqgej8og9/Hi9jOwVHimUqe/HP9pLFYSFvptg6tO2rhylJ4EOVRBb3S/VHaCaIUZ99ACOO8YXz40u9BqQfyTqbLeKNPvrAivPQfl4cX6j2hINfetg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884879; c=relaxed/simple;
	bh=14SMYHbR1enNPsOpkAYXzdGq5j3o+8wBcIueWZZE5V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSlvWZXOZgiodA9Y4Vo+EfvENCaei+IeR8WbE3MjamgFK+ptFaoEvgbhD/mlENYUTYc5nqBWz9FhkLiNs1vRcn4EEM9x3xcmJh2JB7Gi+ijIowcIBy4uAe1UTbTro0COVbvhoXh4QgLx0qHIihgiIQCSoqKuuXAQrQyYaLXJem0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDLribe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDLribe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E23C4CEF1;
	Tue, 16 Dec 2025 11:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884879;
	bh=14SMYHbR1enNPsOpkAYXzdGq5j3o+8wBcIueWZZE5V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDLribe0AnZLJZnggoJh7vTACfB4df6FUREDrYSSz/1v22rxqggw9YlRD0p8l73VL
	 WIFTL/wHGZOnzbYtuVlStYRp0VQfb0XZ/AHrKI50XivCMAXN9Q9CSCaqn4vCbT+CRf
	 ypNMpDG8Gi1N093HOhAT9sFzpLFW29PSAOzkUbho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhur Kumar <madhurkumar004@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/354] drm/nouveau: refactor deprecated strcpy
Date: Tue, 16 Dec 2025 12:14:54 +0100
Message-ID: <20251216111332.756552169@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhur Kumar <madhurkumar004@gmail.com>

[ Upstream commit 2bdc2c0e12fac56e41ec05fb771ead986ea6dac0 ]

strcpy() has been deprecated because it performs no bounds checking on the
destination buffer, which can lead to buffer overflows. Use the safer
strscpy() instead.

Signed-off-by: Madhur Kumar <madhurkumar004@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Fixes: 15a996bbb697 ("drm/nouveau: assign fence_chan->name correctly")
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20251204120822.17502-1-madhurkumar004@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index edddfc036c6d1..65b7974defa10 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -197,11 +197,11 @@ nouveau_fence_context_new(struct nouveau_channel *chan, struct nouveau_fence_cha
 	fctx->context = drm->runl[chan->runlist].context_base + chan->chid;
 
 	if (chan == drm->cechan)
-		strcpy(fctx->name, "copy engine channel");
+		strscpy(fctx->name, "copy engine channel");
 	else if (chan == drm->channel)
-		strcpy(fctx->name, "generic kernel channel");
+		strscpy(fctx->name, "generic kernel channel");
 	else
-		strcpy(fctx->name, cli->name);
+		strscpy(fctx->name, cli->name);
 
 	kref_init(&fctx->fence_ref);
 	if (!priv->uevent)
-- 
2.51.0



