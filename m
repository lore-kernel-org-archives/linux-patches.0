Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC13B2DF3C9;
	Tue, 17 Jun 2025 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174650; cv=none; b=qE1v4oq1B03xoaWSeYJOh6qUXz+/hMkWoY/ajyj/M3Uw+vai8RBvfsc9945GtykQCgVWg9JJuejAiFX/lp0CTz4F9PYZeSLvxYDACJKFjNNyUXn7GPNwjx02YiVlVuz+wEY9BXF/Jy7i3bLzUx0LAm/TfOyzb4805MScKPXhbos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174650; c=relaxed/simple;
	bh=nezfrML99p4BsDiAhBo0XP5O94yPu+ZiFHuVdcGTT50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5F+OtjwtWw1mKgWiqnxmDf3F//oVHyakO38lHyggI/t5Y0trvW/XWEZoFnDRskIHV4k7EweEqa8BaosLgyH0ZxM1B3OVTrBvkjNiZbAwcaInAZc/sEm2EFsl+ntoVvoCliJ2qlkB3OSh7sHz4bLbfPKMe27vVswHieJd+NiJzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMyDLf1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMyDLf1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B628C4CEE3;
	Tue, 17 Jun 2025 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174649;
	bh=nezfrML99p4BsDiAhBo0XP5O94yPu+ZiFHuVdcGTT50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMyDLf1izZdbQJuilK5rLk5jL9g0N3f6CkNwUWm3PeiOacEbv+t5ek5WPsMSjRjk6
	 W5Yy6eneDRpALFJxFkcN1nJsIBxrlfxmo9BXUNdzFs30AyDKxJTG0MJeeP02syJoj4
	 8dUb3Mx2ytuw7nJKknUeIuX4zfOHUnadnIourMNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaxiong Tian <tianyaxiong@kylinos.cn>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/512] PM: EM: Fix potential division-by-zero error in em_compute_costs()
Date: Tue, 17 Jun 2025 17:20:13 +0200
Message-ID: <20250617152421.444530617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4e1778071d704..1c9fe741fe6d5 100644
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



