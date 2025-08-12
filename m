Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D39279915;
	Tue, 12 Aug 2025 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021028; cv=none; b=HG8ok2Vq1Qne46uqQIoESTrKO21H0aahSwxHhV/9FryLlJN/TqBeKn/FQDUXPMcUW/5qglXKiD4/AYBB8umKUVr2wQi2qJHY4o8Sb0kLdNk/SMw1U/NCd59B4FctrgHKT06wdsUfVKt00R4CsXcamJtB4Cqy9gQgEEmh+3/WYWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021028; c=relaxed/simple;
	bh=Uu8R8cowDIRDEM41TgLI9zueQaBuHq0PGt+jNQI6Xdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxzMFi/cU6ox87jIOWHw6cbon3zQfdAUeFs8V8Wnx3CcaeTzl7cbtzVg/lh7XyPDL+yKJerHEnLOSnFPKAThJlzAJYOMIQSknKGuNm8atEvTo/zbXPONGTFDy5b5Vm5a5QnMcGKmjlizem7C0AZ2S82TJ4Ll8Z82Ok7eIHKYMtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ell9aS+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ell9aS+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BCBC4CEF0;
	Tue, 12 Aug 2025 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021027;
	bh=Uu8R8cowDIRDEM41TgLI9zueQaBuHq0PGt+jNQI6Xdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ell9aS+Ew8hqGAuD9Ln2g98kNAFsSpOrj2j0iwQPWrp6pj0OyOKmPpeUk8FXZpmIZ
	 4hjV5wtlQEVSdOLEhuxc/DhZP8Wn9jxizkIA+WTLoheSJ/rEqi0IiNO99IzETxhQkD
	 l+OGBiCZfj7yyD90hXK92F7pGLrMSPCqu0rMCi54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/262] PM / devfreq: Check governor before using governor->name
Date: Tue, 12 Aug 2025 19:27:06 +0200
Message-ID: <20250812172954.580240692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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
index 49c542ecccde..7b991bbef489 100644
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



