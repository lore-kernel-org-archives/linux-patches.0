Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0A918C33D;
	Tue, 10 Sep 2024 10:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964461; cv=none; b=MfJClsdDJXCirzTj63lQhDH61tEvVqt7txlawySxQD911F2ggRU7eVKqlQr8RJCFTGfceqDqAke7TDRTfrhKPZYL0TRZzh3RjqQqzHC79pnHLUGKtqj4VpJ32OSzBYBThhuAHs4c+mvskQZ2ASuB61ogpebCNpWGjJpNfHYiXNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964461; c=relaxed/simple;
	bh=Aa82sFe7F87RAqj2EodPCdIKfu3eduBjwDwkxl0jfKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AGb5cICuX26l0KxIaq2ki2vQdcdEroBSKOgDCiq115xHgBJoUE7pmAMbtjmnAKzovFJTKuS2t21X8u1neAPkikVTVyUnPhBQAQjSCK6vH2Sttxg1vHTXvCuZFP9UkD12BV0KAVbgMKnYTe6f6MaVfqXGqH+i1ZlHSeNN/ob/95s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCxaDYnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCxaDYnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AA1C4CEC3;
	Tue, 10 Sep 2024 10:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964460;
	bh=Aa82sFe7F87RAqj2EodPCdIKfu3eduBjwDwkxl0jfKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCxaDYnzlRLL3dtJPOkoITaYK3f/65ibmGuoX7cK9714NXYJchFlEQ0XU9JZlgq+2
	 K0cGhyCW8iV4DVL/xhcPZmDgWTMGl93glddWyvWWAWSfAlk63hWZVxlhLae2ojMPQ3
	 k+hlvDVBmTY6m7pp3mw9V74lNnlhUnEFwDBAVRo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/269] MIPS: cevt-r4k: Dont call get_c0_compare_int if timer irq is installed
Date: Tue, 10 Sep 2024 11:32:58 +0200
Message-ID: <20240910092614.922071405@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 50f2b98dc83de7809a5c5bf0ccf9af2e75c37c13 ]

This avoids warning:

[    0.118053] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283

Caused by get_c0_compare_int on secondary CPU.

We also skipped saving IRQ number to struct clock_event_device *cd as
it's never used by clockevent core, as per comments it's only meant
for "non CPU local devices".

Reported-by: Serge Semin <fancer.lancer@gmail.com>
Closes: https://lore.kernel.org/linux-mips/6szkkqxpsw26zajwysdrwplpjvhl5abpnmxgu2xuj3dkzjnvsf@4daqrz4mf44k/
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cevt-r4k.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 368e8475870f..5f6e9e2ebbdb 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -303,13 +303,6 @@ int r4k_clockevent_init(void)
 	if (!c0_compare_int_usable())
 		return -ENXIO;
 
-	/*
-	 * With vectored interrupts things are getting platform specific.
-	 * get_c0_compare_int is a hook to allow a platform to return the
-	 * interrupt number of its liking.
-	 */
-	irq = get_c0_compare_int();
-
 	cd = &per_cpu(mips_clockevent_device, cpu);
 
 	cd->name		= "MIPS";
@@ -320,7 +313,6 @@ int r4k_clockevent_init(void)
 	min_delta		= calculate_min_delta();
 
 	cd->rating		= 300;
-	cd->irq			= irq;
 	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= mips_next_event;
 	cd->event_handler	= mips_event_handler;
@@ -332,6 +324,13 @@ int r4k_clockevent_init(void)
 
 	cp0_timer_irq_installed = 1;
 
+	/*
+	 * With vectored interrupts things are getting platform specific.
+	 * get_c0_compare_int is a hook to allow a platform to return the
+	 * interrupt number of its liking.
+	 */
+	irq = get_c0_compare_int();
+
 	if (request_irq(irq, c0_compare_interrupt, flags, "timer",
 			c0_compare_interrupt))
 		pr_err("Failed to request irq %d (timer)\n", irq);
-- 
2.43.0



