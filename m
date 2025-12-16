Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECAA34FF44;
	Tue, 16 Dec 2025 11:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886159; cv=none; b=iFhuMEl5afQVU7MT4tGz5GgcV5Zf/qjEeVCTv/hrE2K/hUj0JKlgLITejdOkV7lZHgai7JQ9g8A8i4luxU4ctj7ZRwuLogZ/53TjJ1fjrQn8Pjhu4fUGD6ZqAO9VXl3mvqpL2it/2qWZXitkyHZjtkaaBCfP6/VeWCdqjJ4VwUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886159; c=relaxed/simple;
	bh=7PNEEBGQuOFpnAoIAbtNVFdN7AwRUyv9VYwuPdHRv3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK6UgV/2RX0pLE7qqbXTmHTjEjKzOspkANtmGUjySpy03HPUzZyEvLBJb3yir2mJeTAL+RGnYrbCSi1Mt6wduIOAmdpHJu7KAbLMUa2VdmFkKfs0TccBMlz9WBzBdkmKEyRXebNy+QPmg3qp+xK9sFgfRa9ABAyxc735itGe05c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnp60gDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnp60gDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8337C4CEF1;
	Tue, 16 Dec 2025 11:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886159;
	bh=7PNEEBGQuOFpnAoIAbtNVFdN7AwRUyv9VYwuPdHRv3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnp60gDqeblUec6bX9QKBzsar/nuYSdaTdwk5DvFegcrx9TnMknBJ4qHEryh01uhV
	 k6BxULUJ2S2g1JyomYboCAyFipvnOJ05pEb4PcwL0GaTyW1MdifHg412SFf6aWNNZ6
	 cnkzIkxKxXgnwRNPZuHuXMie5Ij/GIwfo6oqlvUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 313/507] PM / devfreq: hisi: Fix potential UAF in OPP handling
Date: Tue, 16 Dec 2025 12:12:34 +0100
Message-ID: <20251216111356.807983077@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Pengjie Zhang <zhangpengjie2@huawei.com>

[ Upstream commit 26dd44a40096468396b6438985d8e44e0743f64c ]

Ensure all required data is acquired before calling dev_pm_opp_put(opp)
to maintain correct resource acquisition and release order.

Fixes: 7da2fdaaa1e6 ("PM / devfreq: Add HiSilicon uncore frequency scaling driver")
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://patchwork.kernel.org/project/linux-pm/patch/20250915062135.748653-1-zhangpengjie2@huawei.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/hisi_uncore_freq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/hisi_uncore_freq.c b/drivers/devfreq/hisi_uncore_freq.c
index 96d1815059e32..c1ed70fa0a400 100644
--- a/drivers/devfreq/hisi_uncore_freq.c
+++ b/drivers/devfreq/hisi_uncore_freq.c
@@ -265,10 +265,11 @@ static int hisi_uncore_target(struct device *dev, unsigned long *freq,
 		dev_err(dev, "Failed to get opp for freq %lu hz\n", *freq);
 		return PTR_ERR(opp);
 	}
-	dev_pm_opp_put(opp);
 
 	data = (u32)(dev_pm_opp_get_freq(opp) / HZ_PER_MHZ);
 
+	dev_pm_opp_put(opp);
+
 	return hisi_uncore_cmd_send(uncore, HUCF_PCC_CMD_SET_FREQ, &data);
 }
 
-- 
2.51.0



