Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691061547F3;
	Mon,  6 Jan 2025 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178815; cv=none; b=ezMMxvw+DeGTCRUcXL4cpqAqm8pMls2qJlS9FNZ74R9zPXBV3XFnYU4a4Czd+KYDEL11BJKR0JX8jWKCKV+C4MzCwES1X82xyrLMjhNdUgTQR0M8KYmjsAT2UTk/FJVyPzjLAWyHMpoOlk7fcl0md1bRhBAQAkfgFMXhoWQSXOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178815; c=relaxed/simple;
	bh=YdfAGrGCbQOZlPePuLKOtrQwHtGFg/nKXnAAl9P55HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzicI1o+4KiBeBb1hcGnuyThm0m+9seEoB+aI42FXE/nCp7XvxuajamdYoj0rXUiN/67BZ9JYgEv1R68B8t1Eh0sPcKWk4/9tQIbabizAMt/xh9mv7R009iCanihxk2AOISLa1Dl0pbyePbWk25ktwYL7CXVwPcn3tKWxnOqhUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQFtZiIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQFtZiIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83249C4CED2;
	Mon,  6 Jan 2025 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178814;
	bh=YdfAGrGCbQOZlPePuLKOtrQwHtGFg/nKXnAAl9P55HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQFtZiIU2S6QYKB9IpAXvwc92E9uOp/QCtwbE4Dq9J4PHqzgvp2rjk2z3EtH8d9xg
	 08EJdvb5ZDOXU2Y8FMRIiWF62cjOm+K0PJImGQ6jfB1g8sKNsBqlWoOOI07D6zSUta
	 b7VFRSoKG2oBbCrzdpSv8CzY1edY71WruLt1dpO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 100/168] power: supply: gpio-charger: Fix set charge current limits
Date: Mon,  6 Jan 2025 16:16:48 +0100
Message-ID: <20250106151142.238376805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


