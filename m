Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6653B1D016B;
	Wed,  2 Oct 2024 13:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876586; cv=none; b=VcRmMmXrJjwViiRtNaDi8zUfr1H6yhAdMMMKw/AaMsEcv+v9CXlfjJDMrzT3HN0eF/ibb75QKkBMZcf9MuL5WEgAGPkYEBuU3HJizRiFsjW3sMKI3+6NLU4pV3PIqVrh5jUqL/G+G6ePUvQ/PlmdYiYrbKoZj+QfF+c9XZogoKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876586; c=relaxed/simple;
	bh=G5Ya5NoAhDPUV3IFbYSjUkyc1uBlRgpSTMjXarwyTkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXpdLC32DunQT3xzvhy3slHer/YaSlf9AuacOTV9VdhK+T78cED3I03H+TLfVz4bmM5kU8/NLmPBBWiMHM+ez10RZAyahDjQKdBXfzOW8vKKCv1GzlN00GBW+XjZUOGeahd5+i1rPK+y7URpf6LiHsZp5ICfKalxzjabGmNN/64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeBqDKUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeBqDKUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF45C4CEC5;
	Wed,  2 Oct 2024 13:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876585;
	bh=G5Ya5NoAhDPUV3IFbYSjUkyc1uBlRgpSTMjXarwyTkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeBqDKUELMdouIwsHrN+nEJarWaHOC/9ZnlU8KTUsgK2hLcE7ItzGhgSgdIXqlIDq
	 5ZOzavrW3qDcIsW/xaZqdYUiDXYDPM+VkeU2nwM/9Xs7GcLP72953x1JCbD11FMSqp
	 ue85z/FIwYF1HS5DZg6lO/cVKjD6gc4HKSfyKW2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <quic_jiegan@quicinc.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 463/695] Coresight: Set correct cs_mode for TPDM to fix disable issue
Date: Wed,  2 Oct 2024 14:57:41 +0200
Message-ID: <20241002125840.940728990@linuxfoundation.org>
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

[ Upstream commit 14f5fa9b5fcbe2b3d5098893aba6ad62254d2ef6 ]

The coresight_disable_source_sysfs function should verify the
mode of the coresight device before disabling the source.

However, the mode for the TPDM device is always set to
CS_MODE_DISABLED, resulting in the check consistently failing.
As a result, TPDM cannot be properly disabled.

Configure CS_MODE_SYSFS/CS_MODE_PERF during the enablement.
Configure CS_MODE_DISABLED during the disablement.

Fixes: b3c71626a933 ("Coresight: Add coresight TPDM source driver")
Signed-off-by: Jie Gan <quic_jiegan@quicinc.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20240812043043.2890694-1-quic_jiegan@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tpdm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-tpdm.c b/drivers/hwtracing/coresight/coresight-tpdm.c
index 0726f8842552c..5c5a4b3fe6871 100644
--- a/drivers/hwtracing/coresight/coresight-tpdm.c
+++ b/drivers/hwtracing/coresight/coresight-tpdm.c
@@ -449,6 +449,11 @@ static int tpdm_enable(struct coresight_device *csdev, struct perf_event *event,
 		return -EBUSY;
 	}
 
+	if (!coresight_take_mode(csdev, mode)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EBUSY;
+	}
+
 	__tpdm_enable(drvdata);
 	drvdata->enable = true;
 	spin_unlock(&drvdata->spinlock);
@@ -506,6 +511,7 @@ static void tpdm_disable(struct coresight_device *csdev,
 	}
 
 	__tpdm_disable(drvdata);
+	coresight_set_mode(csdev, CS_MODE_DISABLED);
 	drvdata->enable = false;
 	spin_unlock(&drvdata->spinlock);
 
-- 
2.43.0



