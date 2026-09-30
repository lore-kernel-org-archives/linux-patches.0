Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE284E4306;
	Wed, 30 Sep 2026 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786161; cv=none; b=tmGD50dKrHZuFLnVLmMgl8lclWt61jYWliLBlpi/kPNPBwnhrIjUsORX/N+vff3qH2y0KXZuGspJQpedKia+Rmik0TFB6xsYDvKnbOyGZnEr3wAnZEB+pfEyYwjziIfmac9eQLcQpNkkKBTrUoPbCy0DB6dU7XqBq9MWsVOwwYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786161; c=relaxed/simple;
	bh=geitjhD4/3bQuq4wdCulwQsRHtA8BBw8WMAfHUIcx5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO+PuBJ7qApgtmp/x1Hiyl1213P/0e4YzH8ZPvSb6Oi8lWEkGvUIxtNM1CWdP/q51eal1bc4VDMmoqlrghEXQDay+qXnNKcuDg19/N4Mx0g7HnmIeQHzvLxl4wERdQBoAUoyt7H8NWTiPFCv5luiKhryH2IXKmO8rpuyU7fOP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1E2OS4lH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1E2OS4lH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B12F1F000FF;
	Wed, 30 Sep 2026 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786160;
	bh=2Xks8yTVH/gmBoWdyV9nG0XbKqdPJEHE40fkhA8Bwuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1E2OS4lHoB3TebIvsj87xCA/6wdDRQ7Ue13qMKx/zMD0Bgd4Y9NBsAWUZWtAQ47XX
	 j0UKr5CK3MS4k6oBp6FaV9H279zEQFvvxIWbFa4FO/pIVlz4FyJwLsZeu8zohkkHoH
	 TyWPSUDkn4ooJJ/mkRXFZo7WlYYwKfVZYH/T7XPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 763/982] wifi: wlcore: release runtime PM ref on regdomain config failure
Date: Wed, 30 Sep 2026 17:24:59 +0200
Message-ID: <20260930152433.142193892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 8a1f3cf89ddcc700e25afe42cfad333059adcc94 upstream.

wlcore_regdomain_config() gets a runtime PM reference before sending
the regulatory-domain command. When
wlcore_cmd_regdomain_config_locked() fails, the function queues recovery
and returns without dropping that reference.

Release the reference after handling the command result so both success
and failure paths balance the preceding
pm_runtime_resume_and_get(). The recovery worker takes a separate
runtime PM reference and cannot release the reference held here.

Fixes: fa2648a34e73 ("wlcore: Add support for runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260820125126.12757-1-runyu.xiao@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3635,10 +3635,8 @@ void wlcore_regdomain_config(struct wl12
 		goto out;
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
-	if (ret < 0) {
+	if (ret < 0)
 		wl12xx_queue_recovery_work(wl);
-		goto out;
-	}
 
 	pm_runtime_mark_last_busy(wl->dev);
 	pm_runtime_put_autosuspend(wl->dev);


