Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076F72C324F;
	Mon,  2 Jun 2025 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875986; cv=none; b=kCoJ0wbPGZMJEyDm8XyCcRp7yRnwYHBYXXk3IjSifMgNeMuewZJ/52zjLZchmANJ10D8++QJ4Zh8GGfL4eouyA2rZGBqKakyHl6AAwiJQFQKM9Jgud01Y+3bD1iZIvoI+vOiYzu0OozeXO0+At9P3gY9nWeWbpqwJQMkpMW+FfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875986; c=relaxed/simple;
	bh=m+mFJ1WaC4Bc4FUlACunn872s8n6FbDC9aMta+UJk2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4hzbSPSeooR8j/jS3mBUdj89AemuUK9qhDLdvCY5q4vKtDANzML/FbwykYpuElfWzJ2hnXfj5rNyEHEIa9UskpGYnXBylkxDSdewnJSa9U0AFzgkOpM3Si6hII0Q5DjgIg44okg7t28URSFbH6O8u0otEQuFcThwBVL9eFYaRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8GmdYgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8GmdYgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69464C4CEEB;
	Mon,  2 Jun 2025 14:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875985;
	bh=m+mFJ1WaC4Bc4FUlACunn872s8n6FbDC9aMta+UJk2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8GmdYgXtG7jlND5OkgYAj8He9VMx0sWd/dF7kGDVAPO7h/pT0Om6CP//anR+qIqF
	 QavJAvlFfLV2EMRiqJtS7cKugREwMrTMsW+fyqCyIb9vFkXWT5Ideh5Uahhv3IGdYV
	 GD2Zu4Iyj+AkumopnJmhoea//CXtwJj24ZYRUDU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <anup@brainfault.org>,
	Nick Hu <nick.hu@sifive.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/207] clocksource/drivers/timer-riscv: Stop stimecmp when cpu hotplug
Date: Mon,  2 Jun 2025 15:46:48 +0200
Message-ID: <20250602134300.175423201@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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
index c51c5ed15aa75..427c92dd048c4 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -75,7 +75,13 @@ static int riscv_timer_starting_cpu(unsigned int cpu)
 
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



