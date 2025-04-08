Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557762135CD;
	Tue,  8 Apr 2025 11:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110429; cv=none; b=hOU5OpZI+RHi8SzaxdtMROUg9tjXtSRJfVNiCcFSAgSRIrB+RqnF9JHd7K/2BFt5/hlCObICyqeIfF4Kk0akcw1mRgDEo4HS9LTl461asnxWzmKBgq2l/HLyVR/3HK65cVsJw/Gy7pfieEdjO8tHjiVwP7SdTRlLJGzHge7VEUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110429; c=relaxed/simple;
	bh=Ucr3nLSFkQDYiLMh0ZqZgP3eJgt+Jkr2Q/dWmjSf78Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsMI+9IsfxAZ9Mn7SBHUDHI6RRPCjda151puNPoKDUiAjrmNqZ9n6Fjrg2FkDYbkH/9X115UNc/yWlx6Hk7YHp/xe418yy2xyh4TqArvOQj3niEWL/TsV3Mheat2sFCD5yf2ZmdsIgrw/GRu4BBYDbnf1culMt/28lpGcvV8tf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUSWPPMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUSWPPMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE2FC4CEE5;
	Tue,  8 Apr 2025 11:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110428;
	bh=Ucr3nLSFkQDYiLMh0ZqZgP3eJgt+Jkr2Q/dWmjSf78Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUSWPPMz4PIiJcL9LJFQpTtUXmFuyGYv7FQohcMl91w81y2CPFq6W/yYBzxe4ojNb
	 ptm/vJHY4AsOYnKVOxIg76GQSnepG3357RlukzbyAP51aB7Jn5SdEEPrBM3RNSxPjj
	 H6d7d7Yp1GV0hW1/rNGHxVa0l3SLsJ1qHosyuIGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 060/731] media: platform: allgro-dvt: unregister v4l2_device on the error path
Date: Tue,  8 Apr 2025 12:39:17 +0200
Message-ID: <20250408104915.669285259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e491399afcc98..eb03df0d86527 100644
--- a/drivers/media/platform/allegro-dvt/allegro-core.c
+++ b/drivers/media/platform/allegro-dvt/allegro-core.c
@@ -3912,6 +3912,7 @@ static int allegro_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev,
 			 "failed to request firmware: %d\n", ret);
+		v4l2_device_unregister(&dev->v4l2_dev);
 		return ret;
 	}
 
-- 
2.39.5



