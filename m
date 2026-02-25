Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474052701DA;
	Wed, 25 Feb 2026 01:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983779; cv=none; b=X7BGZJsGAYuPOhCz8qvTET4gxVMZWpU/bfTzUbe1NkKe7bcUuBPF6gfWH1vSffIlmtatNYVkprYs3nk7ICPEagzdEuoLWG2gunrYxGOG0kJG/mLPkmzyNKAfzlk5TvC9AZYKZYv8kP1BpwI+wcgh4Z7opEYIYAVuKq+6cZQU3D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983779; c=relaxed/simple;
	bh=6ZSeSPJgTNbe8fl5YhDbXPwHytz8ziITVDbU3LQ/eqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D55ci630uKqOIUPB1U/+rhVNSdEGvaFrIlZiw0T/h/tmE/Q6Pta44xmwba/0XUtyTTSc/3F5NUalmGs+1w0uyOD6GS4mHMsj2a0XqDg481KSRaAsGNPyY/B9Q2sYOdffRF7ag4IX7q7xXVQdmpIXc0S+T5FF6H6EWvQirMkzUCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQBeHeGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQBeHeGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7642C2BC86;
	Wed, 25 Feb 2026 01:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983778;
	bh=6ZSeSPJgTNbe8fl5YhDbXPwHytz8ziITVDbU3LQ/eqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQBeHeGNMxguR9yQOsIy/rRhysEcy7La2AoVdx7JOUk6iYk3u8PXEr9RsxCbh8741
	 ZweHIjkbSb0pU1sIogicF8P6aYHDIGT+inMHoePqNOxl5BlMErW7a6OOmLkuAzgpNA
	 v1Z/jchmTTq4VCeugMXZ3t3UWue/RyBJtpHwf/B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/641] sched: Export hidden tracepoints to modules
Date: Tue, 24 Feb 2026 17:16:34 -0800
Message-ID: <20260225012350.709412843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 6c125b85f3c87b4bf7dba91af6f27d9600b9dba0 ]

The tracepoints sched_entry, sched_exit and sched_set_need_resched
are not exported to tracefs as trace events, this allows only kernel
code to access them. Helper modules like [1] can be used to still have
the tracepoints available to ftrace for debugging purposes, but they do
rely on the tracepoints being exported.

Export the 3 not exported tracepoints.
Note that sched_set_state is already exported as the macro is called
from modules.

[1] - https://github.com/qais-yousef/sched_tp.git

Fixes: adcc3bfa8806 ("sched: Adapt sched tracepoints for RV task model")
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Link: https://patch.msgid.link/20251205131621.135513-9-gmonaco@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e460c22de8ad4..c1e4d8a5947cf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -119,6 +119,9 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(sched_util_est_cfs_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_util_est_se_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_update_nr_running_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_compute_energy_tp);
+EXPORT_TRACEPOINT_SYMBOL_GPL(sched_entry_tp);
+EXPORT_TRACEPOINT_SYMBOL_GPL(sched_exit_tp);
+EXPORT_TRACEPOINT_SYMBOL_GPL(sched_set_need_resched_tp);
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 DEFINE_PER_CPU(struct rnd_state, sched_rnd_state);
-- 
2.51.0



