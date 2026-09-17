Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB26B4B44C4;
	Thu, 17 Sep 2026 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661073; cv=none; b=mqWSrthhaK7C86Hr1QWUaiTqoEiSytHDHqSZlCHBClTwleqzqAR3XwcYQOfdJRIyGHercq95oWY5pyPsb6edDcJGBG5E7dAf/TX5cCJruvNVr/ZijTtrEz7q8GPqhT3ZKhA//wdAQcRKFZnhtWn7cktQ2iPf5XdUpM/rai2f7A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661073; c=relaxed/simple;
	bh=UVBmmKpspWDMUysbdI37ZmEVrRAUgXe6vHpkHlCwnmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGeRefuqIBleJKUAzYXTsTQMNEgkouhxuXlxrqgUBs0KBt4dIXelV2vZmNDf5IoP3ZbbWDCFp5WVRfnK9dbhimu/gKyhw3LIMnL8MjKRw/+pUohfK8T9lbWnANNPEIKPAKobJTO13vDw4Yz/OnKhkPEAAJi++0JhHQ+IPbEKcH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vUnHyxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vUnHyxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D741F000FF;
	Thu, 17 Sep 2026 16:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661071;
	bh=/eiX/g/MjZa/mE0/4EbcT/xEft0Z5cqaHDPVVANNokg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vUnHyxO3ThO6ggHIKoIc+aGrzyfj+lzKc5xd7aMsXPV4Kw4OkI4WXQO/v3Ko86xO
	 gtqDvjsHUW0vv28IG4P1iQBSQi5e8IoGliYyl5QjJ5Nrklq1W5L+vxy0ad8n/SebUc
	 vFk+raEcO8nG8AzqFUjCXcI3iLbyKMwW2ASLzFCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0071/1250] media: em28xx-video: fix missing res_free() on init_usb_xfer failure
Date: Thu, 17 Sep 2026 15:57:46 +0100
Message-ID: <20260917151553.872764143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 14c35995cd952..c8514682bccda 100644
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



