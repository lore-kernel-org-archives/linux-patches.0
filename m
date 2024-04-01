Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061261CA8F;
	Mon,  1 Apr 2024 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987539; cv=none; b=LwLFZiHWWUXXjwv3xauOFLs6lMCm7UFTkOM94Jo2P8C9MNpG9SrxB+kysJ+j8kjseEoSFmE3G1wNZZDf+2ymcBmZznpmxW/OCMO0g5eE1/+LzEPLvBtxn9gVRhYDKBWAIxwZP7/lsPwpBMuQCYKgl1czIjw8ohzNRZNIUJ9gwKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987539; c=relaxed/simple;
	bh=yMvSsFSwst0w1inWkxeP4YUzIIu/LuPXpLE11eikMk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PRQrotmCq6U53qGLk2fIvJADtwbPeUFVrEMtSbQ+8JjLUJCAX/27szqvtt+Jjj6CxhVAhxiZVHYxwepK7CLchj3mWXWxW4dwVV29Fkc2uoeLzOj/eYMXNfykMD2cUhfmbkdpLR93AKNRj3hMNMDgDd68Kt6/aHy2NxkrFDs9oyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDUhIFVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDUhIFVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62766C433F1;
	Mon,  1 Apr 2024 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987538;
	bh=yMvSsFSwst0w1inWkxeP4YUzIIu/LuPXpLE11eikMk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDUhIFVP/C+22W/Ztiw9/e+hSmMH/x4r1Qxp20HF4GjNzuRa7HD7zqafbXiK1NF3L
	 P82eJARxT9JgTbzPNF1g9HCBpxv6becRAbXFtNChsEBEqIkD9/PuXhZHyC4MwxF0uV
	 GTODcp8nBKu8ehUz+ssZugFa4lUShFu67N8fJsIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Zhang <ye.zhang@rock-chips.com>,
	Dhruva Gole <d-gole@ti.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.8 317/399] thermal: devfreq_cooling: Fix perf state when calculate dfc res_util
Date: Mon,  1 Apr 2024 17:44:43 +0200
Message-ID: <20240401152558.645532715@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


