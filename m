Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A0A3090EF;
	Mon, 13 Oct 2025 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368511; cv=none; b=iKmowMvMFRRp+xkscDsxF+JbAnFCjjtXQ9JPks5X0Ne+aXEEsWD/Io/4rMkGwbSxSKbkhNGnUfhuKAIGf16qdvKYGyl1ef7nYePUtql5WPN7OURh15zc8GN8Lb658OWxdjCog8ptD+rawh4WFeE6S87gD+cZJFP01jYXtzdoyws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368511; c=relaxed/simple;
	bh=ylYUE6hbgWfPyM6KXgsX7N6iPeDQe/ZHEjA8i3I9rrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+ub9MBwhmQE7gGzeUJKEw9zzjjCdd4VPv9bJP0O6BAVr2Fmc/xBvJ/4PfbJad6B+etIjK64MZjEAc5ybQWbnVYCIfxl+mmFDP1k223G70R4cheBT8uXng3mgaLPvUSOhot0sZuf8pKSJbuColWkzYx4QufHjErF5n60pz3RIC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwF9X7CX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwF9X7CX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8B0C4CEE7;
	Mon, 13 Oct 2025 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368511;
	bh=ylYUE6hbgWfPyM6KXgsX7N6iPeDQe/ZHEjA8i3I9rrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwF9X7CX/eKLrHdeQgE2YTXg0StCm8e6ZzUYnptXJqyHBzQsHuthq1mmO7rznN1Fg
	 bh5zetTlWK6rjtLFjaQ6CGgajVPRdeCwj+J3e5nlgV9ADRtLeAttyHQKSHPuK4tmCi
	 a8pSHz5KE+wo2qyYq1PE6lA6x6cM/rKNtN14ZTxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/262] coresight: tpda: fix the logic to setup the element size
Date: Mon, 13 Oct 2025 16:45:29 +0200
Message-ID: <20251013144332.862804991@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit 43e0a92c04de7c822f6104abc73caa4a857b4a02 ]

Some TPDM devices support both CMB and DSB datasets, requiring
the system to enable the port with both corresponding element sizes.

Currently, the logic treats tpdm_read_element_size as successful if
the CMB element size is retrieved correctly, regardless of whether
the DSB element size is obtained. This behavior causes issues
when parsing data from TPDM devices that depend on both element sizes.

To address this, the function should explicitly fail if the DSB
element size cannot be read correctly.

Fixes: e6d7f5252f73 ("coresight-tpda: Add support to configure CMB element")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250906-fix_element_size_issue-v2-1-dbb0ac2541a9@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tpda.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-tpda.c b/drivers/hwtracing/coresight/coresight-tpda.c
index bfca103f9f847..865fd6273e5e4 100644
--- a/drivers/hwtracing/coresight/coresight-tpda.c
+++ b/drivers/hwtracing/coresight/coresight-tpda.c
@@ -71,12 +71,15 @@ static int tpdm_read_element_size(struct tpda_drvdata *drvdata,
 	if (tpdm_has_dsb_dataset(tpdm_data)) {
 		rc = fwnode_property_read_u32(dev_fwnode(csdev->dev.parent),
 				"qcom,dsb-element-bits", &drvdata->dsb_esize);
+		if (rc)
+			goto out;
 	}
 	if (tpdm_has_cmb_dataset(tpdm_data)) {
 		rc = fwnode_property_read_u32(dev_fwnode(csdev->dev.parent),
 				"qcom,cmb-element-bits", &drvdata->cmb_esize);
 	}
 
+out:
 	if (rc)
 		dev_warn_once(&csdev->dev,
 			"Failed to read TPDM Element size: %d\n", rc);
-- 
2.51.0



