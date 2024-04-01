Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4761ABA3F;
	Mon,  1 Apr 2024 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990471; cv=none; b=LJe7jvFfzoDmEZGX/czE6z0p/T7jJDWXmqYFHk3eG9JG0yjwXTSBYaQvQYSSStkWrFQEsmsvdZitrBMRV/MUAsIZwzhY5GMOj+MndgTVk/sjlTKB70pi+w3MYNIEmRJPN1FZZHbOfqNpwrleTCMkLRUIFnjGVfgKwHQb3z08qPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990471; c=relaxed/simple;
	bh=Nu6jhG8HXYHZQxDZ37wS9AGvnKVAonawCM9v1/U5luw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4nKjA2iU3JmLKPFgSwjqFygxcRa0HjpU5Y93n6ZEvwPd61vRJic6FpwPtE8/YM33LlULiKiCsrVBtkvOVw1uqejOpmV6iqUHG9oV2F5XE127Zx8Da2KMtY9QVvpB1lkLF8mzCx78apqcZgllanA9qFsC4DKyFscp2rwGKwRS3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvPfdtc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvPfdtc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28C8C433F1;
	Mon,  1 Apr 2024 16:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990471;
	bh=Nu6jhG8HXYHZQxDZ37wS9AGvnKVAonawCM9v1/U5luw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvPfdtc8G0u8PdHj6iQMdOs/MZAVjV14sLPsyx5yk5nO36ig7ePq0R0abUunq3AE9
	 UsuDgzamcXgJ3sycbe5b49gVHKkfo0tOEcyDvLrm/8LEv/w9dh5JwFJRFvnwZGXl0+
	 FG4ioqtF8A6LEDa8LRsNcuZujpiLa0xbf3Lc1pkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Zhang <ye.zhang@rock-chips.com>,
	Dhruva Gole <d-gole@ti.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 336/396] thermal: devfreq_cooling: Fix perf state when calculate dfc res_util
Date: Mon,  1 Apr 2024 17:46:25 +0200
Message-ID: <20240401152557.929783788@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/devfreq_cooling.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/devfreq_cooling.c
+++ b/drivers/thermal/devfreq_cooling.c
@@ -201,7 +201,7 @@ static int devfreq_cooling_get_requested
 
 		res = dfc->power_ops->get_real_power(df, power, freq, voltage);
 		if (!res) {
-			state = dfc->capped_state;
+			state = dfc->max_state - dfc->capped_state;
 
 			/* Convert EM power into milli-Watts first */
 			dfc->res_util = dfc->em_pd->table[state].power;


