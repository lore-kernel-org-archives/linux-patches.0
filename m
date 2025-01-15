Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483A6248BA0;
	Wed, 15 Jan 2025 10:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937661; cv=none; b=YtBrdeobxV8axEyDyUnWVsT3C2xW/vo2CB0y38raD8oKeOavH1XmzQz+4l0q8hlsR2bUvHNCjLPt5R9DRDP4I/Wuh04CdzAT51i2ZFK7bT4bVP6TKQgyJf+sNxFGW0/7mCz+NBf4/tMTb/m4t8TuDJHT/v6ICsVgB3oU89dkrE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937661; c=relaxed/simple;
	bh=hpc3e5sHHR+TCuxnv8AlKXpYbMaY7Ui8piJSsPxz5Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Let5hvzYvU5SAvfmHSoI8MRDqwFY0r9SX/GilidzSnoFVeQ88/zJKU1SUjwkPxgsf9RYPf1HK43M2sUah6wMLvz9R2YWwz+7l79TGZkjIAxoBZ2bTJnbzsGz2YNx+JtkhDv5H1jl0k7EU/rYwWlIgBNygj+qD80SjQUvVsUQLfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wuh9qAlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wuh9qAlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63EDC4CEE1;
	Wed, 15 Jan 2025 10:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937661;
	bh=hpc3e5sHHR+TCuxnv8AlKXpYbMaY7Ui8piJSsPxz5Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wuh9qAlYxsPOhx3CnwDB5ulqVdQkNth4qRyH0NNfYE4wCPbGOxbJ08YuCBLV3vARX
	 kxoG3kSuKpg6y1U400UTkxjG0styymO6wT891c0Z43o5T6yfVXormoawzrI22pK4uK
	 QUnrNTYC77ulX8AsQLeionKmmFgYq7ff4KuYej8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 44/92] thermal: of: fix OF node leak in of_thermal_zone_find()
Date: Wed, 15 Jan 2025 11:37:02 +0100
Message-ID: <20250115103549.291074852@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 9164e0912af206a72ddac4915f7784e470a04ace ]

of_thermal_zone_find() calls of_parse_phandle_with_args(), but does not
release the OF node reference obtained by it.

Add a of_node_put() call when the call is successful.

Fixes: 3fd6d6e2b4e8 ("thermal/of: Rework the thermal device tree initialization")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241224031809.950461-1-joe@pf.is.s.u-tokyo.ac.jp
[ rjw: Changelog edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 07476147559a..95939df314d1 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -315,6 +315,7 @@ static struct device_node *of_thermal_zone_find(struct device_node *sensor, int
 				goto out;
 			}
 
+			of_node_put(sensor_specs.np);
 			if ((sensor == sensor_specs.np) && id == (sensor_specs.args_count ?
 								  sensor_specs.args[0] : 0)) {
 				pr_debug("sensor %pOFn id=%d belongs to %pOFn\n", sensor, id, child);
-- 
2.39.5



