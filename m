Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD9430F95C;
	Mon, 13 Oct 2025 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369010; cv=none; b=D49atbB0MHmPKZZ48S4k/zrWI6K8MIFFVKSRzYdY/pL64S1zzWduafb+Is1qvUnIZzwKpP5A+IIgHs1TQmMc9RLD28oEkCxFv03OQHkyEdPex2Tqu8DNIB/pHTrE/etyyABzSI2m1kEReaydErWPLNmbJ6ipvdAaD3T4DkySdVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369010; c=relaxed/simple;
	bh=/NFYVuvu3ZJ66/+M+h5ir8CcoQScab33e7N4viit/dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP7myfsjiMBF4Nu4siWvZYK1uoaIvZUwDa99LwTl/wsYmV7S+iFZ1XDH0yp8yAtUkyyIaKuRtGxVdB4mCaYlBItHnkWaxUfCHLvpTN2h+7D7yyreRmwV4oGOfJQlC+uSIuP1wspUUzSFNBIh+0pyOd+KiceuUVXwBidTtmzCJE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvTi2qSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvTi2qSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F88C116B1;
	Mon, 13 Oct 2025 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369009;
	bh=/NFYVuvu3ZJ66/+M+h5ir8CcoQScab33e7N4viit/dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvTi2qShEFmO/tYHFl5xYR+28wHOC5YFaoPpie1hIQQNgD7mVLdjT4BCdis0GL4no
	 IHUNfa1g13CzYO2A/57NNwuOQ3VQ/KxhIkdv0GjbH9Z8khE7ls+wSM/2yZqSjXPbkk
	 BHZnFnNOleF8biMad59RB5LcbxzIVUtWbanQanXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Brian Norris <briannorris@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 089/563] genirq/test: Drop CONFIG_GENERIC_IRQ_MIGRATION assumptions
Date: Mon, 13 Oct 2025 16:39:10 +0200
Message-ID: <20251013144414.522147431@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit add03fdb9d52411cabb3872fb7692df6f4c67586 ]

Not all platforms use the generic IRQ migration code, even if they select
GENERIC_IRQ_MIGRATION. (See, for example, powerpc / pseries_cpu_disable().)

If such platforms don't perform managed shutdown the same way, the interrupt
may not actually shut down, and these tests fail:

[    4.357022][  T101]     # irq_cpuhotplug_test: EXPECTATION FAILED at kernel/irq/irq_test.c:211
[    4.357022][  T101]     Expected irqd_is_activated(data) to be false, but is true
[    4.358128][  T101]     # irq_cpuhotplug_test: EXPECTATION FAILED at kernel/irq/irq_test.c:212
[    4.358128][  T101]     Expected irqd_is_started(data) to be false, but is true
[    4.375558][  T101]     # irq_cpuhotplug_test: EXPECTATION FAILED at kernel/irq/irq_test.c:216
[    4.375558][  T101]     Expected irqd_is_activated(data) to be false, but is true
[    4.376088][  T101]     # irq_cpuhotplug_test: EXPECTATION FAILED at kernel/irq/irq_test.c:217
[    4.376088][  T101]     Expected irqd_is_started(data) to be false, but is true
[    4.377851][    T1]     # irq_cpuhotplug_test: pass:0 fail:1 skip:0 total:1
[    4.377901][    T1]     not ok 4 irq_cpuhotplug_test
[    4.378073][    T1] # irq_test_cases: pass:3 fail:1 skip:0 total:4

Rather than test that PowerPC performs migration the same way as the
unterrupt core, just drop the state checks. The point of the test was to
ensure that the code kept |depth| balanced, which still can be tested for.

Fixes: 66067c3c8a1e ("genirq: Add kunit tests for depth counts")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/all/20250822190140.2154646-6-briannorris@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irq_test.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/irq/irq_test.c b/kernel/irq/irq_test.c
index e220e7b2fc187..37568ec714b51 100644
--- a/kernel/irq/irq_test.c
+++ b/kernel/irq/irq_test.c
@@ -208,13 +208,9 @@ static void irq_cpuhotplug_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, desc->depth, 1);
 
 	KUNIT_EXPECT_EQ(test, remove_cpu(1), 0);
-	KUNIT_EXPECT_FALSE(test, irqd_is_activated(data));
-	KUNIT_EXPECT_FALSE(test, irqd_is_started(data));
 	KUNIT_EXPECT_GE(test, desc->depth, 1);
 	KUNIT_EXPECT_EQ(test, add_cpu(1), 0);
 
-	KUNIT_EXPECT_FALSE(test, irqd_is_activated(data));
-	KUNIT_EXPECT_FALSE(test, irqd_is_started(data));
 	KUNIT_EXPECT_EQ(test, desc->depth, 1);
 
 	enable_irq(virq);
-- 
2.51.0



