Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F911C6FF9;
	Wed,  5 Mar 2025 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197765; cv=none; b=GpOT8phsl12qhjMBE/i4R16Lf1kWkL7i7lzaA+TmWK7jzAC7/OfbVumTpdn9x9Ec8mSgfI549LHlYov56DF2zCqUNAWQRVzbcaanc5KOovN52mRRjv6M6c/y7eF71YSJy672yVk/bvrqij1SdkH6AzA+mec5PciydNreDjoT5fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197765; c=relaxed/simple;
	bh=Kz3QaTkfZHqi0EwrmZQ6JrZkgFoux+hede0V99qcVnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2mITGvtcecMIQEX/27cpBSoJBQ07qE7hAY+CeqrHQbUFoVLCDnhaEv4fZd6KMyaPCFk2Nq4STQ+FXrpPUxZpVKiNHXZFsa7jetNPHIe2Agmt5k2HEArDKK4muEJ7dZ+0YnKoDymR9ZTzZDh4w4uSZQk7rO4XWonmhTJWoCjanI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqE3+E17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqE3+E17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CB7C4CED1;
	Wed,  5 Mar 2025 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197765;
	bh=Kz3QaTkfZHqi0EwrmZQ6JrZkgFoux+hede0V99qcVnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqE3+E17m2SNfOgMt56ZhmFN6JUv9UnkjpaPHcmvfRcH/ScFC0GgvJactJdoBe6gP
	 bcpV2LRh2dxN9i6kCneWm1sMA3HA2714ILiaJcFGZD5W8v3M7+RVtapOAKUkPhYDgO
	 4efEekcw/VNEE7oTbiZZ8SMhFMoFXUwKOsEXK86I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 092/142] rtla/timerlat_top: Set OSNOISE_WORKLOAD for kernel threads
Date: Wed,  5 Mar 2025 18:48:31 +0100
Message-ID: <20250305174504.030709531@linuxfoundation.org>
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

commit 217f0b1e990e30a1f06f6d531fdb4530f4788d48 upstream.

When using rtla timerlat with userspace threads (-u or -U), rtla
disables the OSNOISE_WORKLOAD option in
/sys/kernel/tracing/osnoise/options. This option is not re-enabled in a
subsequent run with kernel-space threads, leading to rtla collecting no
results if the previous run exited abnormally:

$ rtla timerlat top -u
^\Quit (core dumped)
$ rtla timerlat top -k -d 1s
                                     Timer Latency
  0 00:00:01   |          IRQ Timer Latency (us)        |         Thread Timer Latency (us)
CPU COUNT      |      cur       min       avg       max |      cur       min       avg       max

The issue persists until OSNOISE_WORKLOAD is set manually by running:
$ echo OSNOISE_WORKLOAD > /sys/kernel/tracing/osnoise/options

Set OSNOISE_WORKLOAD when running rtla with kernel-space threads if
available to fix the issue.

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Link: https://lore.kernel.org/20250107144823.239782-4-tglozar@redhat.com
Fixes: cdca4f4e5e8e ("rtla/timerlat_top: Add timerlat user-space support")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[ params->kernel_workload does not exist in 6.6, use
!params->user_top ]
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_top.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -679,12 +679,15 @@ timerlat_top_apply_config(struct osnoise
 		auto_house_keeping(&params->monitored_cpus);
 	}
 
-	if (params->user_top) {
-		retval = osnoise_set_workload(top->context, 0);
-		if (retval) {
-			err_msg("Failed to set OSNOISE_WORKLOAD option\n");
-			goto out_err;
-		}
+	/*
+	* Set workload according to type of thread if the kernel supports it.
+	* On kernels without support, user threads will have already failed
+	* on missing timerlat_fd, and kernel threads do not need it.
+	*/
+	retval = osnoise_set_workload(top->context, !params->user_top);
+	if (retval < -1) {
+		err_msg("Failed to set OSNOISE_WORKLOAD option\n");
+		goto out_err;
 	}
 
 	return 0;


