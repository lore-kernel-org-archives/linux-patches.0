Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1B52DFF1F;
	Tue, 17 Jun 2025 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175241; cv=none; b=j9qa0kzsxXonCUoMTkB2/19V2ZkfUEqgB+q1pA/83+SwrPyRkGDMDRl8WzxnnhkfHWB4EEqamPrqntREjmuhsQpdy93+r1nJB50aDHIfGZ7akEYMIJPHQ1ezN9c4gHPB2DCbCqULAATRN6mCEuvAC+WDMx+FTj/BF9WZuYAUD9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175241; c=relaxed/simple;
	bh=CfFPMnTbqhS00eBNm0lyxqZwWeWQWhI3u2kbNYRJi9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VydXw5ioMApgdK8MGJLR7Gvb2KpIFtwk73K76PN67u83DggKAvN2OqvExogyTJTfJYZ0jazbf6OO0d0hOKtFAiZywR5DjmUGycRHxKSXMcgpZu2QrJlR257Rm5x+0COAzh9XZzOByysYC1WS6tqD329ffOnc+OQX7w7GFOxEeLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGu1DJqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGu1DJqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B07EC4CEE3;
	Tue, 17 Jun 2025 15:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175241;
	bh=CfFPMnTbqhS00eBNm0lyxqZwWeWQWhI3u2kbNYRJi9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGu1DJqJm3uI14Vx6xZeGnttqDkJCRLe05gY4R51o86WKfmq45gOAHEi95yUHvK33
	 w/+ZsOqEzPAKMVPZ3O0bQ7U6Lf3stK/g+JNk2U5214z+oC7eEMBbdsPUSTb2NgBkLv
	 fR7O9BVfe8g76m9TsXbIHKUpIRJ4qnHpBkt2dAWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaxiong Tian <tianyaxiong@kylinos.cn>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 066/780] PM: EM: Fix potential division-by-zero error in em_compute_costs()
Date: Tue, 17 Jun 2025 17:16:14 +0200
Message-ID: <20250617152454.194607539@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yaxiong Tian <tianyaxiong@kylinos.cn>

[ Upstream commit 179c0c7044a378198adb36f2a12410ab68cc730a ]

When the device is of a non-CPU type, table[i].performance won't be
initialized in the previous em_init_performance(), resulting in division
by zero when calculating costs in em_compute_costs().

Since the 'cost' algorithm is only used for EAS energy efficiency
calculations and is currently not utilized by other device drivers, we
should add the _is_cpu_device(dev) check to prevent this division-by-zero
issue.

Fixes: 1b600da51073 ("PM: EM: Optimize em_cpu_energy() and remove division")
Signed-off-by: Yaxiong Tian <tianyaxiong@kylinos.cn>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/tencent_7F99ED4767C1AF7889D0D8AD50F34859CE06@qq.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index d9b7e2b38c7a9..41606247c2776 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -233,6 +233,10 @@ static int em_compute_costs(struct device *dev, struct em_perf_state *table,
 	unsigned long prev_cost = ULONG_MAX;
 	int i, ret;
 
+	/* This is needed only for CPUs and EAS skip other devices */
+	if (!_is_cpu_device(dev))
+		return 0;
+
 	/* Compute the cost of each performance state. */
 	for (i = nr_states - 1; i >= 0; i--) {
 		unsigned long power_res, cost;
-- 
2.39.5



