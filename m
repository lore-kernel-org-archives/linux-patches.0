Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9421E3101BB;
	Mon, 13 Oct 2025 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368984; cv=none; b=PR5Lk5rg3keLEncj7KqShNQw8pCE47H9mB6tn1ATt4dBK7KOG9K79+8syvCiTR+bBUpNzVBP1RSPkNCiYX5/UGQp+7cVblM71oq7MMxWgXiFnBfHJyY1bpADF4/dedzLu299mz8Lq1cUsywKg9XFTK6qo/MNYTBAg80T3IrnOzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368984; c=relaxed/simple;
	bh=X2Zvvt+HTTOQNaYSVwqeH7nX3WWCNNKxkM8K9u0TnSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfUGyvT6JTcMashuMaTJg+79bBLCEvCoTJg065d6H4VGiiF71UAsi74JLctkNvzg7NANEjS65ADw+NYyV/AamNBYrc/KhzkvxpEIkmwJ/KeJ9E5TFztXSQRiLBKZ2bGUiMR63a5GkkAyaiURgVn32l6uy29eiJ0AXBHZ6UgOW94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJrPSUpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJrPSUpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21153C4CEE7;
	Mon, 13 Oct 2025 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368984;
	bh=X2Zvvt+HTTOQNaYSVwqeH7nX3WWCNNKxkM8K9u0TnSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJrPSUpFl2kds/2F4Gi6BiOXgczcwteg709FU18JLMJ9PyyxYr6NuHD1+/vDJiXFb
	 ZMa6f5YtJke27tSkNcDP2l7XRKL573ECm3ePHG2qv4yJW8OhkYJozPla6U1UfZqkcT
	 e2cfVep1dbdaJMS6ZMZ3iKIiLScHg5H00Y+4Xhuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Brian Norris <briannorris@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 086/563] genirq/test: Fix depth tests on architectures with NOREQUEST by default.
Date: Mon, 13 Oct 2025 16:39:07 +0200
Message-ID: <20251013144414.412283832@linuxfoundation.org>
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

From: David Gow <davidgow@google.com>

[ Upstream commit c9163915a93d40e32c4e4aeb942c0adcb190d72e ]

The new irq KUnit tests fail on some architectures (notably PowerPC and
32-bit ARM), as the request_irq() call fails due to the ARCH_IRQ_INIT_FLAGS
containing IRQ_NOREQUEST, yielding the following errors:

[10:17:45]     # irq_free_disabled_test: EXPECTATION FAILED at kernel/irq/irq_test.c:88
[10:17:45]     Expected ret == 0, but
[10:17:45]         ret == -22 (0xffffffffffffffea)
[10:17:45]     # irq_free_disabled_test: EXPECTATION FAILED at kernel/irq/irq_test.c:90
[10:17:45]     Expected desc->depth == 0, but
[10:17:45]         desc->depth == 1 (0x1)
[10:17:45]     # irq_free_disabled_test: EXPECTATION FAILED at kernel/irq/irq_test.c:93
[10:17:45]     Expected desc->depth == 1, but
[10:17:45]         desc->depth == 2 (0x2)

By clearing IRQ_NOREQUEST from the interrupt descriptor, these tests now
pass on ARM and PowerPC.

Fixes: 66067c3c8a1e ("genirq: Add kunit tests for depth counts")
Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/all/20250816094528.3560222-2-davidgow@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irq_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/irq/irq_test.c b/kernel/irq/irq_test.c
index a75abebed7f24..e220e7b2fc187 100644
--- a/kernel/irq/irq_test.c
+++ b/kernel/irq/irq_test.c
@@ -54,6 +54,9 @@ static void irq_disable_depth_test(struct kunit *test)
 	desc = irq_to_desc(virq);
 	KUNIT_ASSERT_PTR_NE(test, desc, NULL);
 
+	/* On some architectures, IRQs are NOREQUEST | NOPROBE by default. */
+	irq_settings_clr_norequest(desc);
+
 	ret = request_irq(virq, noop_handler, 0, "test_irq", NULL);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
@@ -81,6 +84,9 @@ static void irq_free_disabled_test(struct kunit *test)
 	desc = irq_to_desc(virq);
 	KUNIT_ASSERT_PTR_NE(test, desc, NULL);
 
+	/* On some architectures, IRQs are NOREQUEST | NOPROBE by default. */
+	irq_settings_clr_norequest(desc);
+
 	ret = request_irq(virq, noop_handler, 0, "test_irq", NULL);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
@@ -120,6 +126,9 @@ static void irq_shutdown_depth_test(struct kunit *test)
 	desc = irq_to_desc(virq);
 	KUNIT_ASSERT_PTR_NE(test, desc, NULL);
 
+	/* On some architectures, IRQs are NOREQUEST | NOPROBE by default. */
+	irq_settings_clr_norequest(desc);
+
 	data = irq_desc_get_irq_data(desc);
 	KUNIT_ASSERT_PTR_NE(test, data, NULL);
 
@@ -180,6 +189,9 @@ static void irq_cpuhotplug_test(struct kunit *test)
 	desc = irq_to_desc(virq);
 	KUNIT_ASSERT_PTR_NE(test, desc, NULL);
 
+	/* On some architectures, IRQs are NOREQUEST | NOPROBE by default. */
+	irq_settings_clr_norequest(desc);
+
 	data = irq_desc_get_irq_data(desc);
 	KUNIT_ASSERT_PTR_NE(test, data, NULL);
 
-- 
2.51.0



