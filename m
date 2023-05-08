Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF548168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3592EC433EF;
	Mon,  8 May 2023 10:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540168;
	bh=CQfW+nljOBd9Vz2opStQ5BkOROaXJGZOYtBCDhJ7duA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xolo2ys2urYoWToZCIpT1fSf9xRxD+p2sj58rz7BLDj/AHLK7cpdUxNKREoBenvDi
	 eJyMfNapEw4lSneUwxepl6zA57KZZrVHfhr5/k6ktowtvg3Q9vFmIEW4zL7Jp/gk30
	 PWrQGME8cKhf0kS7y1WF8Xuox17UXX1kmcfH6hBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chandrashekara <sanjayc@nvidia.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/611] cpufreq: use correct unit when verify cur freq
Date: Mon,  8 May 2023 11:41:44 +0200
Message-Id: <20230508094430.922788073@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sanjay Chandrashekara <sanjayc@nvidia.com>

[ Upstream commit 44295af5019f1997d038ad2611086a2d1e2af167 ]

cpufreq_verify_current_freq checks() if the frequency returned by
the hardware has a slight delta with the valid frequency value
last set and returns "policy->cur" if the delta is within "1 MHz".
In the comparison, "policy->cur" is in "kHz" but it's compared
against HZ_PER_MHZ. So, the comparison range becomes "1 GHz".

Fix this by comparing against KHZ_PER_MHZ instead of HZ_PER_MHZ.

Fixes: f55ae08c8987 ("cpufreq: Avoid unnecessary frequency updates due to mismatch")
Signed-off-by: Sanjay Chandrashekara <sanjayc@nvidia.com>
[ sumit gupta: Commit message update ]
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 7e56a42750ea5..285ba51b31f60 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1727,7 +1727,7 @@ static unsigned int cpufreq_verify_current_freq(struct cpufreq_policy *policy, b
 		 * MHz. In such cases it is better to avoid getting into
 		 * unnecessary frequency updates.
 		 */
-		if (abs(policy->cur - new_freq) < HZ_PER_MHZ)
+		if (abs(policy->cur - new_freq) < KHZ_PER_MHZ)
 			return policy->cur;
 
 		cpufreq_out_of_sync(policy, new_freq);
-- 
2.39.2



