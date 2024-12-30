Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1150515E8B;
	Mon, 30 Dec 2024 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573945; cv=none; b=Rdiuuur05eRVl6uXizCjJa72xjQ8IkYv3LCtXEIHHNsgGH3wBV+tNuglVAlEh0+qRYU/umB57wCmy6pmHg4LERxGyZq/CdlzoSg8YndJ0tQXKMzihWXKTqmzB2n3rTUP/fUNck4KB19GPXryfRPS9G56eBxjK1VLzLI1IKZhDbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573945; c=relaxed/simple;
	bh=K/2RynNcsq4rLeSuvCLbcH7HLq1pyPzrRIDNhODaWbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0miJJnPZQM3iFkDQvz495cPpBhNRiFkcgmCDg8b9gzI+ezumK1sYi9JijKbnKW1dDn5J8GdAwVDmTEBzJAYaW4njgbK3jL5HV4+d5cKTIlmQFMYpNNVGtsy1aS/7182K4m9UHofvyJWw/vrw3H+0r1HxPvctbBx/bED9N59mlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhlsOgsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhlsOgsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576A4C4CED0;
	Mon, 30 Dec 2024 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573944;
	bh=K/2RynNcsq4rLeSuvCLbcH7HLq1pyPzrRIDNhODaWbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhlsOgsmOdP7nAAjdqBxK+J3tsSQ5LcUxbNcS1npSqtv8BZrsSQ0VM8XE/VNfd7K3
	 fKZc0yHCnhwf3r7YEnYdRe5hwJXiWrs60a05xDWIGtnPmi3KhArtnX1pwKxoBiFPV+
	 BXkdcLpQSTKVE48fJrAkSPCPHjEU88AQMm3xZ8YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 80/86] power: supply: gpio-charger: Fix set charge current limits
Date: Mon, 30 Dec 2024 16:43:28 +0100
Message-ID: <20241230154214.750114619@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Fedrau <dimitri.fedrau@liebherr.com>

commit afc6e39e824ad0e44b2af50a97885caec8d213d1 upstream.

Fix set charge current limits for devices which allow to set the lowest
charge current limit to be greater zero. If requested charge current limit
is below lowest limit, the index equals current_limit_map_size which leads
to accessing memory beyond allocated memory.

Fixes: be2919d8355e ("power: supply: gpio-charger: add charge-current-limit feature")
Cc: stable@vger.kernel.org
Signed-off-by: Dimitri Fedrau <dimitri.fedrau@liebherr.com>
Link: https://lore.kernel.org/r/20241209-fix-charge-current-limit-v1-1-760d9b8f2af3@liebherr.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/gpio-charger.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/power/supply/gpio-charger.c
+++ b/drivers/power/supply/gpio-charger.c
@@ -67,6 +67,14 @@ static int set_charge_current_limit(stru
 		if (gpio_charger->current_limit_map[i].limit_ua <= val)
 			break;
 	}
+
+	/*
+	 * If a valid charge current limit isn't found, default to smallest
+	 * current limitation for safety reasons.
+	 */
+	if (i >= gpio_charger->current_limit_map_size)
+		i = gpio_charger->current_limit_map_size - 1;
+
 	mapping = gpio_charger->current_limit_map[i];
 
 	for (i = 0; i < ndescs; i++) {


