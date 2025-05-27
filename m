Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F89A277808;
	Tue, 27 May 2025 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366849; cv=none; b=YlJTOFJDyfxZ3xwT42MdlnPg8dxJfpEpSaI8gZ0uwN4Hfs+IBgWh30eBH8E86Kj+NoV3MVa15OcdF5KHT6qdTkeXsnyZtwxNetocb0JF8tAQlyAN6KsRMsWFGz+o2v9YSUJ94so0GEpQAsz5o4YII7aKOVqyuo7KazbLc6iO/CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366849; c=relaxed/simple;
	bh=5wcOxhssV8wkq3cvZZazw9OA0MEYbklqDNB7X8qSuQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uddT0EH3/x7ESCUHnYhwuOaLfO0XDFpZQ1SgG+zQhgNElfOMboWFmBjK+KHBAKkIyEAy8YDWI4E+YZ44uPzAXnnGL2NYVRZ5ays7o1k2BHmkXrmzI0g0Kxer/qymQ9iQTPup7auzXyMEITiXTM68dXCrl5bcIU2Hj7u/yCjhyQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcbqLak8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcbqLak8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672DAC4CEEB;
	Tue, 27 May 2025 17:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366848;
	bh=5wcOxhssV8wkq3cvZZazw9OA0MEYbklqDNB7X8qSuQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcbqLak8+T9YvUUGQ5nLJeb+vTeSV71OnH1egledkJI7JyCMfpZ1iRekPLA95c5zi
	 mz9KFytRYKQsWS10gNvIN0EOdG+//gvlyNKIzLEWctPSzkQ2mzmwD3YH7U85/2iBNZ
	 enaUc50fAksWdV57vgWVwrFm6W/YlpkzVBjsqB70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 197/783] posix-timers: Add cond_resched() to posix_timer_add() search loop
Date: Tue, 27 May 2025 18:19:54 +0200
Message-ID: <20250527162521.172255820@linuxfoundation.org>
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
index 1b675aee99a98..7f8644e047558 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -118,6 +118,7 @@ static int posix_timer_add(struct k_itimer *timer)
 			return id;
 		}
 		spin_unlock(&hash_lock);
+		cond_resched();
 	}
 	/* POSIX return code when no timer ID could be allocated */
 	return -EAGAIN;
-- 
2.39.5



