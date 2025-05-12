Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F1129B8EF;
	Mon, 12 May 2025 18:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073098; cv=none; b=glmTxnB6FGz3bXw9HpG6vlbDEe/cPkd19tuL24b3XtRBeG8w9Y0+6CKY3gqjsxjYgSbrJSQrFU72iDHCPSGdkviw1G1yaNQNWWGU2j/Nvu4+hROBQmEVUbC4lv5GNnh28Gl7Kb+nyLeRIGHWNQtG0DciYwQmC/5vwtgAf4r4tog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073098; c=relaxed/simple;
	bh=DyFsoaXQNuFZVP83ucHhGz68ZFKJLn+iAxzXwJJ/mxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1F2x7Jtfuk9xsp5wY763Y+3Gcg3s+l3cIAVG6OoakRA6hjbHXkdAQcqfVhj3IcZcKbBfk5nilOQsSxAWYOEguN1h+RgeLXpOr+z9HmCqhLUZuzUAj6ZDoL1nP6ZJJ9VG18mxThYnL5VV4vy/I85lU6BBz6lIl+NIkXslt9dZ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3PO9jtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3PO9jtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07389C4CEF2;
	Mon, 12 May 2025 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073098;
	bh=DyFsoaXQNuFZVP83ucHhGz68ZFKJLn+iAxzXwJJ/mxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3PO9jtlAxZvtwe2Miy2UpyREGg2AyxBhu9mTB2eduC0r/wc+QhKyAFy3vjPNqBqt
	 Ensjs3J0hqdnDu/fgTNw82V8WWfs+ZdA4yUwSWyro7QG5mMn+WXW9yR+5UsRFl+Kyq
	 c48q2ytGZabi+pj4vcU3SD6574eH0riIcsZ7Waag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 6.12 153/184] [PATCH 6.12] Revert "um: work around sched_yield not yielding in time-travel mode"
Date: Mon, 12 May 2025 19:45:54 +0200
Message-ID: <20250512172048.048306915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Christian Lamparter <chunkeey@gmail.com>

This reverts commit da780c4a075ba2deb05ae29f0af4a990578c7901 which is
commit 887c5c12e80c8424bd471122d2e8b6b462e12874 upstream.


Reason being that the patch depends on at least commit 0b8b2668f998
("um: insert scheduler ticks when userspace does not yield") in order to
build. Otherwise it fails with:

| /usr/bin/ld: arch/um/kernel/skas/syscall.o: in function `handle_syscall':
|      linux-6.12.27/arch/um/kernel/skas/syscall.c:43:(.text+0xa2): undefined
| reference to `tt_extra_sched_jiffies'
| collect2: error: ld returned 1 exit status

The author Benjamin Berg commented: "I think it is better to just not
backport commit 0b8b2668f998 ("um: insert scheduler ticks when userspace
does not yield")"

Link: https://lore.kernel.org/linux-um/8ce0b6056a9726e540f61bce77311278654219eb.camel@sipsolutions.net/
Cc: <stable@vger.kernel.org> # 6.12.y
Cc: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/include/linux/time-internal.h |    2 --
 arch/um/kernel/skas/syscall.c         |   11 -----------
 2 files changed, 13 deletions(-)

--- a/arch/um/include/linux/time-internal.h
+++ b/arch/um/include/linux/time-internal.h
@@ -83,8 +83,6 @@ extern void time_travel_not_configured(v
 #define time_travel_del_event(...) time_travel_not_configured()
 #endif /* CONFIG_UML_TIME_TRAVEL_SUPPORT */
 
-extern unsigned long tt_extra_sched_jiffies;
-
 /*
  * Without CONFIG_UML_TIME_TRAVEL_SUPPORT this is a linker error if used,
  * which is intentional since we really shouldn't link it in that case.
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -31,17 +31,6 @@ void handle_syscall(struct uml_pt_regs *
 		goto out;
 
 	syscall = UPT_SYSCALL_NR(r);
-
-	/*
-	 * If no time passes, then sched_yield may not actually yield, causing
-	 * broken spinlock implementations in userspace (ASAN) to hang for long
-	 * periods of time.
-	 */
-	if ((time_travel_mode == TT_MODE_INFCPU ||
-	     time_travel_mode == TT_MODE_EXTERNAL) &&
-	    syscall == __NR_sched_yield)
-		tt_extra_sched_jiffies += 1;
-
 	if (syscall >= 0 && syscall < __NR_syscalls) {
 		unsigned long ret = EXECUTE_SYSCALL(syscall, regs);
 


