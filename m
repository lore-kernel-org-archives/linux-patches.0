Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E0C3D0907;
	Tue, 21 Jul 2026 18:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657103; cv=none; b=auDSOUH5k9+p2nc0+9GoCVJ8jhiqcdtlx8a5LHRkCu6QzzWVXQG441d3onRbU40mGAELLQl3bTKDTLdQMBMzd1fhKe+cM79UtZyCJqmVOH09iqlLekSwz06AY8OLlHu8q6309b/21o0lE4DY0XZqo6MPdQp/8XEKCVZsGjcv4U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657103; c=relaxed/simple;
	bh=gVV+eXbhUs/YYWu926qzjF1nIepANlUroNKFPjUO1Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXCIu3cMQtjZi85F3hPGTXVyj0AhDsouBFZnkL7/2yfjRUNAjaWZ+UeZOH8xZqy8JRZCOj5n/69/7+IixyiYnaQK2LHpX1pHJ2dQyNF8NXENMCzqhOp5WGtrcAqNblK8aAaYhDAIuNaDk6QOcKH8O3CZKzDDPREm6F4NfmmeAZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGpf+vo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGpf+vo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA6B1F000E9;
	Tue, 21 Jul 2026 18:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657102;
	bh=OVfglnZGQqlD0WyezZpByUCLDXBebxiyyKkX8igrs/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGpf+vo4CY//ek4rucOI+E+s7iVPbAfzrxFln0T/Wjn3vzuG7jJWNLkZefODD2Fu5
	 0l+Vvr6PHHvydlVP1pChVZyqou7rFQcH/GRcXgqzZDQYBS35P7UaR1RmtxLauK9RQ4
	 JyR1KkZ9/IRy8GO2Ejri5e0MxIjjFfM+E5vcB6as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0637/1611] perf sched: Fix thread reference leak in latency_switch_event
Date: Tue, 21 Jul 2026 17:12:33 +0200
Message-ID: <20260721152529.718322785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 66ea9de60396a4dea5276bc87025884691876c36 ]

In latency_switch_event(), after acquiring thread references for
sched_out and sched_in via machine__findnew_thread(), the first
add_sched_out_event() failure path does 'return -1', bypassing the
out_put label that calls thread__put() on both references.

The second and third add_sched_out_event() failures correctly use
'goto out_put'.  Fix the first one to match.

Fixes: b91fc39f4ad7 ("perf machine: Protect the machine->threads with a rwlock")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 8310aa23cbb3c5..723a4ca059cc39 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1170,7 +1170,7 @@ static int latency_switch_event(struct perf_sched *sched,
 		}
 	}
 	if (add_sched_out_event(out_events, prev_state, timestamp))
-		return -1;
+		goto out_put;
 
 	in_events = thread_atoms_search(&sched->atom_root, sched_in, &sched->cmp_pid);
 	if (!in_events) {
-- 
2.53.0



