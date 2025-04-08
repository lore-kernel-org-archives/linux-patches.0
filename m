Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C22B2236FC;
	Tue,  8 Apr 2025 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116156; cv=none; b=Ry1uia1T8sdjDdxcASrHRmMWZR1bqpHmT9tYJpAV1dONmh5IsTmDFgbbCw4HuwPw9eSY4QyOzTJNmRNQkQMObfuLhEpR30cstgxvdNoNzcEbkW6BZUnxTvYO4wKvJAK+IdgQhjVpn7KKLVIOw9btiSRDItVZlndPS4PsDLpnx0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116156; c=relaxed/simple;
	bh=ce9kEy+Ryf3KJ7si4nzitt/dOwNhCZGfMSzpz0iiFiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkmTN6Mb1lbADwvuZ/OkldhVkMXTaRPpMQCvHnZxWDhRHeat+otVKEeMSSG0pMv48u3CDDt8S4BnS6Dkk1RudCHNnJJrT/SQNSSdnW+EbPLlmJowUTSExDhyC0e1nv6QsyWlippgwPqxm8X5v6ZXc+cPrtFLixbs0oSdFnftT+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBFus6QB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBFus6QB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239B6C4CEEE;
	Tue,  8 Apr 2025 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116156;
	bh=ce9kEy+Ryf3KJ7si4nzitt/dOwNhCZGfMSzpz0iiFiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBFus6QB1q/juf+n0efjjGonKja9C8blAf4312bWeMsia6mrNVIWzEK1meY4Rh06V
	 xPJXVnEYyAqIMhdqBQ92zJBfkQXLNtIOHjJVXiqdxk9irH1IYgjH1YL0aamGhjF1IV
	 GNeSNJ8g7O0zpr9c4aZaT22w5QntYY0eZ8L/p/u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/423] media: platform: allgro-dvt: unregister v4l2_device on the error path
Date: Tue,  8 Apr 2025 12:46:01 +0200
Message-ID: <20250408104846.566633211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit c2b96a6818159fba8a3bcc38262da9e77f9b3ec7 ]

In allegro_probe(), the v4l2 device is not unregistered in the error
path, which results in a memory leak. Fix it by calling
v4l2_device_unregister() before returning error.

Fixes: d74d4e2359ec ("media: allegro: move driver out of staging")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/allegro-dvt/allegro-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/allegro-dvt/allegro-core.c b/drivers/media/platform/allegro-dvt/allegro-core.c
index 88c36eb6174ad..9ca4e2f94647b 100644
--- a/drivers/media/platform/allegro-dvt/allegro-core.c
+++ b/drivers/media/platform/allegro-dvt/allegro-core.c
@@ -3914,6 +3914,7 @@ static int allegro_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev,
 			 "failed to request firmware: %d\n", ret);
+		v4l2_device_unregister(&dev->v4l2_dev);
 		return ret;
 	}
 
-- 
2.39.5



