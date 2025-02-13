Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561C526B0BC;
	Thu, 13 Feb 2025 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459975; cv=none; b=UwJRx4G6s4veipCp0lcIr+ho8Da9dUiYBUmdoX/rJKgbTMMkCPcNSq870ByKl1/IYR953rMuyqrWu49q80nAQWjSiKfH9v/hOhWeL8uInlHfgHGXFcViYA2Q0fy2IhBnf77oOfRUFQOHu0yAXfvM+gyRXmTRMHmBrfSk0htQ+xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459975; c=relaxed/simple;
	bh=GXY5J9P9U48pBrVNLFK2v6Ysu/1Uuzg9j0OJzEFuGcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClwLA5U+/PCVnNeqtlyig7cx6MRZscMiYk5uaE3RB3UBwtxHFkr/9d0/SdeTJSQQN1aePY8jJZl2TFPA/peheSaEw9+5KzyxbsGCWTO2KbJbpPxNxBLYq++gQpZqCInFIX+6mX4ZuNpkPhlto9CwpNTK2G6gSqm1s0JM0uAsjp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQERpQkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQERpQkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E5BC4CED1;
	Thu, 13 Feb 2025 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459974;
	bh=GXY5J9P9U48pBrVNLFK2v6Ysu/1Uuzg9j0OJzEFuGcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQERpQkCIEeoj9KpamLTgJvAkjXrRhx0RSIUSzveY3K31ZDlZFcOpXTRJ2L8yxGpl
	 jgHVg4JsjyUs8y3udb+marpu62kQ4c91as9GnVNQVhQ4WYIXmW9hS61AfhFzxTZra3
	 aL1XsJtVDt76HPcDMmug+i/WJE2vDC2/FOqBIyeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 421/443] rtla/timerlat_hist: Set OSNOISE_WORKLOAD for kernel threads
Date: Thu, 13 Feb 2025 15:29:46 +0100
Message-ID: <20250213142456.861818647@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

commit d8d866171a414ed88bd0d720864095fd75461134 upstream.

When using rtla timerlat with userspace threads (-u or -U), rtla
disables the OSNOISE_WORKLOAD option in
/sys/kernel/tracing/osnoise/options. This option is not re-enabled in a
subsequent run with kernel-space threads, leading to rtla collecting no
results if the previous run exited abnormally:

$ rtla timerlat hist -u
^\Quit (core dumped)
$ rtla timerlat hist -k -d 1s
Index
over:
count:
min:
avg:
max:
ALL:        IRQ       Thr       Usr
count:        0         0         0
min:          -         -         -
avg:          -         -         -
max:          -         -         -

The issue persists until OSNOISE_WORKLOAD is set manually by running:
$ echo OSNOISE_WORKLOAD > /sys/kernel/tracing/osnoise/options

Set OSNOISE_WORKLOAD when running rtla with kernel-space threads if
available to fix the issue.

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Link: https://lore.kernel.org/20250107144823.239782-3-tglozar@redhat.com
Fixes: ed774f7481fa ("rtla/timerlat_hist: Add timerlat user-space support")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_hist.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -1100,12 +1100,15 @@ timerlat_hist_apply_config(struct osnois
 		}
 	}
 
-	if (params->user_hist) {
-		retval = osnoise_set_workload(tool->context, 0);
-		if (retval) {
-			err_msg("Failed to set OSNOISE_WORKLOAD option\n");
-			goto out_err;
-		}
+	/*
+	* Set workload according to type of thread if the kernel supports it.
+	* On kernels without support, user threads will have already failed
+	* on missing timerlat_fd, and kernel threads do not need it.
+	*/
+	retval = osnoise_set_workload(tool->context, params->kernel_workload);
+	if (retval < -1) {
+		err_msg("Failed to set OSNOISE_WORKLOAD option\n");
+		goto out_err;
 	}
 
 	return 0;


