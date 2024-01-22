Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51A4135A50;
	Tue, 23 Jan 2024 00:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969662; cv=none; b=g2LNX9RRI/jFdm76Z+wPxB1HHjuTUQSs3I0uuzzUc0ZPlBpU7gqFiERnq/MB6pZ1buYjb6PKVVLeJsORva6uZ544+BtNaSKWPlfo/2y4ChYfFjxkTUVuHLx4UFFkO5ZKpj3geG78Ys9PiLhg71eAPsltbA9QcTdEVre/kMnuLvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969662; c=relaxed/simple;
	bh=igH/SExPG4y44b10SE9s+Q9kOL4DLcOlTrLKoh/7AT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkKYf/Ascbj/FL8CLoNNl/KdfttNkXNS31EHtDGOuhjQUOtD8K2tBhzj6mCk/lPQqFszAsMeE6ClBgxQw9QuB1nNb5ZTTMhbWEEfrOCF90jlivfytJ2urftgLFiu2o2wUtfepeTbyeDyZCpciusOiEVkYKGb4cGheX1VZURKMxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpcdHQFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpcdHQFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA05C433F1;
	Tue, 23 Jan 2024 00:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969662;
	bh=igH/SExPG4y44b10SE9s+Q9kOL4DLcOlTrLKoh/7AT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpcdHQFwv4H//47iWgiZtyrBcMDvzXqXbGrh8IZyjjHsVkwE08KFqnAd1lp9Cmahm
	 JpLnyJkyx7JzjiTvdtFdaGtPWirzPPeRON+bbcbEytdWCB+ZHlreCPVCDBj/dsK37/
	 b5E5FIyXxJHh23K4CajFz6OJz0rbiQG2uO7ZsAiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.7 390/641] clocksource/drivers/ep93xx: Fix error handling during probe
Date: Mon, 22 Jan 2024 15:54:54 -0800
Message-ID: <20240122235830.151888921@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit c0c4579d79d0df841e825c68df450909a0032faf upstream.

When the interrupt property fails to be parsed, ep93xx_timer_of_init()
return code ends up uninitialized:

drivers/clocksource/timer-ep93xx.c:160:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (irq < 0) {
            ^~~~~~~
drivers/clocksource/timer-ep93xx.c:188:9: note: uninitialized use occurs here
        return ret;
               ^~~
drivers/clocksource/timer-ep93xx.c:160:2: note: remove the 'if' if its condition is always false
        if (irq < 0) {
        ^~~~~~~~~~~~~~

Simplify this portion to use the normal construct of just checking
whether a valid interrupt was returned. Note that irq_of_parse_and_map()
never returns a negative value and no other callers check for that either.

Fixes: c28ca80ba3b5 ("clocksource: ep93xx: Add driver for Cirrus Logic EP93xx")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20231212214616.193098-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-ep93xx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-ep93xx.c b/drivers/clocksource/timer-ep93xx.c
index bc0ca6e12334..6981ff3ac8a9 100644
--- a/drivers/clocksource/timer-ep93xx.c
+++ b/drivers/clocksource/timer-ep93xx.c
@@ -155,9 +155,8 @@ static int __init ep93xx_timer_of_init(struct device_node *np)
 	ep93xx_tcu = tcu;
 
 	irq = irq_of_parse_and_map(np, 0);
-	if (irq == 0)
-		irq = -EINVAL;
-	if (irq < 0) {
+	if (!irq) {
+		ret = -EINVAL;
 		pr_err("EP93XX Timer Can't parse IRQ %d", irq);
 		goto out_free;
 	}
-- 
2.43.0



