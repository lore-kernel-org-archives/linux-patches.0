Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FF03EDE43;
	Tue, 12 May 2026 17:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608592; cv=none; b=O8VaBDX0aOgKeAR0aqYBeOeWncm6RWFy7+ub2guvu3TX1G32ADPUy8VRLA1EkKtTj3Fcn/7RTgr8UrDEDBy/jvdEIiM9DYxwDyPxyx2o6Zb7rTmZVU/YcLmsJRfKH1sSm9orovXJ3Yzhu5H5/t8DI0g3/6BZYcAXGSZ0M8LkZTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608592; c=relaxed/simple;
	bh=CeHgZQ0sp7z5kaC3FghAt+HWLattitru/AXAz/2cOjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwpvDtO1trYcwRfoXt1rR1y0GQ+F37qim4zJ6KTlIDzCt/a5VpK0/+M9fKOma5nAozC/xlRpLkw2KeuGekOgCnI3/QZ9LzhoF8HH/X4V726ElRWKw0PUUSnAYWZiByb8kOAUqmbUKQZKxLD6RvyUt5327sCYQP08Udh+U2r8d4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lz0bCHhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lz0bCHhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD56C2BCB0;
	Tue, 12 May 2026 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608592;
	bh=CeHgZQ0sp7z5kaC3FghAt+HWLattitru/AXAz/2cOjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lz0bCHhp9c4PJKq8wYPhh8OZTlgLQWtlaDg98gPzIUaoISbzXKQXQZld+02lg4d2M
	 okVeTDRJryPXvUAW+1LVAQpGaaFGFzVLQ/RQMR9zKcZMxph831YEXOLODRAcyCzXgj
	 6aOWRqSFIoq7a3AJNTU9RUpW5OALEs4q7A+NqCYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 140/270] cpuidle: powerpc: avoid double clear when breaking snooze
Date: Tue, 12 May 2026 19:39:01 +0200
Message-ID: <20260512173941.398629323@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,7 +64,10 @@ int snooze_loop(struct cpuidle_device *d
 	}
 
 	HMT_medium();
-	clear_thread_flag(TIF_POLLING_NRFLAG);
+
+       /* Avoid double clear when breaking */
+	if (!dev->poll_time_limit)
+		clear_thread_flag(TIF_POLLING_NRFLAG);
 
 	raw_local_irq_disable();
 


