Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F5021882B;
	Mon,  2 Jun 2025 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874808; cv=none; b=iHViqArRnlURm5ZbZOtPkd0Kjp4kAtsEkqinDnN0lLfd8s+Go679Ai5jR4iLv5+LpIMW4RJL8nv+nMg22Ahx7ktR7yV1sgLJyGLQqosTt2ZVsEGMQ3+cIgf0aXbmkxehbJFt2oMsqUdHNsidfF2qlc7wWj0YbLmg6Al0m4DQ59E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874808; c=relaxed/simple;
	bh=zE74Qtg+P3cPP5ujGmmZGKKVfq7G8zKruiFCN53DPIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBe2dUxYg88uJSaO9ywV7Wn9AAQSRxa8r4EhLoTE97rIDTsGLoJBDxUDmFogjXy9K4z3G192bSuD/1mS8ydWb0cAR7YZYiEmpJkNvbUmEunVPiZvgn+lF/rbGjUyy9nBI73nRim2PrgKkHO7U8En0G1ln/SJrLgGWjXoDcIFOPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+2V6vPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+2V6vPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D804C4CEEB;
	Mon,  2 Jun 2025 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874808;
	bh=zE74Qtg+P3cPP5ujGmmZGKKVfq7G8zKruiFCN53DPIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+2V6vPWHpCQrQLkVhO7KGit/YTWl/rXTvEUGb5xcKQITJCciqxUnVhQdaF4mlIyl
	 8PWIKfQ/Q6j17xp/woKVnBCqkMSxl0ITSYJWZDPFw3VO+sVMuiiG1ujp4OtjivCsDG
	 C2Fl190rOmb3na6c7Zghwq5UG5W9Ngyw33pUAq8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/204] posix-timers: Add cond_resched() to posix_timer_add() search loop
Date: Mon,  2 Jun 2025 15:47:24 +0200
Message-ID: <20250602134300.023325185@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5f2909c6cd13564a07ae692a95457f52295c4f22 ]

With a large number of POSIX timers the search for a valid ID might cause a
soft lockup on PREEMPT_NONE/VOLUNTARY kernels.

Add cond_resched() to the loop to prevent that.

[ tglx: Split out from Eric's series ]

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/all/20250214135911.2037402-2-edumazet@google.com
Link: https://lore.kernel.org/all/20250308155623.635612865@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index f3b8313475acd..2a2e4f6622ae7 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -159,6 +159,7 @@ static int posix_timer_add(struct k_itimer *timer)
 			return id;
 		}
 		spin_unlock(&hash_lock);
+		cond_resched();
 	}
 	/* POSIX return code when no timer ID could be allocated */
 	return -EAGAIN;
-- 
2.39.5



