Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E572F12BD;
	Fri, 17 Oct 2025 15:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713226; cv=none; b=rVly0BwoK5XKqdhNW6JOyKQ4UItDs5ICQwsMM5avzkAzsvgUv7bjY1aW4+XCsacKlYZB3gx55VFM6Oxrs9hhpTG2VFZ4jN57QsR5X4aOCshQw+C3sc218jyYvsfeEJV6AivwxyNWaMeQuwR2oTxS42ArfGBCT2eiJJfufbXIPOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713226; c=relaxed/simple;
	bh=W6LB7OF3g7aQMEV4iuow7VRvPG1xN2/11AyS7rgoY3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzqbW/SRqUM5wpqsZlyuSv8IolMBqpAIgiuuGaxCVNN7x8AiHWqJ2dswn7WixxstCIR918PdzfR9SZvDZpbh8pMdxedHzOeu2ZiTjWzqBNryttW6XIkIwB3nlGB+UjYvty78oYiOlcYQBesEnhlKRiY5YNG0jAC98pmmHaNmeUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e41jb9yO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e41jb9yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F80C113D0;
	Fri, 17 Oct 2025 15:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713226;
	bh=W6LB7OF3g7aQMEV4iuow7VRvPG1xN2/11AyS7rgoY3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e41jb9yObWFmWpSc/WgC8/9iCQgtrLYTk9UlwklfKg+zWCl8Gu+MyJuWObaEj9FjK
	 wLURwY51hQJ7zslQ5yyBYSVxPW8T3RvYokh2A93k88/n8uXG/yPBsNZiIqUEgWyUCU
	 b6akLLEZWH3JKdCAZQScRuG+fQhvgaUh4tfe3114=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 6.1 058/168] cpuidle: governors: menu: Avoid using invalid recent intervals data
Date: Fri, 17 Oct 2025 16:52:17 +0200
Message-ID: <20251017145131.158452573@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit fa3fa55de0d6177fdcaf6fc254f13cc8f33c3eed upstream.

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
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/governors/menu.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -158,6 +158,14 @@ static inline int performance_multiplier
 
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
@@ -288,6 +296,14 @@ static int menu_select(struct cpuidle_dr
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
 
 	/* determine the expected residency time, round up */
@@ -542,10 +558,7 @@ static void menu_update(struct cpuidle_d
 
 	data->correction_factor[data->bucket] = new_factor;
 
-	/* update the repeating-pattern data */
-	data->intervals[data->interval_ptr++] = ktime_to_us(measured_ns);
-	if (data->interval_ptr >= INTERVALS)
-		data->interval_ptr = 0;
+	menu_update_intervals(data, ktime_to_us(measured_ns));
 }
 
 /**


