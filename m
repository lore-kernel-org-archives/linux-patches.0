Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F41F2F2D;
	Tue, 27 Feb 2024 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041452; cv=none; b=QxWzoMP7QhKp21WV8P+Fx4cDNJRaI5bQIHpc3zFDEfkWLeFclTUXS5gGGbh8/YqeTsfNyJi7fPvnktvnlCJo+k+7DnGsonGUobTkXoKgWfg/2v+oz9N/dm0C3zVhed9av9XWw6bCc8NNLyumlPJcCXx1mQ1Yf04v5sl9rKauCrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041452; c=relaxed/simple;
	bh=iQ8Wodz4oFKhAJFuy0ZujvH83AHamVrSr2e5E3q1G2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkcuSdGHuI73orByOkBbec3a4X6qV2hAJw8uN0RcHt2AoheMukZAn6009y67LXCHrbJLoZOnDQui4WfT9vaF+pSA++YcH24FT7sAR7hzz5XTEiTX2mRqTyRI/Ioa/sJZPCmzmMAVf6IbK/3a1esEnU5xwI8yzD2kzf7c4Iby/ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyr0n8Aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyr0n8Aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCC0C433F1;
	Tue, 27 Feb 2024 13:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041452;
	bh=iQ8Wodz4oFKhAJFuy0ZujvH83AHamVrSr2e5E3q1G2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyr0n8AqE54jVly48elaIuokdLhYLiOj3u4mJ/H2QJxrxr80xuYbrfCU+oyoxisHG
	 dtOvk0xXl8K+b1WvGUB77flj7U5V3c0Reya6aBYscq1vQPQzTh4At0EFYzL2dlqrX8
	 3Fpk3zYQAD/1mJQAUXNN924FOYd1ji0GBcdW8fIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Petr Vorel <pvorel@suse.cz>,
	Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4.19 10/52] sched/rt: sysctl_sched_rr_timeslice show default timeslice after reset
Date: Tue, 27 Feb 2024 14:25:57 +0100
Message-ID: <20240227131548.871065821@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Hrubis <chrubis@suse.cz>

[ Upstream commit c1fc6484e1fb7cc2481d169bfef129a1b0676abe ]

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
Link: https://lore.kernel.org/r/20230802151906.25258-3-chrubis@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/rt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2735,6 +2735,9 @@ int sched_rr_handler(struct ctl_table *t
 		sched_rr_timeslice =
 			sysctl_sched_rr_timeslice <= 0 ? RR_TIMESLICE :
 			msecs_to_jiffies(sysctl_sched_rr_timeslice);
+
+		if (sysctl_sched_rr_timeslice <= 0)
+			sysctl_sched_rr_timeslice = jiffies_to_msecs(RR_TIMESLICE);
 	}
 	mutex_unlock(&mutex);
 


