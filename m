Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A58218ABD;
	Mon, 18 Aug 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524834; cv=none; b=U9WpnGkaz/bJTPa1JGod7CgG67B8gDnIDnz2RdtNh1x06ntM16OZwx98TodTvhtCLfl519F6rFImOqEUGyPeDgH9rHmhRo4LM4LgyqdoGY9Cilb2hWlFDDyG2eKVFoK9By53xC9ZJNiWgG3TV3fUS9pllE4e9Q9wI0VvVpHobPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524834; c=relaxed/simple;
	bh=rMtjoTAr6FQ4VLE1rAq8GB2HpPD65yYsNwvb8kc9gJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0k0nXPXuQFz8R9X1+BBxdCeylyLsxtkMioGrdbJKfQt/O4Lq2DuHddFIiIM3PILgv/4soP791Ncn6i5JCcVnUoqnib5Vt/FpJgCjAxTWj0HNmGY5c00COeiU5JjXhqC9YmNjK8QksNIdKNcc2hdoWIvIsQ7gh6luSOcYYMW8Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXN2MihQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXN2MihQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8B8C4CEEB;
	Mon, 18 Aug 2025 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524834;
	bh=rMtjoTAr6FQ4VLE1rAq8GB2HpPD65yYsNwvb8kc9gJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXN2MihQAed9xpeF4w0DNpPtmH2V4K/V2C3LFdT8mQV6CmFWIOiva5nhPDk8t3mzj
	 CPpjzVJ7ON7K87VDMrnJv+sCl7Mgm0ul/VxyUglPS/sEa7ne1UrlLlYPG8eSkqXMmd
	 JwxFcI/piq1AFacfuAUGGWQ3rfjVYqTWNzdE/9f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 078/570] cpuidle: governors: menu: Avoid using invalid recent intervals data
Date: Mon, 18 Aug 2025 14:41:05 +0200
Message-ID: <20250818124508.829254672@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit fa3fa55de0d6177fdcaf6fc254f13cc8f33c3eed ]

Marc has reported that commit 85975daeaa4d ("cpuidle: menu: Avoid
discarding useful information") caused the number of wakeup interrupts
to increase on an idle system [1], which was not expected to happen
after merely allowing shallower idle states to be selected by the
governor in some cases.

However, on the system in question, all of the idle states deeper than
WFI are rejected by the driver due to a firmware issue [2].  This causes
the governor to only consider the recent interval duriation data
corresponding to attempts to enter WFI that are successful and the
recent invervals table is filled with values lower than the scheduler
tick period.  Consequently, the governor predicts an idle duration
below the scheduler tick period length and avoids stopping the tick
more often which leads to the observed symptom.

Address it by modifying the governor to update the recent intervals
table also when entering the previously selected idle state fails, so
it knows that the short idle intervals might have been the minority
had the selected idle states been actually entered every time.

Fixes: 85975daeaa4d ("cpuidle: menu: Avoid discarding useful information")
Link: https://lore.kernel.org/linux-pm/86o6sv6n94.wl-maz@kernel.org/ [1]
Link: https://lore.kernel.org/linux-pm/7ffcb716-9a1b-48c2-aaa4-469d0df7c792@arm.com/ [2]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/2793874.mvXUDI8C0e@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 52d5d26fc7c6..81306612a5c6 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -97,6 +97,14 @@ static inline int which_bucket(u64 duration_ns)
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
+static void menu_update_intervals(struct menu_device *data, unsigned int interval_us)
+{
+	/* Update the repeating-pattern data. */
+	data->intervals[data->interval_ptr++] = interval_us;
+	if (data->interval_ptr >= INTERVALS)
+		data->interval_ptr = 0;
+}
+
 static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev);
 
 /*
@@ -222,6 +230,14 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	if (data->needs_update) {
 		menu_update(drv, dev);
 		data->needs_update = 0;
+	} else if (!dev->last_residency_ns) {
+		/*
+		 * This happens when the driver rejects the previously selected
+		 * idle state and returns an error, so update the recent
+		 * intervals table to prevent invalid information from being
+		 * used going forward.
+		 */
+		menu_update_intervals(data, UINT_MAX);
 	}
 
 	/* Find the shortest expected idle interval. */
@@ -482,10 +498,7 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 
 	data->correction_factor[data->bucket] = new_factor;
 
-	/* update the repeating-pattern data */
-	data->intervals[data->interval_ptr++] = ktime_to_us(measured_ns);
-	if (data->interval_ptr >= INTERVALS)
-		data->interval_ptr = 0;
+	menu_update_intervals(data, ktime_to_us(measured_ns));
 }
 
 /**
-- 
2.50.1



