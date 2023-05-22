Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA9F171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F05C4339B;
	Mon, 22 May 2023 19:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784846;
	bh=ozW99ARKrOKVH4wAAidgEU18+/tLSFX0mid2aRRYCN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HefLlig8d4G9jMKp2kkBNlmLMm7v1o8jJdf41G/B224Mi71omSu+fT6tZQ6KqQyXd
	 i5/19m3FtK/haqCKfVIj6/kgM2Xi18utGc21JM+uS0jCUhSGrDnoabWpu+NZkdJA95
	 wyZXBtQGvyJLwM8rg1ud37y05ddQTaTq7HzFh8mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 193/364] soundwire: bus: Fix unbalanced pm_runtime_put() causing usage count underflow
Date: Mon, 22 May 2023 20:08:18 +0100
Message-Id: <20230522190417.561842189@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit e9537962519e88969f5f69cd0571eb4f6984403c ]

This reverts commit
443a98e649b4 ("soundwire: bus: use pm_runtime_resume_and_get()")

Change calls to pm_runtime_resume_and_get() back to pm_runtime_get_sync().
This fixes a usage count underrun caused by doing a pm_runtime_put() even
though pm_runtime_resume_and_get() returned an error.

The three affected functions ignore -EACCES error from trying to get
pm_runtime, and carry on, including a put at the end of the function.
But pm_runtime_resume_and_get() does not increment the usage count if it
returns an error. So in the -EACCES case you must not call
pm_runtime_put().

The documentation for pm_runtime_get_sync() says:
 "Consider using pm_runtime_resume_and_get() ...  as this is likely to
 result in cleaner code."

In this case I don't think it results in cleaner code because the
pm_runtime_put() at the end of the function would have to be conditional on
the return value from pm_runtime_resume_and_get() at the top of the
function.

pm_runtime_get_sync() doesn't have this problem because it always
increments the count, so always needs a put. The code can just flow through
and do the pm_runtime_put() unconditionally.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230406134640.8582-1-rf@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index b6aca59c31300..7fd99e581a574 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -546,9 +546,11 @@ int sdw_nread(struct sdw_slave *slave, u32 addr, size_t count, u8 *val)
 {
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&slave->dev);
-	if (ret < 0 && ret != -EACCES)
+	ret = pm_runtime_get_sync(&slave->dev);
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_noidle(&slave->dev);
 		return ret;
+	}
 
 	ret = sdw_nread_no_pm(slave, addr, count, val);
 
@@ -570,9 +572,11 @@ int sdw_nwrite(struct sdw_slave *slave, u32 addr, size_t count, const u8 *val)
 {
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&slave->dev);
-	if (ret < 0 && ret != -EACCES)
+	ret = pm_runtime_get_sync(&slave->dev);
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_noidle(&slave->dev);
 		return ret;
+	}
 
 	ret = sdw_nwrite_no_pm(slave, addr, count, val);
 
@@ -1541,9 +1545,10 @@ static int sdw_handle_slave_alerts(struct sdw_slave *slave)
 
 	sdw_modify_slave_status(slave, SDW_SLAVE_ALERT);
 
-	ret = pm_runtime_resume_and_get(&slave->dev);
+	ret = pm_runtime_get_sync(&slave->dev);
 	if (ret < 0 && ret != -EACCES) {
 		dev_err(&slave->dev, "Failed to resume device: %d\n", ret);
+		pm_runtime_put_noidle(&slave->dev);
 		return ret;
 	}
 
-- 
2.39.2



