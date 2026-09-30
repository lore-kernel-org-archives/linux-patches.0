Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECCA5237AC;
	Wed, 30 Sep 2026 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790634; cv=none; b=NAJ10k/ZXthXN/GdVeO5FimgEop4sgFFudjuEDpG8kDUMf1ULHCWD+f/l12kFzBHnHQpAdUunVI+zYsxLxNTATU7HOMoVySzYTkqoHUv0igjsEAOKUfLKCSTH8Tmx8mFV55LV5++3xFSfE8rZ3s0ySIEvSFeZ3E2YMDwZ652xZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790634; c=relaxed/simple;
	bh=JoH6MEHDubLQkdAi/7cpIjVyIVOVY5Bpqmg9cHl08sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RckHYrPeqiwgcTc7prsMB3BsQ+Pw47F6xW24tLo5+8WLCj+cmo8C8JrUdmJbKBQ65qVcfyPmxxt6/NcyaqC+uwxs8yAJSkKh/vX8OqCMlC0eWiwYJJbI2NEuMSyLL2K+Y4Y0MrDEgcufvQYQupFfZesucq+X/vzDVAT85YNVVJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQALTAdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQALTAdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42E01F000FF;
	Wed, 30 Sep 2026 17:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790633;
	bh=9JMjHWjBELGm+9fAlIp/BunWuB1qbSoNDpkku3KDBr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQALTAdvDlzgK+9Yh1EPrFZ5kOEbNQVe0g5DJwfvWkE3J4Y9xnXSNCrhD+lRMZ0EN
	 Na91mxmVTMG6HG2upXRtCraIU4Vh/zDPdu2/i0zhjlwNu2kRWbcoxVxp4Mir2cnNnF
	 X0Gnyy9mhd+3pYfHYIWYAn1ArNYVb0qbClkKabW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/752] media: em28xx-video: fix missing res_free() on init_usb_xfer failure
Date: Wed, 30 Sep 2026 17:18:10 +0200
Message-ID: <20260930152358.587229474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



