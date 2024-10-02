Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F881D0164;
	Wed,  2 Oct 2024 13:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876589; cv=none; b=KMIF9Q9xBOFaFcKZaR8+nh6UmbXZmabv1vq6zpHEZRMNLhlbDzOPijycIuiqK9EXc4AZNSuj1Qsey1wjEBZrh7BcSPoeXuirgUAxdt7AvA53TZ5Ik7pR4itUR3e/yc0Vy5CQ30zwHl3huFXO2l2sFYNijeNxm1i4BZ2ur1zfJgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876589; c=relaxed/simple;
	bh=bqIAhEFa21Ynl1iFA9RpOJjp9+yWz1C9YYy4E4ETNQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUBK8QN2LTKhf+9y2dwtJqMfS/rL5X23uvozm5zjBGvBe3i117dI0Q6Lm0WaUwwVXM9MvQj1aCBPBedGJPiEvYmH4Tjlz8VMjW7bJOKzEuhIh9DCusQRCKfxTNpmOAPmw7Nx1m7Fe99NiW+1AcyCYZY4ltDSnaJX9hnF3lRGpOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp+2Ccrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp+2Ccrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7213CC4CEC5;
	Wed,  2 Oct 2024 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876588;
	bh=bqIAhEFa21Ynl1iFA9RpOJjp9+yWz1C9YYy4E4ETNQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xp+2CcrrsZSPMLSw4S3ouTKZg63mgUd+90mgSXqY59PJVeJRs4jbJQkQhodieRQKI
	 JAAnkl4gQWXPTmcdx5E6p579wg1l5ilCKVl2rZn7cKvQqZkrQD/zHogurNVcocm8Hh
	 Eh67rUjwb0pilXLtJV/KGeo9qbr5Lretlu1v56d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <quic_jiegan@quicinc.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 464/695] Coresight: Set correct cs_mode for dummy source to fix disable issue
Date: Wed,  2 Oct 2024 14:57:42 +0200
Message-ID: <20241002125840.980705364@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Gan <quic_jiegan@quicinc.com>

[ Upstream commit e6b64cda393efd84709ab3df2e42d36d36d7553e ]

The coresight_disable_source_sysfs function should verify the
mode of the coresight device before disabling the source.
However, the mode for the dummy source device is always set to
CS_MODE_DISABLED, resulting in the check consistently failing.
As a result, dummy source cannot be properly disabled.

Configure CS_MODE_SYSFS/CS_MODE_PERF during the enablement.
Configure CS_MODE_DISABLED during the disablement.

Fixes: 9d3ba0b6c056 ("Coresight: Add coresight dummy driver")
Signed-off-by: Jie Gan <quic_jiegan@quicinc.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20240812042844.2890115-1-quic_jiegan@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-dummy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-dummy.c b/drivers/hwtracing/coresight/coresight-dummy.c
index ac70c0b491beb..dab389a5507c1 100644
--- a/drivers/hwtracing/coresight/coresight-dummy.c
+++ b/drivers/hwtracing/coresight/coresight-dummy.c
@@ -23,6 +23,9 @@ DEFINE_CORESIGHT_DEVLIST(sink_devs, "dummy_sink");
 static int dummy_source_enable(struct coresight_device *csdev,
 			       struct perf_event *event, enum cs_mode mode)
 {
+	if (!coresight_take_mode(csdev, mode))
+		return -EBUSY;
+
 	dev_dbg(csdev->dev.parent, "Dummy source enabled\n");
 
 	return 0;
@@ -31,6 +34,7 @@ static int dummy_source_enable(struct coresight_device *csdev,
 static void dummy_source_disable(struct coresight_device *csdev,
 				 struct perf_event *event)
 {
+	coresight_set_mode(csdev, CS_MODE_DISABLED);
 	dev_dbg(csdev->dev.parent, "Dummy source disabled\n");
 }
 
-- 
2.43.0



