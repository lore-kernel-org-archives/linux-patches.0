Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD61724728F;
	Sun,  7 Jun 2026 10:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827732; cv=none; b=D051FTuakOepSN7WliA3q6yu6cm4SOoLAvXQbekYnXaCzKMrBi58Xut0v7pFBIUCZqidrhwxlU7VXJweyojFnXv4XfJVsPu36aGUT5weVVWHOF+D/corfhIVqHaDXwCdm6qCM4OiIu+gIeWiIv7NxRzLV7OnHfuSw31bRRLPEpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827732; c=relaxed/simple;
	bh=lsuqo1zlKAA2I+PDMCVIwT3p7G44WLC7BmtZTONakUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsHmwvZtVHRWqo19xaWQgGmobEo6tQAlAOfUgusPuL2pFX5xFWQgKXMgJH4oTwEcGSh5iZOGyyJvu49h+g3LpsxUgNszxVi6+FiftUCFwNpmI4xtu0OVOUOWzGE8jgeQ0JLfakZnJig0n1Yh13LExUwgBVUJ2fce/EFmMDpCxw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Vbvmxkx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Vbvmxkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCBA1F00893;
	Sun,  7 Jun 2026 10:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827731;
	bh=Sa1KO7j2cw2xeFie/h2FGXTi/7C4jvLZxzC/EiCUqS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Vbvmxkxtc+rtwTj/R6PgdJgrrdNDBprx2mD7/vzIaPCvQZim8dc01LOlGFIuBJUp
	 /GsDqwiV4uOa9RU2N3HV7zS9JuID/BxYrOnEV0gf5E6ZbJy+jt4c8Z8W15Yj1olBsy
	 q/3Ng31jMcNcTHn7rV68p2NzDccIu0du92UMSqFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/315] media: rc: ttusbir: fix inverted error logic
Date: Sun,  7 Jun 2026 11:58:03 +0200
Message-ID: <20260607095731.161756142@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



