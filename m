Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8813D4118;
	Wed, 30 Sep 2026 18:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793934; cv=none; b=qPwL2P0gp/5SGnOZW+BCMalEQ9xNBAoE5z3k15Xwn5y6s7JnCR5E0wItTeinf3XOTUeVBTZeYCKTpxeBHctO5kcwEZxTBBfdjrafWxO4lnVhBGtJQ0/gs/eZMDs78dfeXz4WQSJFkuNc/wsCkKkioQhsjB2E7G3V/tjmendzN8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793934; c=relaxed/simple;
	bh=2zB8ysOKBbwjadjkDNKUx8XThlmBTmdgdobaNywA2GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEg0MS7oBeWSCj4VgYxszYVzzCH9BdSV/UguD5Mb0fMctHFOWJIIzqnM1o55JHbSSSK0HdjuomiaTyTXk+BuVwYMs/aMx0XvHmqfiSd+6ORSV9zF9yoZv5yg3Nr/moIT7G4u7X8/c21rYsN68M5N9MFhIf3P3vP7QubMDZ7v/hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFM8bjHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFM8bjHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346EE1F000FF;
	Wed, 30 Sep 2026 18:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793932;
	bh=FsoxG2OOYuJ2NjZFV+j8S4VW43PNvLSy+QNwFZMN8OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFM8bjHoGEkYVg+9AC0w0pkJEJaGhvZqh3AjO+42hh+OHBOTS2kwct52Qmq7sYGX4
	 6oZo6NiEe0UN/QSYxB2xKi/OfmXILHF/QtFWIy3BIQYNT2tMfKvvN9FhxmuzLpztFN
	 eoeCFgsfc7EilL6vfsxVsomG0Q6qFD3e+j182qio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0033/1193] media: em28xx-video: fix missing res_free() on init_usb_xfer failure
Date: Wed, 30 Sep 2026 17:11:57 +0200
Message-ID: <20260930152435.024069211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 81fff2fe8c19b..a520bec031248 100644
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



