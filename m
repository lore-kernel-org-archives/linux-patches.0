Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837E830DD39;
	Mon, 13 Oct 2025 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369970; cv=none; b=YZ4u/XQVrhzqXZxuLUstZLDzJ/SWkj1PPMjCnm0Zc9FTv0/ZGhAQgw2507RUUNfTox8ByR6QaZEVQR2gfyrjFma0i9Fyo/sv4G9OWhH3sYA7c/xfEEKhjzWfGEObvDncf6qlAMon2imquno4/ULmNbcThnLvKz3b35gqOsb08b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369970; c=relaxed/simple;
	bh=3HCdbagRE8EcLG39kH3L5GMnS7VlvZspW+DmCUAI594=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQNudpFoAn6Wi4VohEahMRLZdqt6tFMDsX+N+NCkDWsGNESWwgaChnKIKbKLI21PVVq3vgWDgwkpiytDsNxGzr9pKsg4QotS70watqWrKb5nKDeXFaMJ+fE3Q3xET2VN0obmvGSEQ+Q4k0CcpYhIpqdF1WmdqjN0D8Jy9MmghEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFqjiTXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFqjiTXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D071C4CEE7;
	Mon, 13 Oct 2025 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369970;
	bh=3HCdbagRE8EcLG39kH3L5GMnS7VlvZspW+DmCUAI594=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFqjiTXg+iIyLXhKi5SIy6RuuZeWf01zI3Ui4s3itHXmy2MpTXEBLz26rf/Qxw6cC
	 w8WCutEA/wBS7t3GM7jjmJ8bivQPTNWSvcEJSEFXlBwRkfbSPMvgMhUSROc6WAmgab
	 sNW/kk22hJa+dlA2smwYP52N6Qh+n4MGqflWlbwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 432/563] coresight: tpda: fix the logic to setup the element size
Date: Mon, 13 Oct 2025 16:44:53 +0200
Message-ID: <20251013144426.935351238@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0633f04beb240..333b3cb236859 100644
--- a/drivers/hwtracing/coresight/coresight-tpda.c
+++ b/drivers/hwtracing/coresight/coresight-tpda.c
@@ -71,6 +71,8 @@ static int tpdm_read_element_size(struct tpda_drvdata *drvdata,
 	if (tpdm_data->dsb) {
 		rc = fwnode_property_read_u32(dev_fwnode(csdev->dev.parent),
 				"qcom,dsb-element-bits", &drvdata->dsb_esize);
+		if (rc)
+			goto out;
 	}
 
 	if (tpdm_data->cmb) {
@@ -78,6 +80,7 @@ static int tpdm_read_element_size(struct tpda_drvdata *drvdata,
 				"qcom,cmb-element-bits", &drvdata->cmb_esize);
 	}
 
+out:
 	if (rc)
 		dev_warn_once(&csdev->dev,
 			"Failed to read TPDM Element size: %d\n", rc);
-- 
2.51.0



