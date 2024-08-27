Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71AE12E4D;
	Tue, 27 Aug 2024 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771375; cv=none; b=MNlRKELWvXHFKX+bzmxJZJPe2nMuRRy2mDHi9MI4GEhOe3pH4iz657MuOSrZYCY/0dKf0At4vdjFvLNhDVHuY6CBZZfwsVdc72++qNOM3YsKU68JmtK/MSBEmuk9w2XUk80plMwqYSLy7ILkUJG7k1T937x/lbBroQs5FEHyLNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771375; c=relaxed/simple;
	bh=mPueHzAW2wlMyleXHTJGchr1DA4AqsZiWjipr33LXbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKNUBz5YgC2KB+Uf50VLuIURbgoIlQzSfglckzbxF1sI31X9cZlLnzH61IDC7qWJMuCh+IQTvTs+1XefcurYA1Ub15LehIo91TDHP5tqcYyw+844tdGaUPi9xLzO7WpRbiPKD5Bew3dJZEvz4nFYx8o6ZZ0TB2NxsP6KlUsk6j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mp1DHc5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mp1DHc5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24752C4AF49;
	Tue, 27 Aug 2024 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771375;
	bh=mPueHzAW2wlMyleXHTJGchr1DA4AqsZiWjipr33LXbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mp1DHc5RINQfJG3rDk53ydoiOdJIfxKxifdy+5ONgfT8EFzxH1sB64v8kCfVmVzoM
	 RD9gShZTeajU1xEIUzcKZzi0ASEsPbo0D+rjGdhTqG0P9NQgefwM/gzidRzzrvn3zx
	 lK5HVqv/4AvxDCsNTMdEhexEacEpDqTZsNv67jX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 138/273] thermal: gov_bang_bang: Drop unnecessary cooling device target state checks
Date: Tue, 27 Aug 2024 16:37:42 +0200
Message-ID: <20240827143838.656634409@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2c637af8a74d9a2a52ee5456a75dd29c8cb52da5 ]

Some cooling device target state checks in bang_bang_control()
done before setting the new target state are not necessary after
recent changes, so drop them.

Also avoid updating the target state before checking it for
unexpected values.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 84248e35d9b6 ("thermal: gov_bang_bang: Split bang_bang_control()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_bang_bang.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
index 2a6a651e9d921..b9474c6af72b5 100644
--- a/drivers/thermal/gov_bang_bang.c
+++ b/drivers/thermal/gov_bang_bang.c
@@ -57,24 +57,16 @@ static void bang_bang_control(struct thermal_zone_device *tz,
 		if (instance->trip != trip)
 			continue;
 
-		if (instance->target == THERMAL_NO_TARGET)
-			instance->target = 0;
-
-		if (instance->target != 0 && instance->target != 1) {
+		if (instance->target != 0 && instance->target != 1 &&
+		    instance->target != THERMAL_NO_TARGET)
 			pr_debug("Unexpected state %ld of thermal instance %s in bang-bang\n",
 				 instance->target, instance->name);
 
-			instance->target = 1;
-		}
-
 		/*
 		 * Enable the fan when the trip is crossed on the way up and
 		 * disable it when the trip is crossed on the way down.
 		 */
-		if (instance->target == 0 && crossed_up)
-			instance->target = 1;
-		else if (instance->target == 1 && !crossed_up)
-			instance->target = 0;
+		instance->target = crossed_up;
 
 		dev_dbg(&instance->cdev->device, "target=%ld\n", instance->target);
 
-- 
2.43.0



