Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7A547AF75;
	Thu, 20 Aug 2026 16:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243454; cv=none; b=d4627lBvIE5XI7aHSBAxXpO2XJGNZKbovuRzRvIp495h3p66d/84ZNDE7Hf2DTpg/qtTizT8W3oU/lGmjDWCdb1NYdRS4pZ8OrR7PQ0hBbY7VBHuQicAp/efAuOzhdeG+lGv6tDeNdgIZA0xkB+aPFJVaOS0gSclaUa1deupa2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243454; c=relaxed/simple;
	bh=w5dAXZhPREMvGh6IJP1GuxREmzTVJizu0Q70tWDfi5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKCziQTnq9Gm0m4tQjWq5JV0MlWkIT/vhxIe1es+fpKOsEhDXsxz3vlw6DonEkmk4/INXIQxHfAEBKob7jDSMpXum3UDYJWbnNdGJhMXKEyyvLgP33rVDKPFueB8oS5FcBhMw7vOjuHwHnYflYVgKVzvELGFRGB/TJms+NaOAnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYJx6i9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYJx6i9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44C01F000E9;
	Thu, 20 Aug 2026 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243453;
	bh=tfiMqZjeK/ESzGRsjNt6j8+1fpgDqTurqRMnsQtJdDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYJx6i9MTRKUC2jyY2oaauXbOznRrTBgAV9c72+u+e+DgCWl9ePbQa21T0wKTIdSW
	 WklGJK95p1RDXgnz6FpTKL7iqw2n1h1LFS+5yHtjxWX6gaXcrNNsLuHr5Nk9WEUDfI
	 wK3XM4cxXFylrx6AHE6sla87oYDi7R05kUW4bTPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/272] remoteproc: qcom: replace kstrdup with kstrndup
Date: Thu, 20 Aug 2026 16:54:44 +0200
Message-ID: <20260820145234.271051013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit 9d5b9ad97f83b2390a6006eeb5ae5e48ec4298ce ]

Since, there is no guarantee that region.name will be 0-terminated
from the firmware side, replace kstrdup with kstrndup.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1676383691-29738-1-git-send-email-quic_mojha@quicinc.com
Stable-dep-of: ecf9fc18e62c ("remoteproc: qcom: Fix leak when custom dump_segments addition fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -124,7 +124,7 @@ static int qcom_add_minidump_segments(st
 	for (i = 0; i < seg_cnt; i++) {
 		memcpy_fromio(&region, ptr + i, sizeof(region));
 		if (region.valid == MD_REGION_VALID) {
-			name = kstrdup(region.name, GFP_KERNEL);
+			name = kstrndup(region.name, MAX_REGION_NAME_LENGTH - 1, GFP_KERNEL);
 			if (!name) {
 				iounmap(ptr);
 				return -ENOMEM;


