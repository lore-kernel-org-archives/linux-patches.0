Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C226D4F2;
	Tue, 15 Jul 2025 13:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585543; cv=none; b=ROjv9cqagaUFmAqPnclBTEeJixKDmxwNcd2E5yasxjorNWYsmN6bFi58qeACKpPBD2SNsvMtATBAubLiHnsSjuVTZg+D9rUXqykjQYFRbgm7+0JAbTRG6dIlm84NyrttKG5+HnYVmtUPRQuu7KS8H7s0m/FN2nNKXX5wpDNopMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585543; c=relaxed/simple;
	bh=2NyGu/U6UVKpFzi5rAkRH3cF/B2Vfg9AzbJGmgs1md0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLWrzAraIlA3O8YSUv+SyNyKevt+SjU2CEO/XZMrZQn6VTyEIXZ48JE3AtAQPHwJmZ04nZhB6UWA+h+4Hhdyzlg04yjUHGXCAwoyG3+7ILz8JobUY/w2BlEFPG+zcSB4UKG2Q8cO8ZfWQKvi9gUQu3bmI5830RPvASmH7djOQ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOMhugha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOMhugha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DA8C4CEE3;
	Tue, 15 Jul 2025 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585542;
	bh=2NyGu/U6UVKpFzi5rAkRH3cF/B2Vfg9AzbJGmgs1md0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOMhugha5uC94I+RYj2V7g/0HR1ct6BX6j+9cw2Ii2YHUS+K3ix5jBkpF84Kes5Le
	 MDrG3s5ahlYPY4e2ZySC+H0mYnNoKmbRKgQgMv58p9Z9ZBE+zQNQ3puYHuh0tqn6gN
	 LUNKrWFYY15yckhF8nrDuz4Lo43Ntyv3R9/WGnTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 052/163] x86/mce: Ensure user polling settings are honored when restarting timer
Date: Tue, 15 Jul 2025 15:12:00 +0200
Message-ID: <20250715130810.843881965@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 00c092de6f28ebd32208aef83b02d61af2229b60 upstream.

Users can disable MCA polling by setting the "ignore_ce" parameter or by
setting "check_interval=0". This tells the kernel to *not* start the MCE
timer on a CPU.

If the user did not disable CMCI, then storms can occur. When these
happen, the MCE timer will be started with a fixed interval. After the
storm subsides, the timer's next interval is set to check_interval.

This disregards the user's input through "ignore_ce" and
"check_interval". Furthermore, if "check_interval=0", then the new timer
will run faster than expected.

Create a new helper to check these conditions and use it when a CMCI
storm ends.

  [ bp: Massage. ]

Fixes: 7eae17c4add5 ("x86/mce: Add per-bank CMCI storm mitigation")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250624-wip-mca-updates-v4-2-236dd74f645f@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1688,6 +1688,11 @@ static void mc_poll_banks_default(void)
 
 void (*mc_poll_banks)(void) = mc_poll_banks_default;
 
+static bool should_enable_timer(unsigned long iv)
+{
+	return !mca_cfg.ignore_ce && iv;
+}
+
 static void mce_timer_fn(struct timer_list *t)
 {
 	struct timer_list *cpu_t = this_cpu_ptr(&mce_timer);
@@ -1711,7 +1716,7 @@ static void mce_timer_fn(struct timer_li
 
 	if (mce_get_storm_mode()) {
 		__start_timer(t, HZ);
-	} else {
+	} else if (should_enable_timer(iv)) {
 		__this_cpu_write(mce_next_interval, iv);
 		__start_timer(t, iv);
 	}
@@ -2111,11 +2116,10 @@ static void mce_start_timer(struct timer
 {
 	unsigned long iv = check_interval * HZ;
 
-	if (mca_cfg.ignore_ce || !iv)
-		return;
-
-	this_cpu_write(mce_next_interval, iv);
-	__start_timer(t, iv);
+	if (should_enable_timer(iv)) {
+		this_cpu_write(mce_next_interval, iv);
+		__start_timer(t, iv);
+	}
 }
 
 static void __mcheck_cpu_setup_timer(void)


