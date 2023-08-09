Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19429174EE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E61C433C9;
	Wed,  9 Aug 2023 11:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578944;
	bh=fQwm54PJ9LKRdartTV0gjwgb9A7N+N+dqhZhI5HepnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/xAXYjhKydsnk+1e/yE0dnNfvKuf/TIYLyuv1cO1rQ4oCwFgTAf0t3YyrFzFEEmz
	 y3s34fx2MirCWtW5Xap66B9ZNhZ5oFmjAsR3/9S/XDa8hzE1nnocOo/3TuJD8XB1wg
	 vTK/3vaUOISX7NEruky9t04Ykfvunj4hz25IyTxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 012/204] PM: domains: fix integer overflow issues in genpd_parse_state()
Date: Wed,  9 Aug 2023 12:39:10 +0200
Message-ID: <20230809103642.990816393@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit e5d1c8722083f0332dcd3c85fa1273d85fb6bed8 ]

Currently, while calculating residency and latency values, right
operands may overflow if resulting values are big enough.

To prevent this, albeit unlikely case, play it safe and convert
right operands to left ones' type s64.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 30f604283e05 ("PM / Domains: Allow domain power states to be read from DT")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index a64b093a88cf4..0f38df5856e12 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2206,10 +2206,10 @@ static int genpd_parse_state(struct genpd_power_state *genpd_state,
 
 	err = of_property_read_u32(state_node, "min-residency-us", &residency);
 	if (!err)
-		genpd_state->residency_ns = 1000 * residency;
+		genpd_state->residency_ns = 1000LL * residency;
 
-	genpd_state->power_on_latency_ns = 1000 * exit_latency;
-	genpd_state->power_off_latency_ns = 1000 * entry_latency;
+	genpd_state->power_on_latency_ns = 1000LL * exit_latency;
+	genpd_state->power_off_latency_ns = 1000LL * entry_latency;
 	genpd_state->fwnode = &state_node->fwnode;
 
 	return 0;
-- 
2.39.2



