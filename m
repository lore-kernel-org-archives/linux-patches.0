Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0786BB5B;
	Tue, 12 Aug 2025 18:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023525; cv=none; b=E2nCo0ew9gYQuUveXErlEA6w9xpzff9gUaIdIhLb0+NdA+rN/C2ZIFsVmORTWLFyapqPQPTDZ02961O5Vrw+lGqVjr8nsTztOgDFAJ+DSSBCwhKLxr+LFcsMTCUWfROn3VXxqMP2feeEWejovs4UF1lvkbvaf4BJVvaKhTJkD30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023525; c=relaxed/simple;
	bh=AR1rW2z08toU5hB5rF/qsEg9Ho5l4V1ULjZ+3yG0MSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkGJIYci+KFBJQgZGs1uuoY3A5pHti65+caqqTQ+Y/RNYQ3qLnpOl6JpUpGHYRrNQCb55RlY0lSbcvG7TLahduM42/XOjHk2F8rpH7W4KdQ0qfmfw+bJbIvbYAZsqeS/Red+BJYwr1zWbG0SeDRLTz0f/rI0M1EKZyOwCjOHydg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suGkTS/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suGkTS/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEE4C4CEF0;
	Tue, 12 Aug 2025 18:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023525;
	bh=AR1rW2z08toU5hB5rF/qsEg9Ho5l4V1ULjZ+3yG0MSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suGkTS/R+r96yFh+0XBhVRPE68pFyoB/bDoBTZPhVu+4coqnf9fG8F7t5CgdQmjN2
	 Z0bH4+7LEHYcbryIcvo9QVQUp047sAiHjsZ6YrYmA3K+geoQ9+YH0Dy9d0yPJjpf0X
	 WrhD6YuQnWD0fymnrJ423NAKgz/s4jG6BujWUGJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 106/627] PM / devfreq: Check governor before using governor->name
Date: Tue, 12 Aug 2025 19:26:41 +0200
Message-ID: <20250812173423.346441689@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



