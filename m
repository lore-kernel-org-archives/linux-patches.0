Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A822E1465A8;
	Tue, 25 Jun 2024 09:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308724; cv=none; b=J8vuMMzwcAybBtV5yYFCNfVrbeACXs8iqVsb6BVFXFiyPt/pROUGB+IbzJzyz3FbYl+w6cix5PHj36p1kK+5q12/7ob5tZyq4J+E+Q2tJdvqw9IhnGuTVbpQv2qOwjhxEVMHZRnr2hw8HviPKyaiCHMPIN1d48jiC1bb+NkpymM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308724; c=relaxed/simple;
	bh=hfl1LaoZByv/T3Lflb+wzHiNsMzzxYgOWc7Ji74OVh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOw5iWJwkl2kX3ffHTZHJJEguDNPv6ivtmWDbzxuyFPn08JlaVzelk+UPbAkBEw89oxlBfF9oS+gK/pZs4g78hkUVUSA2INT91gTKGKXP8xzq0UeuPwXZsbgAmqvljLAqmZQO8Ui3rpiSxF02/1RcORAeegS/D/45uXLGBOGzDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDf70H/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDf70H/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23321C32781;
	Tue, 25 Jun 2024 09:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308724;
	bh=hfl1LaoZByv/T3Lflb+wzHiNsMzzxYgOWc7Ji74OVh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDf70H/QHjsUnOYhESQTsGEazLlqr3szReeB63X3gQpOlqBMI3bQrmWVtZsRRBx+Z
	 uV9MbuW4vqN1jZFgYnRpwS3SYwQ3St4Tggk9CC6BSkjFbFV/jBq9Cq6vQLZ224UBrT
	 //kyou3NykrGCFyZtLC3nsSthEj9eVvTfdb/2XZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Nogikh <nogikh@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 218/250] kcov: dont lose track of remote references during softirqs
Date: Tue, 25 Jun 2024 11:32:56 +0200
Message-ID: <20240625085556.420506672@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

commit 01c8f9806bde438ca1c8cbbc439f0a14a6694f6c upstream.

In kcov_remote_start()/kcov_remote_stop(), we swap the previous KCOV
metadata of the current task into a per-CPU variable.  However, the
kcov_mode_enabled(mode) check is not sufficient in the case of remote KCOV
coverage: current->kcov_mode always remains KCOV_MODE_DISABLED for remote
KCOV objects.

If the original task that has invoked the KCOV_REMOTE_ENABLE ioctl happens
to get interrupted and kcov_remote_start() is called, it ultimately leads
to kcov_remote_stop() NOT restoring the original KCOV reference.  So when
the task exits, all registered remote KCOV handles remain active forever.

The most uncomfortable effect (at least for syzkaller) is that the bug
prevents the reuse of the same /sys/kernel/debug/kcov descriptor.  If
we obtain it in the parent process and then e.g.  drop some
capabilities and continuously fork to execute individual programs, at
some point current->kcov of the forked process is lost,
kcov_task_exit() takes no action, and all KCOV_REMOTE_ENABLE ioctls
calls from subsequent forks fail.

And, yes, the efficiency is also affected if we keep on losing remote
kcov objects.
a) kcov_remote_map keeps on growing forever.
b) (If I'm not mistaken), we're also not freeing the memory referenced
by kcov->area.

Fix it by introducing a special kcov_mode that is assigned to the task
that owns a KCOV remote object.  It makes kcov_mode_enabled() return true
and yet does not trigger coverage collection in __sanitizer_cov_trace_pc()
and write_comp_data().

[nogikh@google.com: replace WRITE_ONCE() with an ordinary assignment]
  Link: https://lkml.kernel.org/r/20240614171221.2837584-1-nogikh@google.com
Link: https://lkml.kernel.org/r/20240611133229.527822-1-nogikh@google.com
Fixes: 5ff3b30ab57d ("kcov: collect coverage from interrupts")
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kcov.h |    2 ++
 kernel/kcov.c        |    1 +
 2 files changed, 3 insertions(+)

--- a/include/linux/kcov.h
+++ b/include/linux/kcov.h
@@ -21,6 +21,8 @@ enum kcov_mode {
 	KCOV_MODE_TRACE_PC = 2,
 	/* Collecting comparison operands mode. */
 	KCOV_MODE_TRACE_CMP = 3,
+	/* The process owns a KCOV remote reference. */
+	KCOV_MODE_REMOTE = 4,
 };
 
 #define KCOV_IN_CTXSW	(1 << 30)
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -631,6 +631,7 @@ static int kcov_ioctl_locked(struct kcov
 			return -EINVAL;
 		kcov->mode = mode;
 		t->kcov = kcov;
+	        t->kcov_mode = KCOV_MODE_REMOTE;
 		kcov->t = t;
 		kcov->remote = true;
 		kcov->remote_size = remote_arg->area_size;


