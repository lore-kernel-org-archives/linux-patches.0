Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED83502795;
	Wed, 30 Sep 2026 16:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784209; cv=none; b=Xey+oW2OVEbFykHFfYibCkTqW3UWn86FOW63WeZLENXgV0WTtfDeJ92gibUV1zJqnndnwUYzVrTdXigxswGvqMSjbXhHmzYdNULyIgHMlydlCk0b2Lr7isY3WqzZLz+nr3iayML5CZSrzyuEAkKTYACfjWBg8yipuvJozTrLdBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784209; c=relaxed/simple;
	bh=1by2pDWq24CD/AjC59pcsUvbi96dGNUA57R3SJgBKHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzYf+OWYpq5SJxj3u5EA2uCYQDzat22zsmFwwM/zvGIwoS9b3nSL9eqIdOTJuoijCR1gLlOq7VsWe/PStH0XHdTjeiI7O3osvsVi445oB1U+5mP1LCKZDlp2FXcNwCkQAJwgbywH/VtH5RxKrZlWo+uK6j9nOBg1/k28WK/5keo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skYVwjYB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skYVwjYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF03D1F00893;
	Wed, 30 Sep 2026 16:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784207;
	bh=jLnVlM20YuopQL2x9+dGkvq093QIp9o4VxKmy8YvYSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skYVwjYBf9NrHi99atC3RfOvSQaF8SPk9xxiQtK6VH006xrRBvA5FYgZU3lfbM8GJ
	 rIrnai82lneRH8GPKnnv+wXSN2H+VYcuK+U6gXkzVO2qOASL1J4lUq/fVWOJPKr3/f
	 KEn2hQKkTqBkxKSscD2PUcpTC7pqJBOlKDoGvctU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/982] media: em28xx-video: fix missing res_free() on init_usb_xfer failure
Date: Wed, 30 Sep 2026 17:12:44 +0200
Message-ID: <20260930152417.400598170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



