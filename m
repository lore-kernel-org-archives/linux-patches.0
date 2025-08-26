Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B67528314A;
	Tue, 26 Aug 2025 13:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215760; cv=none; b=kbn6pgfXQVLMK8rBHFwIzphQnPtF0O1guJcvDDxbcJoC5l4hDqNu6mnl0OZJkW9Gd5Bll9LHZ4OQ/6uPxkYnDG8TjizQX96dFQnxjXKDdyKtq9WUSAn5ZdrUb6xVVH0ieQKlUZUJU9DUdShI/4bvu0FJp9+Dv2gxGe4AccbtQlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215760; c=relaxed/simple;
	bh=0qlrvmYK6poZla6xRQKwJY0RSCLnMZWV1OTIzlHZA4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPpaFqiCdvCGiBRCPZo4FfFslQ6Duze9hP2sn134Xf2cc/x4u7URxKhRZOMelrv+vB7kTbrQAXu+BhJcjAxMC7yXj+YKdkwbngZVZdHAd48SrUorD4sbdRxOJdAyWIZYmJ5HV9N6/dTDvcbujTPb/Mi7/ewzpneoztazPc4bvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwoSqQ0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwoSqQ0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B21C4CEF1;
	Tue, 26 Aug 2025 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215760;
	bh=0qlrvmYK6poZla6xRQKwJY0RSCLnMZWV1OTIzlHZA4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwoSqQ0wjkcg9BDIm+oDV4s//Ilfs25cD+80MLUz9WZNOTPQhEVpfglZDWRIyu0Gr
	 JSrVL1lVFq3klCHgabS94hvv1s5EAQOMfm2yHw19XCgLvbJafBRjanxPm1JptU5ZN6
	 6fBgM5vreza5G+s4gHL7NcSQOyX9DUJ947/LtUEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/644] PM / devfreq: Check governor before using governor->name
Date: Tue, 26 Aug 2025 13:03:39 +0200
Message-ID: <20250826110949.684634863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 237362316edb..02f86879a5be 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1347,15 +1347,11 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
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



