Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112223955D6;
	Tue, 12 May 2026 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608072; cv=none; b=WBmBhWGY/puO3hT45ceKpVD4RD2/8tVFaq7Oc2mx5zqIHxlRhhLooPHoOH4vvLZOeHl5KDJIWS73OKfvdNmtUGpCcsF46PXfgNU0mzVzaobod3Dj8XvI4inaHbBFOV6PechH1kfF8m8ZYM5HkDQb8kFv385JoOUWFGyVSQG4qXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608072; c=relaxed/simple;
	bh=5ulScWftFuDiFkgOq4ezjh061B5ECvJpb0h9kyWvHGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsKvGmKzhBsBPB5f3TtR5x7Pb+5xA7sPiaTPEhmUQ/YShcogAG6TIUJJGgTwXnCzYdDOROsyuzoCh+eRauuhIwwX6hJkczW3z3S7uUT9liuN0QlfgvxbPwZaUxFUpr0I1MjRi3DaClvpU5xbb7mHbJ5XPuwDZynQldfB3gSyWHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGN4B4HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGN4B4HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA64C2BCB0;
	Tue, 12 May 2026 17:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608072;
	bh=5ulScWftFuDiFkgOq4ezjh061B5ECvJpb0h9kyWvHGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGN4B4HNLjSeGvFRqs506QpnxaWcK0oH+mzSBOTRptw41ZagmYzUEc9w4vzv0IQWw
	 ysyDSXmx4QQvjUSwyNLtn3on7Ve+smJIvP8XJpFbrO+D+xOnmMCwIFeacjSaLbLSN+
	 B0RhDopY9RAAJbSXdR8QgvwcSMaCOYNOov9THLMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 107/206] cpuidle: powerpc: avoid double clear when breaking snooze
Date: Tue, 12 May 2026 19:39:19 +0200
Message-ID: <20260512173935.122832607@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shrikanth Hegde <sshegde@linux.ibm.com>

commit 64ed1e3e728afb57ba9acb59e69de930ead847d9 upstream.

snooze_loop is done often in any system which has fair bit of
idle time. So it qualifies for even micro-optimizations.

When breaking the snooze due to timeout, TIF_POLLING_NRFLAG is cleared
twice. Clearing the bit invokes atomics. Avoid double clear and thereby
avoid one atomic write.

dev->poll_time_limit indicates whether the loop was broken due to
timeout. Use that instead of defining a new variable.

Fixes: 7ded429152e8 ("cpuidle: powerpc: no memory barrier after break from idle")
Cc: stable@vger.kernel.org
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260311061709.1230440-1-sshegde@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/cpuidle-powernv.c |    5 ++++-
 drivers/cpuidle/cpuidle-pseries.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -95,7 +95,10 @@ static int snooze_loop(struct cpuidle_de
 
 	HMT_medium();
 	ppc64_runlatch_on();
-	clear_thread_flag(TIF_POLLING_NRFLAG);
+
+	/* Avoid double clear when breaking */
+	if (!dev->poll_time_limit)
+		clear_thread_flag(TIF_POLLING_NRFLAG);
 
 	local_irq_disable();
 
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -63,7 +63,10 @@ int snooze_loop(struct cpuidle_device *d
 	}
 
 	HMT_medium();
-	clear_thread_flag(TIF_POLLING_NRFLAG);
+
+       /* Avoid double clear when breaking */
+	if (!dev->poll_time_limit)
+		clear_thread_flag(TIF_POLLING_NRFLAG);
 
 	raw_local_irq_disable();
 


