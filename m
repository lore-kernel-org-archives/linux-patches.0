Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1327C2F745E;
	Tue, 16 Jun 2026 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628276; cv=none; b=rbzZNhOFHG/hbUzdXP+Oy5LXvduZELOPa054APhAOVKtyscVLlnm3Ud9+JI6GuGfOpNp0vATWNb9nvugtNRab1b3aNTJ+0ikPJTM2sXcqiyzeGOpewAASebO/E0b8gSKL6EB/7qzxmaBA9Tai8BmFLSugP8VCK5jLPQJIxM9pEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628276; c=relaxed/simple;
	bh=FMoXVLrM3LqaUJh+lUvSVehIfrif0UsU34O8JHZG79M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUfrCYlD+Zmm3HEzhgS4wBsPfE6BbsuccZSz67nP4RrwGOheknWIuZdGOK9sA4esBk++D3RTQfVzk91/ipA2HnUjwWX8PA5cm5qpoGXJyEcgtS3Q7iAKBDSII7CJgwYd6j2tptDWa40i1l+1hAHmoZm/8/uucurvoKBjUWRWBtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt1yVyUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt1yVyUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94D71F000E9;
	Tue, 16 Jun 2026 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628274;
	bh=slU8sJF7zUgSNoKyiD9oazvbEZa69R3Xvpmul2MfLj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rt1yVyUtC91DyWb0BqbNsF3py8zzpvueH7ibxe7nyKtkTC7bGUIwZZxSJyaS4SpUk
	 K9l5GFoANYM98tegsgcwuZwezsJssvOs+QRksHVzbVEuHhxZFamYWQA6troW9DDpJk
	 0pEjy0WyVw+CosaciQBXNnYbKmPBJx9DIphLr0Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/452] media: rc: ttusbir: fix inverted error logic
Date: Tue, 16 Jun 2026 20:24:51 +0530
Message-ID: <20260616145121.311324399@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 646ebdd3105809d84ed04aa9e92e47e89cc44502 ]

We have to report ENOMEM if no buffer is allocated.
Typo dropped a "!". Restore it.

Fixes: 50acaad3d202 ("media: rc: ttusbir: respect DMA coherency rules")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ttusbir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index a670d4b008cb0d..3452b5aefd2848 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -191,7 +191,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	tt = kzalloc(sizeof(*tt), GFP_KERNEL);
 	buffer = kzalloc(5, GFP_KERNEL);
 	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
-	if (!tt || !rc || buffer) {
+	if (!tt || !rc || !buffer) {
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.53.0



