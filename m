Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5AB7EF1F;
	Mon,  8 Apr 2024 14:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585014; cv=none; b=UOpJDf/rNYsvWrJEx4BxJXQDZ8q0pJcvfmZ20i5lxIGKvJoEfT0PRX6L+ODJxIuk45RxkG/4bIZl9gE75ATs0RxpV2ce0hlN+s6qrSYg8u4AnMozONfx4yh1lVinxZBBFLtMtiVFcdp3n713ecScUytWhn4G9I/Rr8KFV2Vm3mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585014; c=relaxed/simple;
	bh=mHgwzNl1mDBzVS7Ws3WzGk3106X3OB8/1cJ0aZtfmTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjhiXKTSguUCRLXeHHxdFkLkakhyhN/AR6HDGI+nGEVTDfFwQX0FIrIuhafSOYwxAJWuGHPDTyiCJHuHe1/toP0/fPNSYE1t/B6zIeZTMdOXJp5zgT0U14ZwjXn3GXPHa4srCJh/sv+raaOHRs6NOfsmfagluB41i9C1gF/FrUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjlSM8Tq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjlSM8Tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1F4C433C7;
	Mon,  8 Apr 2024 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585013;
	bh=mHgwzNl1mDBzVS7Ws3WzGk3106X3OB8/1cJ0aZtfmTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjlSM8TqyNFikc202/YIyWZ234JEoI7Szh7GIGcJ4KZSjXx4YSV1nuQgo90joKkrA
	 /GC+xSr2EAz3+1zmuHBWzBH97yb6LKgOS98ImuBBe0xvr+EyV0tMs9WMaC9HCzA7v9
	 evqb4sCuKSVMhgRCBZowDrHVVdK+ZHlkWLti4H8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Zhang <ye.zhang@rock-chips.com>,
	Dhruva Gole <d-gole@ti.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 633/690] thermal: devfreq_cooling: Fix perf state when calculate dfc res_util
Date: Mon,  8 Apr 2024 14:58:19 +0200
Message-ID: <20240408125422.599873364@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Zhang <ye.zhang@rock-chips.com>

commit a26de34b3c77ae3a969654d94be49e433c947e3b upstream.

The issue occurs when the devfreq cooling device uses the EM power model
and the get_real_power() callback is provided by the driver.

The EM power table is sorted ascending，can't index the table by cooling
device state，so convert cooling state to performance state by
dfc->max_state - dfc->capped_state.

Fixes: 615510fe13bd ("thermal: devfreq_cooling: remove old power model and use EM")
Cc: 5.11+ <stable@vger.kernel.org> # 5.11+
Signed-off-by: Ye Zhang <ye.zhang@rock-chips.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/devfreq_cooling.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/devfreq_cooling.c
+++ b/drivers/thermal/devfreq_cooling.c
@@ -199,7 +199,7 @@ static int devfreq_cooling_get_requested
 
 		res = dfc->power_ops->get_real_power(df, power, freq, voltage);
 		if (!res) {
-			state = dfc->capped_state;
+			state = dfc->max_state - dfc->capped_state;
 			dfc->res_util = dfc->em_pd->table[state].power;
 			dfc->res_util *= SCALE_ERROR_MITIGATION;
 


