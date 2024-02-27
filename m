Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5282C13A26F;
	Tue, 27 Feb 2024 14:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043260; cv=none; b=Zk/d6ITzuhMkruhWq/AYX85EaL34C/2oMRznpbO/lsSx7XIYlUNYO3gwqiFDGpbpD0XYOGVCZ6KkwxcqtZq4uE3IkD2Zw/WcRLiEWgGUgHITCZBzI/tRTbSfnJ5uMMk+m/G2yPJH/FFgvWdXu1jVgQZhJFJzsdd5Eu69DCVClFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043260; c=relaxed/simple;
	bh=GJ9As2gQOoxoR67owkBSoVy4s+4zi7ZCttDB8kf+lVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpzYZ5d/Xd7qy6k4zwRYiFk2UwCjvJlYKW3fS41u/PfBGB5H+/vmdsXy/3gBBQbf0dhfjDlSCPOilIbXQMOAIa9uVb1R4SQdtSjXa4G0RRKBZG3jfAoA0NiWbYI5kOJa3fK+ZBizDQCOwuH9MtG4xfIMyaBO91UfcLsROEfSnLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIO0jCiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIO0jCiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA83FC433F1;
	Tue, 27 Feb 2024 14:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043260;
	bh=GJ9As2gQOoxoR67owkBSoVy4s+4zi7ZCttDB8kf+lVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIO0jCiquxW0T9ky11yNUu8/17E/Dk8Glruy5//VZ8YchQYjgSaliWsabtJmPrXiK
	 sg0EecV2bKvoB8xuqG+VP+AZBYgiXwN/78thpn8fyXsSdQM7zhdRuOG47nmeATjAyW
	 2k52p4u6foiSXTqN0p9/nCWDIlc6UwYdW2mNck64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Petr Vorel <pvorel@suse.cz>,
	Mel Gorman <mgorman@suse.de>,
	Mahmoud Adam <mngyadam@amazon.com>
Subject: [PATCH 6.1 005/195] sched/rt: sysctl_sched_rr_timeslice show default timeslice after reset
Date: Tue, 27 Feb 2024 14:24:26 +0100
Message-ID: <20240227131610.577414025@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3048,6 +3048,9 @@ static int sched_rr_handler(struct ctl_t
 		sched_rr_timeslice =
 			sysctl_sched_rr_timeslice <= 0 ? RR_TIMESLICE :
 			msecs_to_jiffies(sysctl_sched_rr_timeslice);
+
+		if (sysctl_sched_rr_timeslice <= 0)
+			sysctl_sched_rr_timeslice = jiffies_to_msecs(RR_TIMESLICE);
 	}
 	mutex_unlock(&mutex);
 


