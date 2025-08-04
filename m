Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A0912C544;
	Mon,  4 Aug 2025 00:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267398; cv=none; b=qk/vGNXMvs47RouWQgtsxfWxuy6aLVCq/R7FW1DhxHRUIyJMI6QI/WpGeuM0mZNnyrMAVIY1wtm3XOm4gCitI5RKOSuuy7P1gEBkNZOYQ/BK4BVZRQOp1NU50dbiG9W1SOCBahSCrV2aj2RBEEiK/Bw8PpDxA7F4p97VT8El7Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267398; c=relaxed/simple;
	bh=picT8eGkYIafbdug6O/A4STenYJtXfMwvjHe3TjKviM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ws5e+r0hG0ARcju7wPxVstYemrOevUsm47XBmVGBPttSfQBsgtSztzd8pAsGO2Uq8ADu+gk6iRk2UKdlK+1Jy4F9HKGVpDBEaBR41XA9/XuDsEfyyGutfa8DLnTAupn08kQCLH0SVEj/OuB2RI3sjR564fC03UeS9u9ogO86V6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DaC+QpAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DaC+QpAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F150C4CEEB;
	Mon,  4 Aug 2025 00:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267397;
	bh=picT8eGkYIafbdug6O/A4STenYJtXfMwvjHe3TjKviM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaC+QpADzjiel4OznbKYi2T5yLIN6+6HUl0BP4DCwO818UpQ1WJYggj0LBU8Hr651
	 U4fMhEmIeA14pTCk0okR6GjjZnBeCuGGajx5Px89T6YRjJ8nn2tPYOlxKEsRmpj8i8
	 cCkvzag8sRQoAGkP4IRbRt/n0TZ/vljyWqKO44lmE0gRQ0pXzdu4n/2s2FwyqXQDOH
	 aZhk95obdFHTKyNi+66wohFgXTnagzvIG2M/ThZX3iPm7uFGvnk722jfKJBw4/zfH5
	 oPVXhMyRJSVzJCoeV7ISx1ujI7ExIMwu7ML5iJ8XlN048evoqbbmrgcjMzP5aL/ABt
	 JGWtq9gDcQTPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eliav Farber <farbere@amazon.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@kernel.org,
	tglx@linutronix.de,
	giometti@enneenne.com,
	bastien.curutchet@bootlin.com,
	calvin@wbinvd.org
Subject: [PATCH AUTOSEL 6.15 50/80] pps: clients: gpio: fix interrupt handling order in remove path
Date: Sun,  3 Aug 2025 20:27:17 -0400
Message-Id: <20250804002747.3617039-50-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eliav Farber <farbere@amazon.com>

[ Upstream commit 6bca1e955830808dc90e0506b2951b4256b81bbb ]

The interrupt handler in pps_gpio_probe() is registered after calling
pps_register_source() using devm_request_irq(). However, in the
corresponding remove function, pps_unregister_source() is called before
the IRQ is freed, since devm-managed resources are released after the
remove function completes.

This creates a potential race condition where an interrupt may occur
after the PPS source is unregistered but before the handler is removed,
possibly leading to a kernel panic.

To prevent this, switch from devm-managed IRQ registration to manual
management by using request_irq() and calling free_irq() explicitly in
the remove path before unregistering the PPS source. This ensures the
interrupt handler is safely removed before deactivating the PPS source.

Signed-off-by: Eliav Farber <farbere@amazon.com>
Link: https://lore.kernel.org/r/20250527053355.37185-1-farbere@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the surrounding context, here is
my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a Real Bug**: The commit addresses a genuine race condition
   where an interrupt can occur after the PPS source is unregistered but
   before the IRQ handler is freed. This can lead to a kernel panic - a
   serious stability issue that affects users.

2. **Clear Race Condition Pattern**: The code shows the problematic
   ordering:
   - In probe: `pps_register_source()` → `devm_request_irq()`
   - In remove: `pps_unregister_source()` → (implicit devm cleanup frees
     IRQ)

   This creates a window where the hardware can generate an interrupt
after the PPS source is gone but before the handler is removed, causing
the handler to access freed memory.

3. **Minimal and Contained Fix**: The change is small and focused:
   - Changes `devm_request_irq()` to `request_irq()`
   - Adds explicit `free_irq()` call before `pps_unregister_source()`
   - Only 3 lines of functional code changes
   - No new features or architectural changes

4. **Similar to Other Stable Fixes**: This follows a common pattern seen
   in other drivers where devm resource ordering causes issues in
   removal paths. The kernel has many similar fixes for CAN drivers,
   network drivers, and other subsystems that have been backported to
   stable.

5. **Low Risk of Regression**: The change is straightforward and doesn't
   modify the driver's functionality - it only fixes the resource
   cleanup ordering. The manual IRQ management is a well-established
   pattern.

6. **Affects User-Visible Stability**: A kernel panic during device
   removal/module unload is a serious issue that can affect system
   stability, especially in environments where PPS devices might be
   dynamically added/removed or during system shutdown.

The commit message clearly describes the problem, the root cause, and
the solution. The fix is conservative and follows established kernel
patterns for fixing devm ordering issues. This is exactly the type of
bug fix that stable kernel rules recommend for backporting.

 drivers/pps/clients/pps-gpio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 374ceefd6f2a..2866636b0554 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -210,8 +210,8 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	}
 
 	/* register IRQ interrupt handler */
-	ret = devm_request_irq(dev, data->irq, pps_gpio_irq_handler,
-			get_irqf_trigger_flags(data), data->info.name, data);
+	ret = request_irq(data->irq, pps_gpio_irq_handler,
+			  get_irqf_trigger_flags(data), data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
 		dev_err(dev, "failed to acquire IRQ %d\n", data->irq);
@@ -228,6 +228,7 @@ static void pps_gpio_remove(struct platform_device *pdev)
 {
 	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
 
+	free_irq(data->irq, data);
 	pps_unregister_source(data->pps);
 	timer_delete_sync(&data->echo_timer);
 	/* reset echo pin in any case */
-- 
2.39.5

