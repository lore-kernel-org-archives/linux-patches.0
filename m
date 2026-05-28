Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC552DF6E6;
	Thu, 28 May 2026 20:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999448; cv=none; b=sC4sXxvB5mymb/ajZ9YHLYTOvdTifr4kisf1p5Z7Z09UqHuH3hDgIhW57K7xW1AWKWb9lHg0++8UW0SfGDPQKeBN0tslmsEx2Dr/eIewgpWdfaqth0Yh1BxBhT/yHUBv0ix9nzKCEpMCy03sJXsy879ZFMLoNVqXsrplZS79hzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999448; c=relaxed/simple;
	bh=yohtCIB1p3ZT5hEjV0L0rjH9SIQKqpkgJtmRVSEhgpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEQcyHdvSRzW1eHYt9b1Az2aN/PN30Y0Fc3qui6l3KA1pBToEKItGaoAFSCpoUtNqvk3KSU2GwVV/SOWkVwAEuuolRbdN80IAhVXB+iHrcj4PauCat/HyRka2EzUanKKNynJIVvOtgzYqxdbz1xzW8lHCZ5aFU2eTvDbLmFHs14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPu9r8nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPu9r8nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C221F000E9;
	Thu, 28 May 2026 20:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999447;
	bh=FC95Ap7d7+/aILw4Q2/2fEr4RtLPvDG2y+yIy+nmAP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPu9r8nnxvUpyPG+8Bk3rC4nMfElVIiARWXJjDFYTC6NBXy/cSPUI1/lbcmnXB208
	 5ge1npgSYU7RYPrak+OqjkfdYneRttH/nGorRZo9C5qiarcMfMlDhgjyg5ONsE8Z9V
	 YfdKXLbsJ62YRTGx8+0tIFFLYsdhxNtEMQMPcGro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuele Mariotti <smariotti@disroot.org>,
	Paolo Valente <paolo.valente@unimore.it>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/377] sched_ext: Fix missing warning in scx_set_task_state() default case
Date: Thu, 28 May 2026 21:45:07 +0200
Message-ID: <20260528194640.361004073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuele Mariotti <smariotti@disroot.org>

[ Upstream commit b905ee77d5f557a83a485b4146210f54f13365fc ]

In scx_set_task_state(), the default case was setting the
warn flag, but then returning immediately. This is problematic
because the only purpose of the warn flag is to trigger
WARN_ONCE, but the early return prevented it from ever firing,
leaving invalid task states undetected and untraced.

To fix this, a WARN_ONCE call is now added directly in the
default case.

The fix addresses two aspects:

 - Guarantees the invalid task states are properly logged
   and traced.

 - Provides a distinct warning message
   ("sched_ext: Invalid task state") specifically for
   states outside the defined scx_task_state enum values,
   making it easier to distinguish from other transition
   warnings.

This ensures proper detection and reporting of invalid states.

Signed-off-by: Samuele Mariotti <smariotti@disroot.org>
Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 9a415cc53711 ("sched_ext: Avoid UAF in scx_root_enable_workfn() init failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2800,7 +2800,8 @@ static void scx_set_task_state(struct ta
 		warn = prev_state != SCX_TASK_READY;
 		break;
 	default:
-		warn = true;
+		WARN_ONCE(1, "sched_ext: Invalid task state %d -> %d for %s[%d]",
+			  prev_state, state, p->comm, p->pid);
 		return;
 	}
 


