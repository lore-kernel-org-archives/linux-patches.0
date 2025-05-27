Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7FB27FD76;
	Tue, 27 May 2025 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366741; cv=none; b=qsEAEuVm5160IKR702AW8HnblQl+mifNoNzOv4YAFF9/qWHZkqcvBYVt7FvfBtZ1mx8/JlJ0ti7uWxy/G44SM32Eb70d/0f3a2wl/zsGOsvt1ZdEDJSYdd74Gic5oiOxzX2D5MUVj8HZnNWJO0fdxtS/ZzIuuS3gAIjjFcoayjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366741; c=relaxed/simple;
	bh=xamDZAvF6Rcre78cMuQCGrDHIfI74PCasYad+GiShS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=og52y/pAHSkMJ7Kq/rJR8/+Hsxtng8DpmCoiJVmkO6QgJQyPydwooLHcRymlZ6u3qAuEP0EDGeUMsWNcRVWN1ptdCI46EcxcM+Hk6hhf/fJhplKeqki8zG/HynlapGGlG4K8i0/mSOZ5KvOObQArXXnQToH7zC7+oygCv35XP/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnXgQVjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnXgQVjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027AEC4CEE9;
	Tue, 27 May 2025 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366741;
	bh=xamDZAvF6Rcre78cMuQCGrDHIfI74PCasYad+GiShS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnXgQVjCfWPIC96srZTCAZU9KJtmKEL7Wv5hq2q5Zr6aTeDdQO0yh42oW6wDb1Esg
	 48j9S0HrzWCevXXpms2mRUpIkxZg5UHxrCBr6J/D5IenICAS1gDw+nJcxoU0fPdwI5
	 PRjFhI3neZV2vgy5LPVKbuCTHoUDxbWk4C4wXpQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <anup@brainfault.org>,
	Nick Hu <nick.hu@sifive.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 149/783] clocksource/drivers/timer-riscv: Stop stimecmp when cpu hotplug
Date: Tue, 27 May 2025 18:19:06 +0200
Message-ID: <20250527162519.226308921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit 70c93b026ed07078e933583591aa9ca6701cd9da ]

Stop the timer when the cpu is going to be offline otherwise the
timer interrupt may be pending while performing power-down.

Suggested-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/lkml/20240829033904.477200-3-nick.hu@sifive.com/T/#u
Signed-off-by: Nick Hu <nick.hu@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20250219114135.27764-3-nick.hu@sifive.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-riscv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 48ce50c5f5e68..4d7cf338824a3 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -126,7 +126,13 @@ static int riscv_timer_starting_cpu(unsigned int cpu)
 
 static int riscv_timer_dying_cpu(unsigned int cpu)
 {
+	/*
+	 * Stop the timer when the cpu is going to be offline otherwise
+	 * the timer interrupt may be pending while performing power-down.
+	 */
+	riscv_clock_event_stop();
 	disable_percpu_irq(riscv_clock_event_irq);
+
 	return 0;
 }
 
-- 
2.39.5



