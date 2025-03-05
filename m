Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C3539A;
	Wed,  5 Mar 2025 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197840; cv=none; b=dvFgyoCEnRlxyR3bgf4PMu6EYYUtCSv7SIbQnR0CDzHznwZkBpSP54kf5BPEQFldm667pdoDswo9qPC5lbg3JyqHjeEpQ5sn3NI50Ov9XCFlZIZ9/hBrCjXI2BqAf61yPzU/K455ahmSpM86ZvoGgX7/ozWn8CQLlg52wHOuphA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197840; c=relaxed/simple;
	bh=P/kfTWzlUWaLwA2oTsMhRd2LWN594njOR2tIGvtS7Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVSo0XT46ZK+Z+wUnYVXYP2KHbVhDNm5vMacLdedlYdp0hU20BmAlTH6yeIfG+BO8a71uhtVjazDGy2cOxPZpgLVM7S1gmsorTsbbFMPbHXbh4Bw1IAG6cWzpXKEibz9Nbli9/30j5IMRn2XyaKkFIuG5ve9susSwhP6eIjOYJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXyJy1iT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXyJy1iT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA7BC4CED1;
	Wed,  5 Mar 2025 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197840;
	bh=P/kfTWzlUWaLwA2oTsMhRd2LWN594njOR2tIGvtS7Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXyJy1iTYxdME58zHmEr3mE7olXuiW3RICFDLK5n+kl0lnNmg7eZcT6AfYYuhYwX8
	 zP56PDqzE+5Okl50RJKwXKxlNqyGJRfzYtiMZxoU/THSTgGe3Ryd2WU+AIwdGIHj1a
	 aR0CbP7BTecIVGSRl3E1tKzDYcUjmA8hy+XcTPUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 119/142] x86/microcode: Sanitize __wait_for_cpus()
Date: Wed,  5 Mar 2025 18:48:58 +0100
Message-ID: <20250305174505.110894512@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 0772b9aa1a8f7322dce8588c231cff8b57298a53 upstream

The code is too complicated for no reason:

 - The return value is pointless as this is a strict boolean.

 - It's way simpler to count down from num_online_cpus() and check for
   zero.

  - The timeout argument is pointless as this is always one second.

  - Touching the NMI watchdog every 100ns does not make any sense, neither
    does checking every 100ns. This is really not a hotpath operation.

Preload the atomic counter with the number of online CPUs and simplify the
whole timeout logic. Delay for one microsecond and touch the NMI watchdog
once per millisecond.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115903.204251527@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/core.c |   39 +++++++++++++++--------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -252,31 +252,26 @@ static struct platform_device	*microcode
  *   requirement can be relaxed in the future. Right now, this is conservative
  *   and good.
  */
-#define SPINUNIT 100 /* 100 nsec */
+static atomic_t late_cpus_in, late_cpus_out;
 
-
-static atomic_t late_cpus_in;
-static atomic_t late_cpus_out;
-
-static int __wait_for_cpus(atomic_t *t, long long timeout)
+static bool wait_for_cpus(atomic_t *cnt)
 {
-	int all_cpus = num_online_cpus();
+	unsigned int timeout;
 
-	atomic_inc(t);
+	WARN_ON_ONCE(atomic_dec_return(cnt) < 0);
 
-	while (atomic_read(t) < all_cpus) {
-		if (timeout < SPINUNIT) {
-			pr_err("Timeout while waiting for CPUs rendezvous, remaining: %d\n",
-				all_cpus - atomic_read(t));
-			return 1;
-		}
+	for (timeout = 0; timeout < USEC_PER_SEC; timeout++) {
+		if (!atomic_read(cnt))
+			return true;
 
-		ndelay(SPINUNIT);
-		timeout -= SPINUNIT;
+		udelay(1);
 
-		touch_nmi_watchdog();
+		if (!(timeout % USEC_PER_MSEC))
+			touch_nmi_watchdog();
 	}
-	return 0;
+	/* Prevent the late comers from making progress and let them time out */
+	atomic_inc(cnt);
+	return false;
 }
 
 /*
@@ -294,7 +289,7 @@ static int __reload_late(void *info)
 	 * Wait for all CPUs to arrive. A load will not be attempted unless all
 	 * CPUs show up.
 	 * */
-	if (__wait_for_cpus(&late_cpus_in, NSEC_PER_SEC))
+	if (!wait_for_cpus(&late_cpus_in))
 		return -1;
 
 	/*
@@ -317,7 +312,7 @@ static int __reload_late(void *info)
 	}
 
 wait_for_siblings:
-	if (__wait_for_cpus(&late_cpus_out, NSEC_PER_SEC))
+	if (!wait_for_cpus(&late_cpus_out))
 		panic("Timeout during microcode update!\n");
 
 	/*
@@ -344,8 +339,8 @@ static int microcode_reload_late(void)
 	pr_err("Attempting late microcode loading - it is dangerous and taints the kernel.\n");
 	pr_err("You should switch to early loading, if possible.\n");
 
-	atomic_set(&late_cpus_in,  0);
-	atomic_set(&late_cpus_out, 0);
+	atomic_set(&late_cpus_in, num_online_cpus());
+	atomic_set(&late_cpus_out, num_online_cpus());
 
 	/*
 	 * Take a snapshot before the microcode update in order to compare and


