Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EA9514752;
	Wed, 30 Sep 2026 15:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782445; cv=none; b=hAQ+cfQV60Qk/l5j6wUCvlkL4t/MgRwmYO9K4ns+QKHcQumrSKsQdaVJ/PfNmlCSxlTZUGHO1+81A3Drrz99HtoPwAr95MNOaBPtT5SKxAaQdfekFDqgVFxvulWhBsXJIVSPK8ITvyyKMeGOAv2vguAeAAHfN1hzyZGUK213aUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782445; c=relaxed/simple;
	bh=qF/eSYXKH/vU64bcmpksBYpj8OKvvXQSWZBrvhZujmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpi2Kqzwlbo14BA2/NFqdaAf0+udos/tgRziJQL1ZCqNmVv7at0nX7F61oAeuM/wdTWAopiDdqLoQaV4mqK3oVwRl41XxHZ1buNjjPmg/2QfLbX+xNoV8w/WoEH3yd4UC/d92eYLgJG+6GdfpdkUeE8fDVAQAyMwsH22r53y8XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LD/MVza5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LD/MVza5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A78D1F0089B;
	Wed, 30 Sep 2026 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782433;
	bh=++9Ly87OkmpqI0y0Ymf4ruhBTwt9AGamxThf+62m/kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LD/MVza5TD5vODZZIEjqCXvJlDRh/rwx6oAVTy5fyDkReIAT7o2rJpjfX2652vhfp
	 KaSbSU1FtEfeUUCzOVO2z0WQ03r4o6AjIeGpPwr6sF15lzzIhGIksrcwkmacxIctlU
	 Hhxb7Xi9y83EWnzTTSLeBQng6c0h160dg06txHN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/595] media: em28xx-video: fix missing res_free() on init_usb_xfer failure
Date: Wed, 30 Sep 2026 17:18:31 +0200
Message-ID: <20260930152348.114713603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b086b2abf082e..ffc7ae1ee3a9b 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1115,8 +1115,10 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
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



