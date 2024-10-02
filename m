Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068E21D1748;
	Wed,  2 Oct 2024 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878473; cv=none; b=k1dTL9EP+EHOTdZMJHkpFczgHLS2XTX6KZpe6Ty4z2jgEX7ko2m/BhfJKQlI07TIG/kIRWWAkr8D3dqLpprC9dor7emdk7BHBkvpIAJzwBdxva1DMztrEcUTbdcUIXfAVE9633vwy+i/143dk4md0qbKXEIFKmbtfQijVfpCWIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878473; c=relaxed/simple;
	bh=0CeflGD6/SXElOLtMJVYXODPJPNeyTFq1PGfU7aqV9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS0rkjrYkS6deExFgOlCSiLMQJkmpUfJ2cP+lP4HCgVRdaf6PCLC8iQdAtvAy321Y+QqSocjGzi7c9ZY1cQcpoBEa7A5PJwJHoYexUSVRhKHu3OcHPX/c1Tzkx6JKX2I3k8U/Lb1HTtyOKXHQH42r7+PNES8QlT2sqw7WdbhmjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/p1jhHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/p1jhHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82425C4CEC5;
	Wed,  2 Oct 2024 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878472;
	bh=0CeflGD6/SXElOLtMJVYXODPJPNeyTFq1PGfU7aqV9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/p1jhHTyjG8o5JOH0poOdnLH1NR7OGxbqqmkf/G/G5S+XbNiMMJQNDLDGnOLKaqV
	 po1Qtduqp08rXiG2JZEOJRS+wSS2oYEcIbjip+eDUPsAL79ZWEMcOIztnqJHdxmMpX
	 GXLE+864xCC2FyL6pohL1tei6QnaKphKvNplVnVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <quic_jiegan@quicinc.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 425/634] Coresight: Set correct cs_mode for dummy source to fix disable issue
Date: Wed,  2 Oct 2024 14:58:45 +0200
Message-ID: <20241002125827.878235943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



