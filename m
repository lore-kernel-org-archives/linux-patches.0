Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208352;
	b=vNJLc1BzQmRVASa27+xvzY6dC6Chv2h0AldVOJoSTvpFDmYML1MRL5gW7MSnZ013pqtc
	 2Kzgt8RQMy9GC0yG/qDqdjacGtKq27+x8RLZtEcqFVJixGRt/rMFZZrWSoOf8cQ+QNVEa
	 yY8MOt6Ya+IbcicL+KwVVTXcCsyK9vBr4EbsussFdRKIfzOWAHFGcxb4bZZo716uGllES
	 zG/YmPpgC0lTQVIBLrCkGNVU91MOL7vVxWnaFtOl+eUxPs/BgsyEsOMM6FoCtFVCtZxoO
	 hN9bSroYyWR+ac4M20x/TdI+zPLqpi/V9FSGjodHrJ1e3BHqSSAsYk0GfZ5XSF196Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GdoNkKf43zNqH+U1/zSIMUDIOG7KarFpShrafMmFAFE=;
	b=1w9jkiv0veMP3prUyhmDM5UzUCdoWPar5SfQoRVoqy5vyCNVWa2FZchtGVmn/cM+n1xg
	 NPASzndqfFJzVo8Y/a8N2rMnP3aimgxcQ3qXnwMz1gLT8ItppKyemC9TMkqD6lTkQI7Bw
	 sHLjukR9+frU0NSIFJhOUROrtG+t0Frcajipx/3NLI2/oOT+NuWpBdlsYYSs8kbgcjA2J
	 yqdHvsFG82cPNQ/yfu6FPM9T90HuITjmuHblWSVLlEoigNo/d8tJ1YPFrT9UfKyb833yQ
	 4aKyvRWtEbofF8xyRYaVkIgIlcqVy/Vq5avv/l0HBvWOJWqVBL0m8W511qWU57fm0KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjuXmtui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96DB606A31E;
	Wed, 28 Oct 2026 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjuXmtui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155C21F01828;
	Wed, 28 Oct 2026 17:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208351;
	bh=GdoNkKf43zNqH+U1/zSIMUDIOG7KarFpShrafMmFAFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjuXmtuiuqNZrm/IqP8S4QQpEzcELUi/icz/0lIaPfRUrSQJ9k2hW8iSAVhSIHIcl
	 ju5LPlK5zuTG3f8vLuFed4DfOaRENlBznJmNSW8KR6c6WHm8aXpRIHISKkhKu5xX9m
	 nk9+JRADEQCPOIi7hIhvS6slRZtNqsp+T1H8ca7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/516] media: zoran: Avoid freeing a registered video_device twice
Date: Wed, 28 Oct 2026 17:54:00 +0100
Message-ID: <20261028170005.603741215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 0735e0b5a96761a9ce277a238e834008ad92a0a5 ]

zoran_init_video_device() installs zoran_vdev_release() as the
video_device release callback through zoran_template. After
video_register_device() succeeds, video_unregister_device() drops the
registered video_device reference and the V4L2 core eventually invokes
that release callback, which kfree()s the video_device.

zoran_exit_video_devices() called video_unregister_device() and then
kfree(zr->video_dev), so device teardown could free the same
video_device twice.

Remove the direct kfree() and clear the cached pointer after
unregistering. The pre-registration failure path keeps its manual free
because the video_device was not registered there.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 82e3a496eb56 ("media: staging: media: zoran: move videodev alloc")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/zoran/zoran_card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
index fe0cca12119c7..9ee30b70b9d9b 100644
--- a/drivers/staging/media/zoran/zoran_card.c
+++ b/drivers/staging/media/zoran/zoran_card.c
@@ -831,7 +831,7 @@ static int zoran_init_video_device(struct zoran *zr, struct video_device *video_
 static void zoran_exit_video_devices(struct zoran *zr)
 {
 	video_unregister_device(zr->video_dev);
-	kfree(zr->video_dev);
+	zr->video_dev = NULL;
 }
 
 static int zoran_init_video_devices(struct zoran *zr)
-- 
2.53.0



