Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F318C15B10D;
	Mon, 28 Oct 2024 06:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097463; cv=none; b=Z9wxgq8kJXBX5BxQck3OuQ292im3nbCbWoUQclXpfsju/vfinjUoRwbLxInXmn+AUTxRrWGGJtz4EofJw7xBBNvUb0pnPab3hV+PItOMc15uMIuiyzhdC2VMW7dJ9P/P6tV8LksxbOOB31brAfssZriwgv7HafeKIoq0hyquiCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097463; c=relaxed/simple;
	bh=T7y5af1uAyjpEfREG+/TLgvR9pPdCFhiWtsBM7E37EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhrG3A4Pic4BqALmgPjNkIfNL7vCUTJuhDVaR/Qd/zmoF5S9b52MaPGKzI0mEolpupW71f5pdmw3jnGjb1hS/5wXX4vOEWB4Bp4mPd9QtIfoklPIndF3+Jo691irfMoZvUHX0LAneDvdyG1De86xx86b/Vz2CWjb1Nc4/2D8VxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLibwTfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLibwTfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94342C4CEC3;
	Mon, 28 Oct 2024 06:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097462;
	bh=T7y5af1uAyjpEfREG+/TLgvR9pPdCFhiWtsBM7E37EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLibwTfXAUzQDSbBAkO0HdZhpRRveko5adUO5FhprwvgWLKuyWEEzizGXSqRG4Pfb
	 gLrsQjZ7sCFHgs1r5EHGuMeRlSNDAfSwN0pGefK+8ws8hLPQCgjUXingYHLK963rZ7
	 M2ncnC16QIrbbDFPVGJaqUryju7vXe9EoSUmoztQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/137] bpf,perf: Fix perf_event_detach_bpf_prog error handling
Date: Mon, 28 Oct 2024 07:25:44 +0100
Message-ID: <20241028062301.708317392@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 0ee288e69d033850bc87abe0f9cc3ada24763d7f ]

Peter reported that perf_event_detach_bpf_prog might skip to release
the bpf program for -ENOENT error from bpf_prog_array_copy.

This can't happen because bpf program is stored in perf event and is
detached and released only when perf event is freed.

Let's drop the -ENOENT check and make sure the bpf program is released
in any case.

Fixes: 170a7e3ea070 ("bpf: bpf_prog_array_copy() should return -ENOENT if exclude_prog not found")
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241023200352.3488610-1-jolsa@kernel.org

Closes: https://lore.kernel.org/lkml/20241022111638.GC16066@noisy.programming.kicks-ass.net/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3fdde232eaa92..583961a9e539a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2179,8 +2179,6 @@ void perf_event_detach_bpf_prog(struct perf_event *event)
 
 	old_array = bpf_event_rcu_dereference(event->tp_event->prog_array);
 	ret = bpf_prog_array_copy(old_array, event->prog, NULL, 0, &new_array);
-	if (ret == -ENOENT)
-		goto unlock;
 	if (ret < 0) {
 		bpf_prog_array_delete_safe(old_array, event->prog);
 	} else {
-- 
2.43.0



