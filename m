Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AB23C9EF3;
	Thu, 17 Sep 2026 17:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667424; cv=none; b=PKF2e59yN7JOnuJK5iamGjagwzeI8l0Iw4zDanGqhmgAVuQlRRG1WtOa0m9QUw36nFDI2YSt7IQZsj10c+ziA3e5pYWfbwZOm+FLazHaQdtbK0FEC8Au3JpWbxhBV95vjCaSRz0NIQ2QSlUKrtDa+UMpaZsng5EtVY65EFyu9Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667424; c=relaxed/simple;
	bh=m8HJvwKyPsfFaNU3ffukk/40mC7Ooz4BbP6EvPey6aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJeG2jjF6qhCH4luv5RwFW51u1i9FIuVF6K36AWlD5PivPYeLHrYFwmG7njNwAu+igTH7wUZ0/hkyq8++Bv3fMy0s6AT8jYPva1J0F1KqeIHzhEqMBrRsA6oUQRTYAXxR/iJ/NQEGjUfTXQQSHKT9Mm+ClVrqoRqEXNx1yWYUEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7NUm8aR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7NUm8aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40FA1F000FF;
	Thu, 17 Sep 2026 17:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667423;
	bh=HHGmW37RLeMarcUFrmND/9P9jh/FDItKvUcoJ8PAvCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7NUm8aRMkgDH7ytNVwVAE5wzz5inwSQOc9QpJLrC8LD84+0pSBTM2/8jlIQzTLlG
	 WyXlwzWxmMInv8eiRUAMaBoVkzfrzLfsE2LP0OziyJcmXKirpG5zbTekqnImDMahFK
	 cSBGKXW6Xlri5janCXXbDlxAApxk3m6w8XystV1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0050/1102] media: em28xx-video: fix missing res_free() on init_usb_xfer failure
Date: Thu, 17 Sep 2026 15:59:53 +0100
Message-ID: <20260917151540.705623359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit cc20e81da6d99926f94fad7af21f75c07e865769 ]

res_get() is called before em28xx_init_usb_xfer(), but the error
path of em28xx_init_usb_xfer() does not release the resource,
leading to a persistent busy state.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 5d89894d6868d..dd0cf2ebcc5b6 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1105,8 +1105,10 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 					  dev->max_pkt_size,
 					  dev->packet_multiplier,
 					  em28xx_urb_data_copy);
-		if (rc < 0)
+		if (rc < 0) {
+			res_free(dev, vq->type);
 			return rc;
+		}
 
 		/*
 		 * djh: it's not clear whether this code is still needed.  I'm
-- 
2.53.0



