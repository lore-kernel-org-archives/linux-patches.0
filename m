Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A91524729E;
	Tue, 29 Apr 2025 17:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948082; cv=none; b=AcPVJzL7zWA4BhRB+eNgA+m7Y9VrQLoOjKRnd36L2J8QOjencXcQnaiSCW9UkyH9JhpDKFIiAWKJ4obd9+Wmt+ZAR++XwPSG5JjLkvRcSRh+CWxRdiMpX0U7GZFFMiyrCbT5YPQl72fdCMddxapl3ZbkLkZOlgFpwZ2cQfaEw7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948082; c=relaxed/simple;
	bh=TEfCvMM0grEnEoOtMP6EEUOfbHhBYNENUDZKs9AfQs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWl9A0hvvCa0NdmTKz66iBFfHaIMz5AIJNWWV8d9zxlFwwptcgdZNzi6qwkb5U82HD2cRLUzG0y26AG1k2TBODOE7GptryCfpHZ0OzNlagZzdfUBM5jBe68T8tJ0hE7JzvtC2BheOiYR4ajdw2qg/i+pxX2ovpRCiyDVTz/BWC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVbpbjRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVbpbjRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DF8C4CEE3;
	Tue, 29 Apr 2025 17:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948081;
	bh=TEfCvMM0grEnEoOtMP6EEUOfbHhBYNENUDZKs9AfQs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVbpbjREWhEEhYnK/HCAJO+p+PASXe6NtyofK78Aw790/G1nYNLrdMEkI6b51jqAs
	 vm28nbrFK7cCWKET4bcfkcZaCBYQPazMYWZ5BmE+ZuQFWqmzzhAG2iiyy9dDrdK3qq
	 zH8ZwKSQS9nIRGr41PzZX6sSGYh+sSSa/S3qK1iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/280] um: work around sched_yield not yielding in time-travel mode
Date: Tue, 29 Apr 2025 18:42:07 +0200
Message-ID: <20250429161122.718302896@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 887c5c12e80c8424bd471122d2e8b6b462e12874 ]

sched_yield by a userspace may not actually cause scheduling in
time-travel mode as no time has passed. In the case seen it appears to
be a badly implemented userspace spinlock in ASAN. Unfortunately, with
time-travel it causes an extreme slowdown or even deadlock depending on
the kernel configuration (CONFIG_UML_MAX_USERSPACE_ITERATIONS).

Work around it by accounting time to the process whenever it executes a
sched_yield syscall.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20250314130815.226872-1-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/linux/time-internal.h |  2 ++
 arch/um/kernel/skas/syscall.c         | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/um/include/linux/time-internal.h b/arch/um/include/linux/time-internal.h
index b22226634ff60..138908b999d76 100644
--- a/arch/um/include/linux/time-internal.h
+++ b/arch/um/include/linux/time-internal.h
@@ -83,6 +83,8 @@ extern void time_travel_not_configured(void);
 #define time_travel_del_event(...) time_travel_not_configured()
 #endif /* CONFIG_UML_TIME_TRAVEL_SUPPORT */
 
+extern unsigned long tt_extra_sched_jiffies;
+
 /*
  * Without CONFIG_UML_TIME_TRAVEL_SUPPORT this is a linker error if used,
  * which is intentional since we really shouldn't link it in that case.
diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscall.c
index b09e85279d2b8..a5beaea2967ec 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -31,6 +31,17 @@ void handle_syscall(struct uml_pt_regs *r)
 		goto out;
 
 	syscall = UPT_SYSCALL_NR(r);
+
+	/*
+	 * If no time passes, then sched_yield may not actually yield, causing
+	 * broken spinlock implementations in userspace (ASAN) to hang for long
+	 * periods of time.
+	 */
+	if ((time_travel_mode == TT_MODE_INFCPU ||
+	     time_travel_mode == TT_MODE_EXTERNAL) &&
+	    syscall == __NR_sched_yield)
+		tt_extra_sched_jiffies += 1;
+
 	if (syscall >= 0 && syscall < __NR_syscalls) {
 		unsigned long ret = EXECUTE_SYSCALL(syscall, regs);
 
-- 
2.39.5



