Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBD11EBFE0;
	Tue, 12 Aug 2025 18:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022100; cv=none; b=DZcLH/jTWP+JXSraaa++N3UpM68JiDGyQ/AZxtuJM+Mm6o8+aHDFnb2rmcIjajnl5id4qsC4ri4fMRk/RNy2e1U1pwCuyytGE5enpa5bljhYIbV338tCtx5b2JyQEdY193YpNYHqKzHJ1jMq82oniXf/xCdanT4buXkfAvq/kTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022100; c=relaxed/simple;
	bh=Tdeih4V1AA69ZohvDF/SXP80bZFMvnEYFzWPamb4my0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apiw72PMrdAVBYqdvJxAmThmGxH1mTe38jecpX74peQBF+NpqHRaQnCmFIx0yaEDYd5jdiCDyRD9amsY3/RWWJCZvaikRDQRw832QH1YUH53Be/8Dr8O34n8ba07TDUG7xtdyYqpKQEkIvt4/7CqNMGzkO+KWvg4aDxaVXOdVqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rK9ITyUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rK9ITyUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9043C4CEF7;
	Tue, 12 Aug 2025 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022100;
	bh=Tdeih4V1AA69ZohvDF/SXP80bZFMvnEYFzWPamb4my0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rK9ITyUjlRilAUPwTwThuGO2DytKjCpAbWlHUfjd6VnOb+N98mcSSFU1/cMF5QaO4
	 jujJzwv9eSkg1BLd56nzjZanybsXcMx8cg+Dnj8B0yH7fFdByYMjeqAZiqtSHgHQtr
	 xiucfSAlZ8y+WtpKdqTVN9jVGKoMGi6U2uve+Gdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/369] PM / devfreq: Check governor before using governor->name
Date: Tue, 12 Aug 2025 19:25:52 +0200
Message-ID: <20250812173016.833859761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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



