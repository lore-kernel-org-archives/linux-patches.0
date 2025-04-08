Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D97268685;
	Tue,  8 Apr 2025 11:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113151; cv=none; b=plztC2/8rEvoksaol2ruKiYZoVRnuJbEeAw4GpHpONJXfjZHX2y4MilCHH+AolzEy1Ix/yGYtNi1jXZgCLlUjro3jA0yLZruGH/N/JTiUC5QpTcQcRzku6yLAn4bSOr6aQVHm4RrKRPntMoYBLWgumx7UyNu0e4e83CrzkOGmQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113151; c=relaxed/simple;
	bh=adgxhVOSK6y5y7a5LzeZ+TDS6AgZQU4YAWeNInHzD7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l45Pq0EeW9p5R7Ol1D8ESlz6iTO5wP0VHDfy90NbfZ79oMywJLQz0Kfcjl5eivfnlJdlL7HlKndccGIF3xH0NwfXFlQQ5EvSCYkd66ZTRKLt57UdW1vBdxYiuFOup459SYQh3MqZ3RucSZxsd5xnUCx7m2XOvBm0j8q0HFkB6vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9GevoG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9GevoG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AABEC4CEE5;
	Tue,  8 Apr 2025 11:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113150;
	bh=adgxhVOSK6y5y7a5LzeZ+TDS6AgZQU4YAWeNInHzD7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9GevoG7biv6ikuaVQgmg8Fe9E0iXWo2FTgYPZPT8uGKGo3aPrEyYG0BFhnsBGtpW
	 vecNHLTv9t18YMeLvGm8GIszDeGSDrXnV2KDJebwy7Z4bAhAKI9yOt+s7C6r3SJfn0
	 4qb8nOxEqlYSVRZDZ2DlGb06CeQb9foI9oP+G4zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/268] media: platform: allgro-dvt: unregister v4l2_device on the error path
Date: Tue,  8 Apr 2025 12:47:16 +0200
Message-ID: <20250408104829.186262944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7dffea2ad88a1..4994a2e65fedc 100644
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



