Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB2242049;
	Thu, 15 Jan 2026 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495943; cv=none; b=WV7QYaKFIm4tR7ajO7HlBi6SWTsnmwFfEzXRIryb866SZTl1PkFz/K4iLb2RHgStBkxFj4b9aEJq54FjgM3Lum3zxm9SvFZjCrrtD0xmyQ/Ge9d+auaUTbaBwSJi5/0wUMyKqfEZ4CX5d1YSTL+wbnK/XxR2MomNSwbHnzFSR38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495943; c=relaxed/simple;
	bh=7WufcnBvS4OminWrF/pjf2H1Yt2tBLH5llp/SJzxvW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDwvQEZLt21uNTmAh21QdAMsPibAnAhktQcBn8HcuBKnPaGZfiSX8+ydTnSe/xNXaU9+l8349/za9C2HgMKmMX+rVHt4y6uYVe9V4AjJqRsJQszNQ3a5BxuP7kMt5nzc7AQufWu4P5UODkbPXroOoHYCmuhOlskCTls6DWstuv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sp9/NTt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sp9/NTt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDB8C116D0;
	Thu, 15 Jan 2026 16:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495943;
	bh=7WufcnBvS4OminWrF/pjf2H1Yt2tBLH5llp/SJzxvW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sp9/NTt3KPoU20E42QSbO1GiXcv75FzxCu9qwL9u55/rbE+gv0WmZmf2ARTt716Zu
	 brBb2x54ByOFNQQE4EHmTmnrzgBCbzrYBp2K/tCsU4698lWGrOAPDv/dnGex/vTQ2Y
	 B+66dOpLTPpy7I3OHZdmM4fc7fx1nVWCqjmGvSJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 022/181] ALSA: ac97: fix a double free in snd_ac97_controller_register()
Date: Thu, 15 Jan 2026 17:45:59 +0100
Message-ID: <20260115164203.127728377@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 830988b6cf197e6dcffdfe2008c5738e6c6c3c0f upstream.

If ac97_add_adapter() fails, put_device() is the correct way to drop
the device reference. kfree() is not required.
Add kfree() if idr_alloc() fails and in ac97_adapter_release() to do
the cleanup.

Found by code review.

Fixes: 74426fbff66e ("ALSA: ac97: add an ac97 bus")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251219162845.657525-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/ac97/bus.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/ac97/bus.c
+++ b/sound/ac97/bus.c
@@ -298,6 +298,7 @@ static void ac97_adapter_release(struct
 	idr_remove(&ac97_adapter_idr, ac97_ctrl->nr);
 	dev_dbg(&ac97_ctrl->adap, "adapter unregistered by %s\n",
 		dev_name(ac97_ctrl->parent));
+	kfree(ac97_ctrl);
 }
 
 static const struct device_type ac97_adapter_type = {
@@ -319,7 +320,9 @@ static int ac97_add_adapter(struct ac97_
 		ret = device_register(&ac97_ctrl->adap);
 		if (ret)
 			put_device(&ac97_ctrl->adap);
-	}
+	} else
+		kfree(ac97_ctrl);
+
 	if (!ret) {
 		list_add(&ac97_ctrl->controllers, &ac97_controllers);
 		dev_dbg(&ac97_ctrl->adap, "adapter registered by %s\n",
@@ -361,14 +364,11 @@ struct ac97_controller *snd_ac97_control
 	ret = ac97_add_adapter(ac97_ctrl);
 
 	if (ret)
-		goto err;
+		return ERR_PTR(ret);
 	ac97_bus_reset(ac97_ctrl);
 	ac97_bus_scan(ac97_ctrl);
 
 	return ac97_ctrl;
-err:
-	kfree(ac97_ctrl);
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(snd_ac97_controller_register);
 


