Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FD647F774;
	Thu, 20 Aug 2026 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248216; cv=none; b=nsYpxmuGxLx2VX/AJoS1QIVCOXfnFg3j8z08/w7xst3dRSz2WDM2nGinO0o7oGdvUoAkcbCfg2fZEyuoT1HERmrE+ZJXgVYFCmiZPTiW+ugwMchDiS6zlYSttLdWma+g4kwV0PCl/yCW6yIq7z9HH2n8bW1DOrm9gFMXKwW6YDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248216; c=relaxed/simple;
	bh=0uZNj9PKbqFFgEDgSoMsbyyc5xtGWq49iX5UbZFliIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh48wVk/yE4APpTNDoShqR6P8b8uvO3c+mLcCzSm0l05Bg3MpKwVQcAccY86nsYfTFhmrN9U2O1cYcl+JmihQcj7dL+sB3HW2l3/gA0S7cWgJbuooqI4K/20NxwYoVMMpJj7YayWujT60D2q2E9FBiDrlSFcFDb99jb/+GV8eQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y95gnMeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y95gnMeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F921F000E9;
	Thu, 20 Aug 2026 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248215;
	bh=LLDIJ3YlQR5MxyO1wcmvP0O/cFDrEk8ou6cj1J43CTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y95gnMeMOiU8tqnCkg8C0X28dxGdKMcYYIP08e4VyPdX6wQFoakjTqMpSik3smzdJ
	 ng+Ls7hviSYVsW52gYRKQZSIcm33Uol5lGkHh8VQa/shSMBnO9AZIJryV6oOXizJ64
	 m/MF4E5AA/9JjDUP75AWLZzYVldRhB3TuOsfRzaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/303] remoteproc: qcom: replace kstrdup with kstrndup
Date: Thu, 20 Aug 2026 16:54:07 +0200
Message-ID: <20260820145256.618789180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


