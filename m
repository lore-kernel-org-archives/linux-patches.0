Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CC3224239;
	Tue,  8 Apr 2025 12:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115567; cv=none; b=RDCP8S31Z0f32zMvCQr8LBqpqZU1q252J4HOO69rxr+WrfcpTMvyfBYMJ4wJO/XVaa2Zk7/3uskssN5bY5DhclmvhMl9UOGezredIfkUbLNpZvYj2VjQUm514O1FaZX+BuZJG4eOTN/OIfyEroHRaYo+AibHEEQ/BXd0bLubSeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115567; c=relaxed/simple;
	bh=1e0w9ext9BaGL9qpZstPfCxdaca1fsWv6v+4ODWrJs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgy8ASlhjCMoTEXMkC2ddB25Pwmy+JGMdD44hJq1iSLLav1Ac90VzSaW+AGdrkyjgHDshCu1mKIo8hKLd4w3lLBSm0DeZaEpvGsKOwTR5RtLY2yvsJ/YpK1AeZ55wGBXFfDJcYT5u4Q32wiSpV9xJtTRL+lmzcAfL3p27M+zeRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUZVQy0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUZVQy0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F3DC4CEE5;
	Tue,  8 Apr 2025 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115567;
	bh=1e0w9ext9BaGL9qpZstPfCxdaca1fsWv6v+4ODWrJs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUZVQy0cTfq477+wK0jFQAVb1FfekwTHevA50ZWDsFGSGImigrGSmG7CBtUDtb4XU
	 2YBtwRmI5ngXE3gfgBBGnQO8fOlKJzXjO/ggzr65hlXPlQMLMAfhTToAFgu5Cqp7kn
	 tSzodJQ/sGmj6CYcMOxNT/ATI46fO8fGat9eyIis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/204] media: platform: allgro-dvt: unregister v4l2_device on the error path
Date: Tue,  8 Apr 2025 12:49:12 +0200
Message-ID: <20250408104820.971558529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3cb4618d23375..1a556e381eac8 100644
--- a/drivers/media/platform/allegro-dvt/allegro-core.c
+++ b/drivers/media/platform/allegro-dvt/allegro-core.c
@@ -3915,6 +3915,7 @@ static int allegro_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev,
 			 "failed to request firmware: %d\n", ret);
+		v4l2_device_unregister(&dev->v4l2_dev);
 		return ret;
 	}
 
-- 
2.39.5



