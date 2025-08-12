Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6522921C187;
	Tue, 12 Aug 2025 19:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025690; cv=none; b=t05FVwe/PM0GF51yA60BT2Cufi6gvXH6X9F/bU7G0TOKrWWjdKOjvznSGM26qjbBcfBK9BWhM6pyaoBj5hP6qpojOkbvSGEQD1s0ui0FU5TfEbubU2qQjWWcMkxdUqzn4mQV1ag9MDUh/g4a5wrnejjj3tWIaq/yhzfHkytmORA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025690; c=relaxed/simple;
	bh=4fxro1Q/fHEpbj9v8kpk45IZwj0aLIeMoz7X2MMu8LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9Vvux9Tb8jDXV/zhjriruLcTIM7+tBRPKTsixMLc8NTIFzUivZjDbK6J6Wi7rzw55DAIn2ceMfBog69ptCJVrCZ3IwhBEj8eArD5Yo8WMFhR9Lp7L2eE/9X/BdZYCln4loxa8uxbVRXmYy8V4VrfWfWiCPrwxQevx1V0N8JDQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxNYhrY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxNYhrY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CD8C4CEF0;
	Tue, 12 Aug 2025 19:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025690;
	bh=4fxro1Q/fHEpbj9v8kpk45IZwj0aLIeMoz7X2MMu8LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxNYhrY5GHAD3AEr2t0PK3CoqQdvba4NzqCAXKK7OK48kZa1/F81ASOMkeshcnlAO
	 NTloBuNGfH5zXcz9fzt2+vgpaelAe6gVO1JcZxyQXaNUbtfT32CnSmrIcQwEyNNyMu
	 SslY+frFjC+7Gqt4m8VJoaXocG5Ba+zFdpVxWO9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 082/480] PM / devfreq: Check governor before using governor->name
Date: Tue, 12 Aug 2025 19:44:50 +0200
Message-ID: <20250812174400.830477985@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit bab7834c03820eb11269bc48f07c3800192460d2 ]

Commit 96ffcdf239de ("PM / devfreq: Remove redundant governor_name from
struct devfreq") removes governor_name and uses governor->name to replace
it. But devfreq->governor may be NULL and directly using
devfreq->governor->name may cause null pointer exception. Move the check of
governor to before using governor->name.

Fixes: 96ffcdf239de ("PM / devfreq: Remove redundant governor_name from struct devfreq")
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://lore.kernel.org/lkml/20250421030020.3108405-5-zhenglifeng1@huawei.com/
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 98657d3b9435..713e6e52cca1 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1382,15 +1382,11 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
 		int ret;
 		struct device *dev = devfreq->dev.parent;
 
+		if (!devfreq->governor)
+			continue;
+
 		if (!strncmp(devfreq->governor->name, governor->name,
 			     DEVFREQ_NAME_LEN)) {
-			/* we should have a devfreq governor! */
-			if (!devfreq->governor) {
-				dev_warn(dev, "%s: Governor %s NOT present\n",
-					 __func__, governor->name);
-				continue;
-				/* Fall through */
-			}
 			ret = devfreq->governor->event_handler(devfreq,
 						DEVFREQ_GOV_STOP, NULL);
 			if (ret) {
-- 
2.39.5



