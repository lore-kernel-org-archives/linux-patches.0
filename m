Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF1A145327;
	Tue, 27 Feb 2024 14:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043967; cv=none; b=tMFTuPeonZSfo0IU7UCQ2NQ/w7gO5Q85uW7VQRmALAnHTww94ydKj5yfxJHj4kR1m0SIt4b2LJIppK5ZIsClkz7JhzxWRN7T1NEpcg6qVKVaf0MagXAY0t9I2xEAMlzh5txMJO6BAYqqcvvadNT+lLVXj+09ouLekcirPhigKmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043967; c=relaxed/simple;
	bh=Kv7A76bTvgHMLnwxeL/eI+mV+6UA7NSbHGUsajYjNCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMQcHFbSyKKgqEKyZuGJQ2cFnuETGbGx2pt2u5a24ZXyuaiQBlaZywxCUzvjc25At3WeO9DSQ1YbnUbhUEAWMctXIr2fUCh7FmTyqSPkUm9tEic/Q+nKK3o20bJDMkLy+iMeekIwmotOw1babqo+ZnuQ14hQqPAbvpEiXWgwP7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrMzztDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrMzztDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5918DC433F1;
	Tue, 27 Feb 2024 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043967;
	bh=Kv7A76bTvgHMLnwxeL/eI+mV+6UA7NSbHGUsajYjNCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrMzztDNLSOWgo6nyINMXGjlXz314x78AaPJjHO1ieIHYNbiy2Pm2dMwa7Wlos2jq
	 D5EbieotRjrNsfNgrFCUbux0IJrYZNO43QKfjg+c7qhO7RkKNltKRUQ923ugGq03hW
	 EKuMxAmgycKClQt5dtTPWRlFMQhjBgHWHs6pLIeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Petr Vorel <pvorel@suse.cz>,
	Mel Gorman <mgorman@suse.de>,
	Mahmoud Adam <mngyadam@amazon.com>
Subject: [PATCH 5.10 007/122] sched/rt: sysctl_sched_rr_timeslice show default timeslice after reset
Date: Tue, 27 Feb 2024 14:26:08 +0100
Message-ID: <20240227131558.942972892@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Hrubis <chrubis@suse.cz>

commit c1fc6484e1fb7cc2481d169bfef129a1b0676abe upstream.

The sched_rr_timeslice can be reset to default by writing value that is
<= 0. However after reading from this file we always got the last value
written, which is not useful at all.

$ echo -1 > /proc/sys/kernel/sched_rr_timeslice_ms
$ cat /proc/sys/kernel/sched_rr_timeslice_ms
-1

Fix this by setting the variable that holds the sysctl file value to the
jiffies_to_msecs(RR_TIMESLICE) in case that <= 0 value was written.

Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Tested-by: Petr Vorel <pvorel@suse.cz>
Cc: Mahmoud Adam <mngyadam@amazon.com>
Link: https://lore.kernel.org/r/20230802151906.25258-3-chrubis@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/rt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2804,6 +2804,9 @@ int sched_rr_handler(struct ctl_table *t
 		sched_rr_timeslice =
 			sysctl_sched_rr_timeslice <= 0 ? RR_TIMESLICE :
 			msecs_to_jiffies(sysctl_sched_rr_timeslice);
+
+		if (sysctl_sched_rr_timeslice <= 0)
+			sysctl_sched_rr_timeslice = jiffies_to_msecs(RR_TIMESLICE);
 	}
 	mutex_unlock(&mutex);
 


