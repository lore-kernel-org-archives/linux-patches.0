Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1511C6FF9;
	Wed,  5 Mar 2025 18:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197762; cv=none; b=Z0GW9zlwQJHVGOrvk/Ba350o5dsXEwQ4stKAEDAY3V2zBmn+TIFHVEIOBu3xx2IOeihgVOjW3JfFYZ9rhEXx0k6C1Yi1IxO5wOKp7qDkeMr8xpH0fx/dA5ud/1nT9wXk4NSRFvLEdBlIBxqYFyPW4abPl8gdifAz8aBcDzHKOoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197762; c=relaxed/simple;
	bh=1AtMrMf5VJEi8NbDO34+zi/SeHQXFjoc0WMxb5SmpI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4X9VvAg/vglWJgAKnPUSrOp2AJld8XJBnyPm0SokauNym5159wLMSHM3GoHmrzpsLJIdC7KHa5/izINu+ojeej3kh543fWhJFLwVsRYWE3N2hjWQBl+4sy0Z8pa7gXVnAS8N8WIB2eN3/ugIE8P2+9aoXg6l4A5dWd6PpyzASI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B08dciil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B08dciil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13821C4CED1;
	Wed,  5 Mar 2025 18:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197762;
	bh=1AtMrMf5VJEi8NbDO34+zi/SeHQXFjoc0WMxb5SmpI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B08dciil8vz38PnJzmjouKo6tNl4pamDkw962bDc94OzP2CLDExHv27/c1WeUcUkg
	 GZE5W8O2q9iFVLAeGGpcwQpbFCzi82f63HIjswED3rfyhbuRlCM4b63/qhcbu7aXiE
	 J5VDRsUvOpmhz8AFy0HLLIyDcPjjn5kRyMnNe0ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 091/142] rtla/timerlat_hist: Set OSNOISE_WORKLOAD for kernel threads
Date: Wed,  5 Mar 2025 18:48:30 +0100
Message-ID: <20250305174503.989988462@linuxfoundation.org>
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
[ params->kernel_workload does not exist in 6.6, use
!params->user_hist ]
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_hist.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -900,12 +900,15 @@ timerlat_hist_apply_config(struct osnois
 		auto_house_keeping(&params->monitored_cpus);
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
+	retval = osnoise_set_workload(tool->context, !params->user_hist);
+	if (retval < -1) {
+		err_msg("Failed to set OSNOISE_WORKLOAD option\n");
+		goto out_err;
 	}
 
 	return 0;


