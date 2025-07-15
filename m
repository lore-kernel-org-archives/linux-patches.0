Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB98F2E5B2B;
	Tue, 15 Jul 2025 13:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586909; cv=none; b=hkYjo9MeKfp/t1nnj51sEK4Fl0VLNDqWaVj7pyr0Xizedd6Ch26i3Bx3HW2E9vuYTp0M348pxpwIhK+NFmS4hUX2NojN9dOJ6gPPDMPEPAvCeBBbOKCb0+bdihfFVWOiqBFoMpWnqo91sOE/8UFP9wwOCIgZTOSqsZhm1zXXjgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586909; c=relaxed/simple;
	bh=OL2sU3SZfB16b21CZrrHh2VXgLleuZs02y48IXC94G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fxakh6OoLYnMvFN90rhtVBDL+EvIXVuLK43UaXL75iIf5iIixcVqTUFvzzbrd9BuHWbB/U5vDgNBkJ0P6kv+FBFq81yMo1Uxl0/QifbS7u5vezdu7zRZPhNVWJPPhlNz4s7OscbwWltBMmLIR+XJIqam518UiMUdV6HvJ/NWY/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klHELxLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klHELxLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A59CC4CEE3;
	Tue, 15 Jul 2025 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586909;
	bh=OL2sU3SZfB16b21CZrrHh2VXgLleuZs02y48IXC94G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klHELxLADiURK2v7I0LgBlJomHMJkyI9b0LC1YrE8XWaAr0G0OH+5lE2NkvZvqmyZ
	 Vv1avKer2NEwwvDMozONxb8NrXJ2zaEiD0ctKvtDYvWndJh9J9Dzu0ztW1guAt21Fy
	 uPWO1nJ4KCt6hAwTP4TQgIsY9gWoRRG34LUu5wJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.15 054/192] x86/mce: Ensure user polling settings are honored when restarting timer
Date: Tue, 15 Jul 2025 15:12:29 +0200
Message-ID: <20250715130817.011655744@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1740,6 +1740,11 @@ static void mc_poll_banks_default(void)
 
 void (*mc_poll_banks)(void) = mc_poll_banks_default;
 
+static bool should_enable_timer(unsigned long iv)
+{
+	return !mca_cfg.ignore_ce && iv;
+}
+
 static void mce_timer_fn(struct timer_list *t)
 {
 	struct timer_list *cpu_t = this_cpu_ptr(&mce_timer);
@@ -1763,7 +1768,7 @@ static void mce_timer_fn(struct timer_li
 
 	if (mce_get_storm_mode()) {
 		__start_timer(t, HZ);
-	} else {
+	} else if (should_enable_timer(iv)) {
 		__this_cpu_write(mce_next_interval, iv);
 		__start_timer(t, iv);
 	}
@@ -2156,11 +2161,10 @@ static void mce_start_timer(struct timer
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


